package com.pixelplex.doorchain.doorchain.presentation.register

import android.arch.lifecycle.MutableLiveData
import android.arch.lifecycle.ViewModel
import com.pixelplex.doorchain.doorchain.auth.AuthorizationRepository
import com.pixelplex.doorchain.doorchain.auth.RegistrationException
import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.framework.ContractService
import com.pixelplex.doorchain.doorchain.framework.EchoFrameworkService
import com.pixelplex.doorchain.doorchain.model.User
import kotlinx.coroutines.experimental.Job
import kotlinx.coroutines.experimental.android.UI
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.launch

class RegistrationViewModel(
        private val authorizationRepository: AuthorizationRepository,
        private val echoFrameworkService: EchoFrameworkService,
        private val userService: UserService,
        private val contractService: ContractService

) : ViewModel() {

    val registrationState = MutableLiveData<Unit>()
    val error = MutableLiveData<Exception>()

    private val job = Job()

    fun register(name: String, password: String, confPassword: String) {
        launch(UI, parent = job) {
            when {
                name.isEmpty() || name.isBlank() ->
                    error.postValue(RegistrationException(RegistrationException.ExceptionType.INCORRECT_ACCOUNT_NAME))
                password.isEmpty() || password.isBlank() ->
                    error.postValue(RegistrationException(RegistrationException.ExceptionType.INCORRECT_PASSWORD))
                confPassword != password ->
                    error.postValue(RegistrationException(RegistrationException.ExceptionType.PASSWORDS_DO_NOT_MATCH))
                else -> {
                    val loggedAsync = async { authorizationRepository.register(name, password) }

                    try {
                        if (loggedAsync.await()) {
                            val account = async { echoFrameworkService.getAccount(name) }.await()
                            val isOwner = async { contractService.isOwner(account.getObjectId()) }
                            userService.saveUser(User(account.name, account.getObjectId(), password, isOwner.await()))

                            registrationState.postValue(Unit)
                        }

                    } catch (ex: Exception) {
                        error.postValue(RegistrationException(RegistrationException.ExceptionType.INCORRECT_ACCOUNT_NAME))
                    }
                }
            }

        }
    }

    override fun onCleared() {
        super.onCleared()
        job.cancel()
    }
}
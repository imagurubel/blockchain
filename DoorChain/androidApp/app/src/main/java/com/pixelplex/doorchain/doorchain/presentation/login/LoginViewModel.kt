package com.pixelplex.doorchain.doorchain.presentation.login

import android.arch.lifecycle.MutableLiveData
import android.arch.lifecycle.ViewModel
import com.pixelplex.doorchain.doorchain.BaseActivityViewModel
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

class LoginViewModel(private val authorizationRepository: AuthorizationRepository,
                     private val frameworkService: EchoFrameworkService,
                     private val userService: UserService,
                     private val contractService: ContractService) : ViewModel() {

    val loginState = MutableLiveData<Any>()
    val error = MutableLiveData<Exception>()
    private val job = Job()

    fun login(name: String, password: String) {
        launch(UI, parent = job) {
            when {
                name.isEmpty() || name.isBlank() ->
                    error.postValue(RegistrationException(RegistrationException.ExceptionType.INCORRECT_ACCOUNT_NAME))
                password.isEmpty() || password.isBlank() ->
                    error.postValue(RegistrationException(RegistrationException.ExceptionType.INCORRECT_ACCOUNT_NAME))
                else -> {
                    val loggedAsync = async { authorizationRepository.login(name, password) }

                    try {
                        if (loggedAsync.await()) {
                            val account = async { frameworkService.getAccount(name) }.await()
                            val isOwner = async { contractService.isOwner(account.getObjectId()) }
                            userService.saveUser(User(account.name, account.getObjectId(), password, isOwner.await()))

                            loginState.postValue(Any())
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
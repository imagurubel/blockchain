package com.pixelplex.doorchain.doorchain.presentation.doors_details

import android.arch.lifecycle.MutableLiveData
import android.arch.lifecycle.ViewModel
import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.framework.ContractService
import com.pixelplex.doorchain.doorchain.framework.EchoFrameworkService
import com.pixelplex.doorchain.doorchain.model.User
import kotlinx.coroutines.experimental.*
import kotlinx.coroutines.experimental.android.UI

class DoorDetailsViewModel(private val doorId: String,
                           private val contractService: ContractService,
                           private val echoFrameworkService: EchoFrameworkService,
                           private val userService: UserService) : ViewModel() {

    val error = MutableLiveData<Exception>()
    val users = MutableLiveData<List<User>>()
    val userAdded = MutableLiveData<Any>()

    private val job = Job()

    fun fetchUsers() {
        launch(UI, parent = job) {
            val usersList = async { contractService.fetchUsersForDoor(doorId, userService.getUser()?.id!!) }
            users.postValue(usersList.await())
        }
    }

    fun addUser(user: String) {
        launch(UI, parent = job) {
            try {
                val accountId = async { echoFrameworkService.getAccount(user).getObjectId() }
                val password = userService.getUser()?.password

                withContext(DefaultDispatcher) {
                    contractService.addUserToDoor(userService.getUser()!!.name, accountId.await(), doorId, password!!)
                }
                userAdded.postValue(Any())
            } catch (ex: Exception) {
                error.postValue(ex)
            }
        }
    }

    fun removeUser(user: String) {
        launch(UI, parent = job) {
            try {
                val accountId = async { echoFrameworkService.getAccount(user).getObjectId() }
                val password = userService.getUser()?.password

                contractService.removeUserFromDoor(accountId.await(), doorId, password!!)
            } catch (ex: Exception) {
                error.postValue(ex)
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        job.cancel()
    }
}
package com.pixelplex.doorchain.doorchain.presentation.addDoor

import android.arch.lifecycle.MutableLiveData
import com.pixelplex.doorchain.doorchain.BaseViewModel
import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.framework.ContractService
import kotlinx.coroutines.experimental.android.UI
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.launch

class AddDoorViewModel(private val contractService: ContractService,
                       private val userService: UserService) : BaseViewModel() {

    val added = MutableLiveData<Boolean>()
    val error = MutableLiveData<Exception>()

    fun addDoor(doorId: String, doorName: String) {
        launch(UI, parent = job) {
            when {
                doorId.isEmpty() || doorId.isBlank() ->
                    error.postValue(IllegalArgumentException())
                doorName.isEmpty() || doorName.isBlank() ->
                    error.postValue(IllegalArgumentException())
                else -> {
                    val addedResult = async {
                        contractService.addDoor(doorId, doorName, userService.getUser()!!.name, userService.getUser()!!.password)
                    }

                    added.value = addedResult.await()
                }
            }
        }

    }
}
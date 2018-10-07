package com.pixelplex.doorchain.doorchain.presentation.main

import android.arch.lifecycle.MutableLiveData
import com.pixelplex.doorchain.doorchain.BaseViewModel
import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.framework.ContractService
import com.pixelplex.doorchain.doorchain.model.Door
import kotlinx.coroutines.experimental.android.UI
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.launch

class MainViewModel(private val userService: UserService, private val contractService: ContractService) : BaseViewModel() {

    val doors = MutableLiveData<List<Door>>()
    val openResult = MutableLiveData<Boolean>()

    fun tryOpen(doorId: String) {
        launch(UI, parent = job) {
            val user = userService.getUser()!!
            val opened = async { contractService.openDoor(doorId, user.name, user.password) }
            val hasAccess = async { contractService.hasAccess(doorId, user.id, user.password) }
            openResult.postValue(hasAccess.await() && opened.await())
        }
    }

    fun fetchDoors() {
        launch(UI, parent = job) {
            val doorsList = async {
                contractService.doors()
            }
            doors.value = doorsList.await()
        }
    }

    fun deleteDoor(door: Door) {
        launch(parent = job) {
            async { contractService.removeDoor(door.id, userService.getUser()!!.name, userService.getUser()!!.password) }
            val oldItems = doors.value!!.toMutableList()
            oldItems.remove(door)
            doors.postValue(oldItems)
        }
    }

}

package com.pixelplex.doorchain.doorchain

import android.arch.lifecycle.MutableLiveData
import com.pixelplex.doorchain.doorchain.framework.EchoFrameworkService
import kotlinx.coroutines.experimental.channels.ReceiveChannel
import kotlinx.coroutines.experimental.channels.consumeEach
import kotlinx.coroutines.experimental.launch

class BaseActivityViewModel(private val echoFrameworkService: EchoFrameworkService) : BaseViewModel() {

    val connectionState = MutableLiveData<Boolean>()

    private var channel: ReceiveChannel<Boolean>? = null

    fun reconnect() {
        launch {
            try {
                echoFrameworkService.restart()
            }catch (exception: Exception) {
                connectionState.postValue(false)
            }
        }
    }

    fun observeState() {
        launch {
            channel = echoFrameworkService.observeState()
            channel!!.consumeEach { state ->
                connectionState.postValue(state)
            }
        }
    }

    fun cancelStateObserve() {
        channel?.cancel()
        channel = null
    }

}
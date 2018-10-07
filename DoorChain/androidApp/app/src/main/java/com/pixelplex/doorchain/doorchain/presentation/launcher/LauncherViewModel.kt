package com.pixelplex.doorchain.doorchain.presentation.launcher

import android.arch.lifecycle.MutableLiveData
import android.arch.lifecycle.ViewModel
import com.pixelplex.doorchain.doorchain.framework.EchoFrameworkService
import kotlinx.coroutines.experimental.*
import kotlinx.coroutines.experimental.android.UI

class LauncherViewModel(private val echoFrameworkService: EchoFrameworkService) : ViewModel() {

    val startedLibrary = MutableLiveData<Any>()
    val error = MutableLiveData<Exception>()
    private val job = Job()

    fun initialize() {
        launch(UI, parent = job) {
            try {
                withContext(CommonPool) {
                    echoFrameworkService.restart()
                }
                startedLibrary.value = Any()
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
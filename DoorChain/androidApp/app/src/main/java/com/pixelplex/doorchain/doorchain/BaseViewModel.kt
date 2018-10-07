package com.pixelplex.doorchain.doorchain

import android.arch.lifecycle.ViewModel
import kotlinx.coroutines.experimental.Job

open class BaseViewModel : ViewModel() {

    protected val job = Job()

    override fun onCleared() {
        job.cancel()
    }

}
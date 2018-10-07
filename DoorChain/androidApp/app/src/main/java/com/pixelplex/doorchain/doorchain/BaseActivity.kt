package com.pixelplex.doorchain.doorchain

import android.support.v7.app.AppCompatActivity
import com.pixelplex.doorchain.doorchain.presentation.FullscreenLoaderDialog

abstract class BaseActivity : AppCompatActivity() {

    private val loader by lazy { FullscreenLoaderDialog(this) }

    fun showLoader() {
        loader.show()
    }

    fun hideLoader() {
        loader.dismiss()
    }


}
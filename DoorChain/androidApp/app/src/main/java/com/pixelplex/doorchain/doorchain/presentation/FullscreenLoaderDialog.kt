package com.pixelplex.doorchain.doorchain.presentation

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import com.pixelplex.doorchain.doorchain.R

class FullscreenLoaderDialog constructor(context: Context, theme: Int = R.style.LoaderDialog) : Dialog(context, theme) {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.dialog_progress)
        setCancelable(false)
        setOnDismissListener {
            it.dismiss()
        }
    }
    

}
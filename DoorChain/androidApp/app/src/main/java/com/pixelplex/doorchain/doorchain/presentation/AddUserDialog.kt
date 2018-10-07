package com.pixelplex.doorchain.doorchain.presentation

import android.content.Context
import android.support.v7.app.AppCompatDialog
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.view.Window

import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.hideSoftKeyboard
import com.pixelplex.doorchain.doorchain.inflate
import com.pixelplex.doorchain.doorchain.showSoftKeyboard
import kotlinx.android.synthetic.main.dialog_input.*

class AddUserDialog(context: Context) : AppCompatDialog(context) {

    init {
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(inflate<ViewGroup>(context, R.layout.dialog_input))

        window!!.setLayout(MATCH_PARENT, WRAP_CONTENT)

        setOnShowListener { showSoftKeyboard() }
        btnCancel.setOnClickListener { dismiss() }
    }

    override fun dismiss() {
        hideSoftKeyboard()
        super.dismiss()
    }

    /**
     * Defines listener of confirmation button
     */
    fun confirmButtonListener(listener: (String) -> Unit): AddUserDialog {
        btnConfirm.setOnClickListener(ConfirmListener(listener))
        return this
    }

    /**
     * Wrapper listener for confirmation button
     */
    inner class ConfirmListener(private val delegate: (String) -> Unit) : View.OnClickListener {

        override fun onClick(v: View?) {
            if (etLogin.text.isEmpty()) {
                return
            }
            this@AddUserDialog.dismiss()
            delegate(etLogin.text.toString())
        }

    }

}

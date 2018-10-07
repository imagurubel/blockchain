package com.pixelplex.doorchain.doorchain.presentation.launcher

import android.arch.lifecycle.Observer
import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.Toast
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.presentation.login.LoginActivity
import org.koin.android.architecture.ext.viewModel

class LauncherActivity : AppCompatActivity(), Observer<Any>  {

    private val viewModel by viewModel<LauncherViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_launcher)

        viewModel.startedLibrary.observe(this, this)

        viewModel.error.observe(this, Observer {
            it?.let {
                Toast.makeText(this, it.message, Toast.LENGTH_SHORT).show()
            }
            startLogin()
        })

        viewModel.initialize()
    }

    override fun onChanged(t: Any?) {
        startLogin()
    }

    private fun startLogin() {
        startActivity(Intent(this, LoginActivity::class.java))
        overridePendingTransition(R.anim.slide_up, R.anim.stay)
        finishAffinity()
    }
}
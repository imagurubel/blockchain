package com.pixelplex.doorchain.doorchain.presentation.login

import android.arch.lifecycle.Observer
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import com.pixelplex.doorchain.doorchain.BaseActivity
import com.pixelplex.doorchain.doorchain.BaseErrorActivity
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.auth.RegistrationException
import com.pixelplex.doorchain.doorchain.hideSoftKeyboard
import com.pixelplex.doorchain.doorchain.presentation.main.MainActivity
import com.pixelplex.doorchain.doorchain.presentation.register.RegisterActivity
import kotlinx.android.synthetic.main.activity_login.*
import org.koin.android.architecture.ext.viewModel

class LoginActivity : BaseErrorActivity() {

    private val viewModel by viewModel<LoginViewModel>()

    companion object {
        fun getIntent(context: Context): Intent = Intent(context, LoginActivity::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        initViews()
    }

    private fun initViews() {
        lytRoot.setOnFocusChangeListener { view, hasFocus ->
            if (hasFocus) {
                hideSoftKeyboard()
            }
        }

        initBackgroundStateForView(etLogin, vBgLogin)
        initBackgroundStateForView(etPassword, vBgPassword)

        tvEntire.setOnClickListener {
            startActivity(RegisterActivity.getIntent(this))
            finishWithSlideUp()
        }

        tvEnter.setOnClickListener {
            showLoader()
            lytRoot.requestFocus()
            viewModel.login(etLogin.text.toString(), etPassword.text.toString())
        }

        viewModel.loginState.observe(this, Observer {
            hideLoader()
            startActivity(Intent(this, MainActivity::class.java))
            finishWithStay()
        })

        viewModel.error.observe(this, Observer {
            (it as? RegistrationException)?.let {
                tvError.visibility = View.VISIBLE
            } ?: it?.let {
                Toast.makeText(this, it.message ?: "", Toast.LENGTH_SHORT).show()
            }
        })

    }

    private fun initBackgroundStateForView(mainView: View, viewBackground: View) {
        mainView.setOnFocusChangeListener { view, hasFocus ->
            clearError()
            viewBackground.setBackgroundResource(if (hasFocus) R.drawable.bg_text_input_selected else R.drawable.bg_text_input_unselected)
        }
    }

    private fun clearError() {
        tvError.visibility = View.GONE
        vBgLogin.setBackgroundResource(R.drawable.bg_text_input_unselected)
        vBgPassword.setBackgroundResource(R.drawable.bg_text_input_unselected)
    }

    private fun finishWithStay() {
        hideSoftKeyboard()
        finish()
        overridePendingTransition(R.anim.stay, R.anim.slide_down)
    }

    private fun finishWithSlideUp() {
        hideSoftKeyboard()
        finish()
        overridePendingTransition(R.anim.slide_up, R.anim.slide_down)
    }

}
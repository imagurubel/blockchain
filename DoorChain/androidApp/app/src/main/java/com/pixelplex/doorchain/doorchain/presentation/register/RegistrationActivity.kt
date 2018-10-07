package com.pixelplex.doorchain.doorchain.presentation.register

import android.arch.lifecycle.Observer
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.View
import android.widget.Toast
import com.pixelplex.doorchain.doorchain.BaseErrorActivity
import com.pixelplex.doorchain.doorchain.presentation.main.MainActivity
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.auth.RegistrationException
import com.pixelplex.doorchain.doorchain.hideSoftKeyboard
import com.pixelplex.doorchain.doorchain.presentation.login.LoginActivity
import kotlinx.android.synthetic.main.activity_registration.*
import org.koin.android.architecture.ext.viewModel

class RegisterActivity : BaseErrorActivity() {

    private val viewModel by viewModel<RegistrationViewModel>()

    companion object {
        fun getIntent(context: Context): Intent = Intent(context, RegisterActivity::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_registration)


        initViews()
        initOutputs()
    }

    private fun initViews() {
        lytRoot.onFocusChangeListener = View.OnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                hideSoftKeyboard()
            }
        }

        initBackgroundStateForView(etLogin, vBgLogin)
        initBackgroundStateForView(etPassword, vBgPassword)
        initBackgroundStateForView(etRepeatPassword, vBgRepeatPassword)

        tvEntire.setOnClickListener {
            startActivity(LoginActivity.getIntent(this))
            finishWithSlideUp()
        }

        tvEnter.setOnClickListener {
            lytRoot.requestFocus()
            viewModel.register(
                    etLogin.text.toString(),
                    etPassword.text.toString(),
                    etRepeatPassword.text.toString())
        }

    }

    private fun initOutputs() {
        viewModel.registrationState.observe(this, Observer {
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

    private fun clearError() {
        tvError.visibility = View.GONE

        vBgLogin.setBackgroundResource(R.drawable.bg_text_input_unselected)
        vBgPassword.setBackgroundResource(R.drawable.bg_text_input_unselected)
        vBgRepeatPassword.setBackgroundResource(R.drawable.bg_text_input_unselected)
    }

    private fun showError(message: String) {
        showError(message, ErrorField.UNKNOWN)
    }

    private fun showError(message: String, errorField: ErrorField) {
        when (errorField) {
            ErrorField.PASSWORD -> {
                etPassword.requestFocus()
                vBgPassword.setBackgroundResource(R.drawable.bg_text_input_error)
            }
            ErrorField.PASSWORDS -> {
                etPassword.requestFocus()
                vBgPassword.setBackgroundResource(R.drawable.bg_text_input_error)
                vBgRepeatPassword.setBackgroundResource(R.drawable.bg_text_input_error)
            }
            ErrorField.EMAIL -> {
                etLogin.requestFocus()
                vBgLogin.setBackgroundResource(R.drawable.bg_text_input_error)
            }
            else -> {
                etLogin.requestFocus()
                vBgLogin.setBackgroundResource(R.drawable.bg_text_input_error)
                vBgPassword.setBackgroundResource(R.drawable.bg_text_input_error)
                vBgRepeatPassword.setBackgroundResource(R.drawable.bg_text_input_error)
            }
        }

        showErrorText(message)
    }

    private fun initBackgroundStateForView(mainView: View, viewBackground: View) {
        mainView.setOnFocusChangeListener { view, hasFocus ->
            clearError()
            viewBackground.setBackgroundResource(if (hasFocus) R.drawable.bg_text_input_selected else R.drawable.bg_text_input_unselected)
        }
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

    private fun showErrorText(message: String) {
        tvError.visibility = View.VISIBLE
        tvError.text = message
    }
}
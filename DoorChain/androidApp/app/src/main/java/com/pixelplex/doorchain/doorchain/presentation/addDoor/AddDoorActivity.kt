package com.pixelplex.doorchain.doorchain.presentation.addDoor

import android.arch.lifecycle.Observer
import android.os.Bundle
import android.widget.Toast
import com.pixelplex.doorchain.doorchain.BaseErrorActivity
import com.pixelplex.doorchain.doorchain.R
import kotlinx.android.synthetic.main.activity_add_door.*
import org.koin.android.architecture.ext.viewModel

class AddDoorActivity : BaseErrorActivity(), Observer<Boolean> {

    private val viewModel by viewModel<AddDoorViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_door)

        viewModel.added.observe(this, this)
        viewModel.error.observe(this, Observer {
            hideLoader()
            it?.let {
                Toast.makeText(this, R.string.incorrect_door_parameters_text, Toast.LENGTH_SHORT).show()
            }
        })

        tvAdd.setOnClickListener {
            showLoader()
            viewModel.addDoor(etDoorId.text.toString(), etDoorName.text.toString())
        }
    }

    override fun onChanged(added: Boolean?) {
        hideLoader()
        if (added == true) {
            Toast.makeText(this, R.string.door_should_be_added, Toast.LENGTH_SHORT).show()
            finish()
        } else Toast.makeText(this, "Не удалось добавить дверь", Toast.LENGTH_SHORT).show()
    }

}
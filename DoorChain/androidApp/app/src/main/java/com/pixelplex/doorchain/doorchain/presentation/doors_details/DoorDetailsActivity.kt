package com.pixelplex.doorchain.doorchain.presentation.doors_details

import android.arch.lifecycle.Observer
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import com.pixelplex.doorchain.doorchain.BaseErrorActivity
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.presentation.AddUserDialog
import com.pixelplex.doorchain.doorchain.presentation.UserAdapter
import com.pixelplex.doorchain.doorchain.presentation.UserClickListener
import kotlinx.android.synthetic.main.activity_door_details.*
import kotlinx.android.synthetic.main.layout_toolbar.*
import org.koin.android.architecture.ext.viewModel

class DoorDetailsActivity : BaseErrorActivity(), UserClickListener {

    companion object {
        fun newIntent(context: Context, doorId: String, doorName: String) =
                Intent(context, DoorDetailsActivity::class.java).apply {
                    putExtra("doorId", doorId)
                    putExtra("doorName", doorName)
                }
    }

    private val viewModel by viewModel<DoorDetailsViewModel> {
        mapOf("doorId" to intent.getStringExtra("doorId"))
    }
    private val userAdapter by lazy { UserAdapter(listener = this) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_door_details)

        showLoader()

        tvTitle.text = intent.getStringExtra("doorName") ?: "Door"

        ivAdd.setOnClickListener {
            AddUserDialog(this).apply {
                confirmButtonListener { user ->
                    showLoader()
                    viewModel.addUser(user)
                }.show()
            }
        }

        refresh.setOnRefreshListener {
            showLoader()
            viewModel.fetchUsers()
            refresh.isRefreshing = false
        }

        rvUsers.adapter = userAdapter

        viewModel.users.observe(this, Observer {
            hideLoader()
            refresh.isRefreshing = false
            it?.let { userAdapter.items = it.toMutableList() }
            tvEmpty.visibility = if (userAdapter.items.isEmpty()) View.VISIBLE else View.GONE
        })

        viewModel.userAdded.observe(this, Observer {
            hideLoader()
            Toast.makeText(this, R.string.user_should_be_added_label, Toast.LENGTH_LONG).show()
        })
    }

    override fun onResume() {
        super.onResume()
        viewModel.fetchUsers()
    }

    override fun onRemove(pos: Int) {
        viewModel.removeUser(userAdapter.items[pos].id)
    }
}
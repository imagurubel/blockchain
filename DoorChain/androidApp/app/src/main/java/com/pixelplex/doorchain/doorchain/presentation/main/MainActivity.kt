package com.pixelplex.doorchain.doorchain.presentation.main

import android.arch.lifecycle.Observer
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import com.pixelplex.doorchain.doorchain.BaseErrorActivity
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.presentation.addDoor.AddDoorActivity
import com.pixelplex.doorchain.doorchain.presentation.doors_details.DoorDetailsActivity
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.layout_toolbar.*
import org.koin.android.architecture.ext.viewModel
import org.koin.android.ext.android.inject

class MainActivity : BaseErrorActivity() {

    private val userService by inject<UserService>()
    private val user by lazy { userService.getUser()!! }

    private val viewModel by viewModel<MainViewModel>()
    private val doorsAdapter by lazy {
        DoorsAdapter(user,
                {
                    showLoader()
                    viewModel.tryOpen(it.id)
                },
                { startActivity(DoorDetailsActivity.newIntent(this, it.id, it.name)) },
                {
                    viewModel.deleteDoor(it)
                })
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        showLoader()

        tvTitle.text = getString(R.string.main_activity_title)
        rvDoors.adapter = doorsAdapter

        refresh.setOnRefreshListener {
            showLoader()
            viewModel.fetchDoors()
            refresh.isRefreshing = false
        }

        with(viewModel) {
            doors.observe(this@MainActivity, Observer {
                hideLoader()
                it?.let {
                    doorsAdapter.items = it.toMutableList()
                    refresh.isRefreshing = false
                }
            })
            openResult.observe(this@MainActivity, Observer { result ->
                hideLoader()
                result?.let {
                    if (it)
                        Toast.makeText(this@MainActivity, R.string.opened_label, Toast.LENGTH_SHORT).show()
                    else
                        Toast.makeText(this@MainActivity, R.string.unable_to_open_door, Toast.LENGTH_SHORT).show()
                }
            })

        }

        with(ivAdd) {
            visibility = if (user.isOwner) View.VISIBLE else View.GONE
            setOnClickListener {
                startActivity(Intent(this@MainActivity, AddDoorActivity::class.java))
            }
        }

    }

    override fun onResume() {
        super.onResume()
        viewModel.fetchDoors()
    }

}

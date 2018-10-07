package com.pixelplex.doorchain.doorchain.presentation.main

import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.pixelplex.doorchain.doorchain.ModifiableRecyclerAdapter
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.model.Door
import com.pixelplex.doorchain.doorchain.model.User
import kotlinx.android.synthetic.main.item_detail.view.*

class DoorsAdapter(private val user: User,
                   private val clickAction: (Door) -> Unit,
                   private val editAction: (Door) -> Unit,
                   private val deleteAction: (Door) -> Unit) : ModifiableRecyclerAdapter<Door, DoorsAdapter.DoorViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, p1: Int): DoorViewHolder {
        return DoorViewHolder(user, clickAction, editAction, deleteAction, parent)
    }

    override fun onBindViewHolder(holder: DoorViewHolder, position: Int) {
        holder.bind(items[position])
    }

    class DoorViewHolder(private val user: User,
                         private val clickAction: (Door) -> Unit,
                         private val editAction: (Door) -> Unit,
                         private val deleteAction: (Door) -> Unit, parent: ViewGroup) :
            RecyclerView.ViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_detail, parent, false)) {

        fun bind(door: Door) {
            with(itemView) {
                setOnClickListener { clickAction(door) }
                tvTitle.text = door.name
                tvId.text = "[${door.id}]"

                ivDelete.visibility = if (user.isOwner) View.VISIBLE else View.GONE
                ivDelete.setOnClickListener {
                    deleteAction(door)
                }

                ivEdit.visibility = if (user.isOwner) View.VISIBLE else View.GONE
                ivEdit.setOnClickListener { editAction(door) }
            }
        }

    }

}
package com.pixelplex.doorchain.doorchain.presentation

import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.pixelplex.doorchain.doorchain.ModifiableRecyclerAdapter
import com.pixelplex.doorchain.doorchain.R
import com.pixelplex.doorchain.doorchain.model.User
import kotlinx.android.synthetic.main.item_detail.view.*

class UserAdapter(private val listener: UserClickListener) : ModifiableRecyclerAdapter<User, UserAdapter.UserViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, p1: Int): UserViewHolder = UserViewHolder(parent)

    override fun onBindViewHolder(holder: UserViewHolder, p1: Int) {
        holder.bind(items[holder.adapterPosition], listener)
    }

    class UserViewHolder(parent: ViewGroup) :
            RecyclerView.ViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_detail, parent, false)) {

        fun bind(user: User, listener: UserClickListener) {
            itemView.ivEdit.visibility = View.GONE
            itemView.ivDelete.visibility = View.GONE
            itemView.tvTitle.text = user.name
            itemView.ivDelete.setOnClickListener {
                listener.onRemove(adapterPosition)
            }
        }

    }
}

interface UserClickListener {
    fun onRemove(pos: Int)
}
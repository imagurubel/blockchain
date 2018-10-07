package com.pixelplex.doorchain.doorchain

import android.support.v7.widget.RecyclerView

abstract class ModifiableRecyclerAdapter<T, VH : RecyclerView.ViewHolder> :
        RecyclerView.Adapter<VH>() {

    var items: MutableList<T> = ArrayList()
        set(value) {
            field.clear()
            field.addAll(value)
            notifyDataSetChanged()
        }

    fun add(item: T) {
        this.items.add(item)
        notifyItemInserted(items.indexOf(item))
    }

    fun addAll(items: List<T>) {
        val startPosition = itemCount
        this.items.addAll(items)
        notifyItemRangeInserted(startPosition, items.size)
    }

    fun addAll(position: Int, items: List<T>) {
        this.items.addAll(position, items)
        notifyItemRangeInserted(position, items.size)
    }

    fun replace(position: Int, item: T) {
        this.items[position] = item
        notifyItemChanged(position)
    }

    override fun getItemCount(): Int = items.size

    fun clear() {
        items.clear()
        notifyDataSetChanged()
    }

}
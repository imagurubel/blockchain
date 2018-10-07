package com.pixelplex.doorchain.doorchain

import android.view.View

fun setVisibility(visible: Boolean, vararg views: View) =
        views.forEach { it.visibility = if (visible) View.VISIBLE else View.GONE }

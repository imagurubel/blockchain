package com.pixelplex.doorchain.doorchain

import android.app.Activity
import android.content.Context
import android.support.v7.app.AppCompatActivity
import android.support.v7.app.AppCompatDialog
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager

fun AppCompatActivity.showSoftKeyboard() {
    val inputMethodManager = getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
    inputMethodManager.showSoftInput(currentFocus, InputMethodManager.SHOW_FORCED)
}

fun AppCompatActivity.hideSoftKeyboard() {
    val inputMethodManager = getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
    currentFocus?.let {
        inputMethodManager.hideSoftInputFromWindow(it.windowToken, 0)
    }
}

fun AppCompatDialog.showSoftKeyboard() {
    val inputMethodManager = context.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
    inputMethodManager.showSoftInput(currentFocus, InputMethodManager.SHOW_FORCED)
}

fun AppCompatDialog.hideSoftKeyboard() {
    val inputMethodManager = context.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
    currentFocus?.let {
        inputMethodManager.hideSoftInputFromWindow(it.windowToken, 0)
    }
}

fun AppCompatActivity.clearFocus() {
    window.decorView.clearFocus()
}

fun <T : View> inflate(parent: ViewGroup, layout: Int, attach: Boolean = false): T =
        LayoutInflater.from(parent.context).inflate(layout, parent, attach) as T

fun <T : View> inflate(context: Context, layoutId: Int): T =
        LayoutInflater.from(context).inflate(layoutId, null) as T



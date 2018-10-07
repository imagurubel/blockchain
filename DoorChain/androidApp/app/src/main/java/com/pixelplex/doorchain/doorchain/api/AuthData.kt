package com.pixelplex.doorchain.doorchain.api

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName

data class AuthData(
    @Expose
    val name: String,
    @SerializedName("owner_key")
    val ownerKey: String,
    @SerializedName("active_key")
    val activeKey: String,
    @SerializedName("memo_key")
    val memoKey: String
)
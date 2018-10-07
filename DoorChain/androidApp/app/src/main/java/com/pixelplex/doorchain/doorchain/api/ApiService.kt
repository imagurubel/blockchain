package com.pixelplex.doorchain.doorchain.api

import kotlinx.coroutines.experimental.Deferred
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface ApiService {

    @Headers("Content-Type: application/json")
    @POST("/faucet/registration")
    fun register(@Body authData: AuthData): Deferred<List<AccountCreateResponse>>

}
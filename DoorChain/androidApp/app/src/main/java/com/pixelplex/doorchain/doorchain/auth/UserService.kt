package com.pixelplex.doorchain.doorchain.auth

import com.pixelplex.doorchain.doorchain.cache.Cache
import com.pixelplex.doorchain.doorchain.model.User

class UserService(private val cache: Cache) {

    fun getUser(): User? = cache[USER_KEY]

    fun saveUser(user: User) = cache.put(USER_KEY, user)

    companion object {
        const val USER_KEY = "userKEy"
    }

}
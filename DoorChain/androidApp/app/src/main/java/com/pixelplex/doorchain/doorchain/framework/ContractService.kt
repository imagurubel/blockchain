package com.pixelplex.doorchain.doorchain.framework

import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.model.Door
import com.pixelplex.doorchain.doorchain.model.User
import kotlinx.coroutines.experimental.DefaultDispatcher
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.suspendCancellableCoroutine
import kotlinx.coroutines.experimental.withContext
import org.echo.mobile.framework.Callback
import org.echo.mobile.framework.exception.LocalException
import org.echo.mobile.framework.model.contract.ContractMethodParameter
import org.echo.mobile.framework.model.contract.ContractMethodParameter.Companion.TYPE_ADDRESS
import org.echo.mobile.framework.model.contract.ContractMethodParameter.Companion.TYPE_UINT64
import org.spongycastle.util.encoders.Hex

class ContractService(private val framework: EchoFrameworkService,
                      private val userService: UserService) {

    suspend fun isOwner(userId: String): Boolean {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.queryContract(userId, ASSET_ID, CONTRACT_ID, "isOwner",
                        listOf(),
                        object : Callback<String> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: String) {
                                val intResult = result.toInt()
                                continuation.resume(intResult == 1)
                            }

                        })
            }
        }
    }

    suspend fun doors(): List<Door> {
        val count = doorsCount()

        val doors = mutableListOf<Door>()
        (0 until count).forEach { door ->
            doors.add(doorByIndex(door.toString()))
        }

        return doors
    }

    suspend fun doorByIndex(index: String): Door {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.queryContract(REGISTRAR, ASSET_ID, CONTRACT_ID, "getDoorInfoByIndex",
                        listOf(ContractMethodParameter("doorIndex", "uint256", index)),
                        object : Callback<String> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: String) {
                                if (result.isNotEmpty()) {
                                    val id = result.take(64).toLong(16).toString()
                                    val decoded = result.substring(64, result.length)
                                    val name = decodeName(decoded)
                                    continuation.resume(Door(name, id))
                                }
                            }

                        })
            }
        }
    }

    private fun decodeName(result: String): String {
        val offset = result.slice(0 until 64).toInt(16) * 2
        val length = result.slice(64 until 64 * 2).toInt(16) * 2

        return String(Hex.decode(result.slice(offset until (offset + length))))
    }

    suspend fun doorsCount(): Int {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.queryContract(REGISTRAR, ASSET_ID, CONTRACT_ID, "doorsCount",
                        listOf(),
                        object : Callback<String> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: String) {
                                continuation.resume(result.toInt())
                            }

                        })
            }
        }
    }

    suspend fun addDoor(doorId: String, doorName: String, userId: String, password: String): Boolean {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.callContract(userId, password, ASSET_ID, CONTRACT_ID, "addDoor",
                        listOf(ContractMethodParameter("doorId", "int64", doorId),
                                ContractMethodParameter("doorName", ContractMethodParameter.TYPE_STRING, doorName)),
                        object : Callback<Boolean> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: Boolean) {
                                continuation.resume(result)
                            }

                        })
            }
        }
    }

    suspend fun removeDoor(doorId: String, userID: String, password: String): Boolean {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.callContract(userID, password, ASSET_ID, CONTRACT_ID, "removeDoor",
                        listOf(ContractMethodParameter("doorId", "int64", doorId)),
                        object : Callback<Boolean> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: Boolean) {
                                continuation.resume(result)
                            }

                        })
            }
        }
    }

    private suspend fun fetchUsersIdsForDoor(doorId: String, userId: String): List<String> {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.queryContract(userId, ASSET_ID, CONTRACT_ID, "getDoorWhiteList",
                        listOf(ContractMethodParameter("doorId", "int64", doorId)),
                        object : Callback<String> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: String) {
                                continuation.resume(parseUsersIds(result))
                            }

                        })
            }
        }
    }


    suspend fun fetchUsersForDoor(doorId: String, userId: String): List<User> {
        val userIds = async { fetchUsersIdsForDoor(doorId, userId) }.await()

        return userIds.map {
            val account = withContext(DefaultDispatcher) { framework.getAccount(it) }
            User(account.name, account.getObjectId(), "", false)
        }
    }


    private fun parseUsersIds(result: String): List<String> {
        val usersString = result.substring(128, result.length)

        return usersString.chunked(64).map {
            "1.2.${it.toLong(16)}"
        }
    }


    suspend fun addUserToDoor(ownerId: String, userId: String, doorId: String, password: String): Boolean {
        val address = userId.split(".").last()

        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.callContract(ownerId, password, ASSET_ID, CONTRACT_ID, "addUserToDoor",
                        listOf(ContractMethodParameter("doorId", "int64", doorId),
                                ContractMethodParameter("address", ContractMethodParameter.TYPE_ADDRESS, address)),
                        object : Callback<Boolean> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: Boolean) {
                                continuation.resume(result)
                            }

                        })
            }
        }
    }

    suspend fun removeUserFromDoor(address: String, doorId: String, password: String): Boolean {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.callContract(REGISTRAR, password, ASSET_ID, CONTRACT_ID, "removeUserFromDoor",
                        listOf(ContractMethodParameter("doorId", TYPE_UINT64, doorId),
                                ContractMethodParameter("address", TYPE_ADDRESS, address)),
                        object : Callback<Boolean> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: Boolean) {
                                continuation.resume(result)
                            }

                        })
            }
        }
    }

    suspend fun openDoor(doorId: String, userID: String, password: String): Boolean {
        return suspendCancellableCoroutine { continuation ->
            framework.execute {
                this.callContract(userID, password, ASSET_ID, CONTRACT_ID, "openDoor",
                        listOf(ContractMethodParameter("doorId", "int64", doorId)),
                        object : Callback<Boolean> {
                            override fun onError(error: LocalException) {
                                continuation.resumeWithException(error)
                            }

                            override fun onSuccess(result: Boolean) {
                                continuation.resume(result)
                            }

                        })
            }
        }
    }

    suspend fun hasAccess(doorId: String, userId: String, password: String): Boolean {
        val isOwner = userService.getUser()?.isOwner
        val users = async { fetchUsersForDoor(doorId, userId) }

        return isOwner ?: users.await().find { it.id == userId } != null ?: false
    }

    companion object {
        private const val REGISTRAR = "1.2.95"
        private const val CONTRACT_ID = "1.16.16186"
        private const val ASSET_ID = "1.3.0"
    }

}
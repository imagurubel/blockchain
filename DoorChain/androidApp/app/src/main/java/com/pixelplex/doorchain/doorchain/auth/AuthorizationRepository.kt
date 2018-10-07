package com.pixelplex.doorchain.doorchain.auth

import com.pixelplex.doorchain.doorchain.api.ApiService
import com.pixelplex.doorchain.doorchain.api.AuthData
import com.pixelplex.doorchain.doorchain.framework.EchoFrameworkService
import kotlinx.coroutines.experimental.CancellationException
import kotlinx.coroutines.experimental.suspendCancellableCoroutine
import kotlinx.coroutines.experimental.withContext
import org.echo.mobile.framework.Callback
import org.echo.mobile.framework.core.crypto.CryptoCoreComponent
import org.echo.mobile.framework.exception.LocalException
import org.echo.mobile.framework.model.AuthorityType
import org.echo.mobile.framework.model.FullAccount
import retrofit2.HttpException
import kotlin.coroutines.experimental.coroutineContext

class AuthorizationRepository(
        private val echoFrameworkService: EchoFrameworkService,
        private val cryptoCoreComponent: CryptoCoreComponent,
        private val apiService: ApiService
) {

    suspend fun register(name: String, password: String): Boolean {
        try {
            val ownerPublicKey = cryptoCoreComponent.getAddress(name, password, AuthorityType.OWNER)
            val activePublicKey =
                    cryptoCoreComponent.getAddress(name, password, AuthorityType.ACTIVE)
            val memoPublicKey = cryptoCoreComponent.getAddress(name, password, AuthorityType.KEY)

            if (withContext(coroutineContext) { isAccountExist(name) }) {
                throw IllegalArgumentException()
            }

            val transactionResponses = withContext(coroutineContext) {
                apiService.register(AuthData(name, ownerPublicKey, activePublicKey, memoPublicKey))
            }

            transactionResponses.await()
            return true
        } catch (ex: CancellationException) {
            return false
        } catch (ex: RegistrationException) {
            throw ex
        } catch (ex: HttpException) {
            throw RegistrationException(
                    RegistrationException.ExceptionType.INCORRECT_ACCOUNT_NAME,
                    parseRegistrationMessage(ex)
            )
        } catch (ex: Exception) {
            throw RegistrationException(
                    RegistrationException.ExceptionType.INCORRECT_ACCOUNT_NAME
            )
        }
    }

    private fun parseRegistrationMessage(ex: HttpException): String {
        return "Error registration process"
    }

    private suspend fun isAccountExist(name: String): Boolean {
        return suspendCancellableCoroutine { cont ->
            echoFrameworkService.execute {
                this.checkAccountReserved(name, object : Callback<Boolean> {
                    override fun onError(error: LocalException) {
                        cont.resumeWithException(error)
                    }

                    override fun onSuccess(result: Boolean) {
                        cont.resume(result)
                    }
                })
            }
        }
    }

    suspend fun login(name: String, password: String): Boolean {
        try {
            return suspendCancellableCoroutine { cont ->
                echoFrameworkService.execute {
                    this.isOwnedBy(name, password, object : Callback<FullAccount> {
                        override fun onError(error: LocalException) {
                            cont.resumeWithException(error)
                        }

                        override fun onSuccess(result: FullAccount) {
                            cont.resume(true)
                        }
                    })
                }
            }
        } catch (ex: Exception) {
            throw IllegalArgumentException(ex)
        }
    }


}

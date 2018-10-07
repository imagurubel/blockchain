package com.pixelplex.doorchain.doorchain.framework

import kotlinx.coroutines.experimental.channels.ConflatedBroadcastChannel
import kotlinx.coroutines.experimental.suspendCancellableCoroutine
import org.echo.mobile.framework.Callback
import org.echo.mobile.framework.EchoFramework
import org.echo.mobile.framework.core.socket.SocketMessengerListener
import org.echo.mobile.framework.core.socket.internal.SocketMessengerImpl
import org.echo.mobile.framework.exception.LocalException
import org.echo.mobile.framework.model.Account
import org.echo.mobile.framework.model.FullAccount
import org.echo.mobile.framework.support.Api
import org.echo.mobile.framework.support.Settings
import kotlin.coroutines.experimental.suspendCoroutine

class EchoFrameworkService {

    private var framework: EchoFramework? = null

    private val stateChanel = ConflatedBroadcastChannel(false)

    init {
        initEchoFramework(ECHO_URL)
    }

    suspend fun restart() {
        initEchoFramework(ECHO_URL)
        startEchoFramework()
    }

    fun initEchoFramework(url: String) {
        framework?.stop()
        framework = EchoFramework.create(
                configureSettings(url)
        )
    }

    private fun configureSettings(url: String): Settings =
            Settings.Configurator()
                    .setUrl(url)
                    .setApis(Api.DATABASE, Api.ACCOUNT_HISTORY, Api.NETWORK_BROADCAST)
                    .setSocketMessenger(configureSocket())
                    .configure()

    private fun configureSocket() =
            SocketMessengerImpl().apply { on(SocketConnectivityListener()) }

    suspend fun startEchoFramework() {
        return suspendCoroutine { cont ->
            framework?.start(object : Callback<Any> {
                override fun onError(error: LocalException) {
                    stateChanel.offer(false)
                    cont.resumeWithException(error)
                }

                override fun onSuccess(result: Any) {
                    stateChanel.offer(true)
                    cont.resume(Unit)
                }
            })
        }
    }

    fun execute(block: EchoFramework.() -> Unit) {
        block(framework!!)
    }

    suspend fun getAccount(name: String): Account {
        return suspendCancellableCoroutine { continuation ->
            framework!!.getAccount(name, object : Callback<FullAccount> {
                override fun onError(error: LocalException) {
                    continuation.resumeWithException(error)
                }

                override fun onSuccess(result: FullAccount) {
                    continuation.resume(result.account!!)
                }

            })
        }

    }

    fun observeState() = stateChanel.openSubscription()

    private inner class SocketConnectivityListener : SocketMessengerListener {
        override fun onConnected() {
        }

        override fun onDisconnected() {
            stateChanel.offer(false)
        }

        override fun onEvent(event: String) {
        }

        override fun onFailure(error: Throwable) {
        }

    }

    companion object {
        private const val ECHO_URL = "wss://echo-devnet-node.pixelplex.io/"
    }

}

package com.pixelplex.doorchain.doorchain

import android.support.multidex.MultiDexApplication
import com.pixelplex.doorchain.doorchain.api.*
import com.pixelplex.doorchain.doorchain.auth.AuthorizationRepository
import com.pixelplex.doorchain.doorchain.auth.UserService
import com.pixelplex.doorchain.doorchain.cache.Cache
import com.pixelplex.doorchain.doorchain.cache.LruCache
import com.pixelplex.doorchain.doorchain.framework.ContractService
import com.pixelplex.doorchain.doorchain.framework.EchoFrameworkService
import com.pixelplex.doorchain.doorchain.presentation.addDoor.AddDoorViewModel
import com.pixelplex.doorchain.doorchain.presentation.doors_details.DoorDetailsViewModel
import com.pixelplex.doorchain.doorchain.presentation.launcher.LauncherViewModel
import com.pixelplex.doorchain.doorchain.presentation.login.LoginViewModel
import com.pixelplex.doorchain.doorchain.presentation.main.MainViewModel
import com.pixelplex.doorchain.doorchain.presentation.register.RegistrationViewModel
import okhttp3.Interceptor
import org.echo.mobile.framework.core.crypto.CryptoCoreComponent
import org.echo.mobile.framework.core.crypto.internal.CryptoCoreComponentImpl
import org.echo.mobile.framework.model.network.Echodevnet
import org.koin.android.architecture.ext.viewModel
import org.koin.android.ext.android.startKoin
import org.koin.dsl.module.Module

class AndroidApplication : MultiDexApplication() {

    override fun onCreate() {
        super.onCreate()

        startKoin(this, listOf(launcherModule, baseModule, mainModule, addDoorModule, authModule, networkModule, doorDetails))
    }

    private val mainModule: Module = org.koin.dsl.module.applicationContext {
        viewModel { MainViewModel(get(), get()) }
    }

    private val baseModule: Module = org.koin.dsl.module.applicationContext {
        viewModel { BaseActivityViewModel(get()) }
    }

    private val addDoorModule: Module = org.koin.dsl.module.applicationContext {
        viewModel { AddDoorViewModel(get(), get()) }
    }

    private val doorDetails: Module = org.koin.dsl.module.applicationContext {
        viewModel {
            DoorDetailsViewModel(it["doorId"], get(), get(), get())
        }
    }

    private val launcherModule: Module = org.koin.dsl.module.applicationContext {
        viewModel { LauncherViewModel(get()) }
    }

    private val authModule: Module = org.koin.dsl.module.applicationContext {
        viewModel { RegistrationViewModel(get(), get(), get(), get()) }
        viewModel { LoginViewModel(get(), get(), get(), get()) }
        bean { AuthorizationRepository(get(), get(), get()) }
        bean { CryptoCoreComponentImpl(Echodevnet()) as CryptoCoreComponent }
        bean { UserService(get()) }
        bean { LruCache() as Cache }
        bean { ContractService(get(), get()) }
        bean { EchoFrameworkService() }
    }

    private val networkModule: Module = org.koin.dsl.module.applicationContext {
        factory { provideOkHttpClient(get()) }
        factory { provideLoggingInterceptor() as Interceptor }
        factory { provideGson(Echodevnet()) }
        factory("devRetrofit") {
            provideRetrofit(
                    "https://echo-tmp-wallet.pixelplex.io/",
                    get(),
                    get()
            )
        }
        bean { provideApiService(get("devRetrofit")) }
    }

}
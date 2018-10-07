package com.pixelplex.doorchain.doorchain.auth

open class UiException : RuntimeException{

    constructor() : super()

    constructor(message: String?) : super(message)

    constructor(message: String?, cause: Throwable?) : super(message, cause)

}
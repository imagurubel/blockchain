package com.pixelplex.doorchain.doorchain.presentation.register

enum class ErrorField(val value: String) {

    ERROR("error"),
    EMAIL("email"),
    PASSWORD("password"),
    PASSWORDS("passwords"),
    FILE("file"),
    TITLE("title"),
    DESCRIPTION("description"),
    PHONE("phone"),
    UNKNOWN("");

    companion object {
        fun from(findValue: String): ErrorField = try {
            ErrorField.values().first { it.value == findValue }
        } catch (ex: NoSuchElementException) {
            ErrorField.UNKNOWN
        }

    }
}
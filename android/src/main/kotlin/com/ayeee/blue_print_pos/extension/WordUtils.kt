package com.ayeee.blue_print_pos.extension

import java.util.Locale

fun String.capitalizeFirstLetter(): String {
    return if (isNotEmpty()) {
        this.substring(0, 1).uppercase(Locale.ROOT) + this.substring(1)
    } else {
        this
    }
}
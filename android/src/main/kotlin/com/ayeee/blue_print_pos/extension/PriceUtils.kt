package com.ayeee.blue_print_pos.extension

import java.text.NumberFormat
import java.util.Locale

fun Number.getInIDR(): String {
    val numberFormat = NumberFormat.getNumberInstance(Locale("ID"))
    val formatted = numberFormat.format(this)
    val formattedFinal = if (formatted.contains('-')) {
        "${formatted.substring(0, 1)} Rp${formatted.substring(1, formatted.length)}"
    } else {
        "Rp$formatted"
    }
    return formattedFinal
}

val Number.getInIDRWithSpace: String
    get() {
        val numberFormat = NumberFormat.getInstance(Locale("ID"))
        val formatted = numberFormat.format(this)
        val formattedFinal = if (formatted.contains('-')) {
            "${formatted.substring(0, 1)} Rp ${formatted.substring(1)}"
        } else {
            "Rp $formatted"
        }
        return formattedFinal
    }

val Number.inAmount: String
    get() {
        val numberFormat = NumberFormat.getInstance(Locale("ID"))
        return numberFormat.format(this)
    }
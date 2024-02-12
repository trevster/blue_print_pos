package com.ayeee.blue_print_pos

import android.os.Bundle
import com.vfi.smartpos.deviceservice.aidl.IPrinter
import android.graphics.Bitmap

import com.ayeee.blue_print_pos.extension.getInIDR
import com.ayeee.blue_print_pos.extension.capitalizeFirstLetter
import com.ayeee.blue_print_pos.extension.getInIDRWithSpace
import com.ayeee.blue_print_pos.extension.inAmount
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class PrintTemplate {

    fun receiptPayment(
        printer: IPrinter?,
        youtapLogo: Bitmap?,
        merchantLogoBitmap: Bitmap?,
        merchant: Map<*, *>,
        transaction: Map<*, *>,
        customReceipt: Map<*, *>?,
        orderNumber: Int,
        paidAmount: String?,
        changeAmount: String?,
        reward: Map<*, *>?,
        canShowRewardQR: Boolean,
        canAccessCustomReceipt: Boolean,
        canShowTicketingQR: Boolean,
        openDrawer: Boolean,
        eMenuLinkShort: String?,
        isDevicePax: Boolean
    ) {

        /// Merchant
        val merchantName = merchant["merchantName"] as String

        /// Custom Receipt
        val address = customReceipt?.get("address") as String
        val additionalMessage = customReceipt?.get("additionalMessage") as String
        val phone = customReceipt?.get("phone") as String
        val customReceiptLinks = customReceipt?.get("customReceiptLinks") as List<Map<*,*>>
        val isShowEMenuLink = customReceipt?.get("isShowEMenuLink") as Boolean
        val isShowBarcodeTrailId = customReceipt?.get("isShowBarcodeTrailId") as Boolean
        val isShowBarcodeSNAP = customReceipt?.get("isShowBarcodeSNAP") as Boolean

        /// SNAP
        val isShowRewardQR = canShowRewardQR || reward != null;

        val rewardTotal = reward?.get("total") as? String?
        val rewardType = reward?.get("type") as? String?
        val rewardName = reward?.get("name") as? String?

        /// Transaction
        val trailID = transaction?.get("trailId") as String
        val isCash = transaction?.get("isCash") as Boolean
        val isCanceled = transaction?.get("isCanceled") as Boolean
        val isQRIS = transaction?.get("isQRIS") as Boolean
        val openBill = transaction?.get("openBill") as Map<*,*>
        val transactionItems = transaction?.get("transactionItems") as List<Map<*,*>>
        val transactionCreatedAt = transaction?.get("createdAt") as String
        val subTotal = transaction?.get("subTotal") as Int
        val total = transaction?.get("total") as Int
        val transactionPriceAdjustments = transaction?.get("transactionPriceAdjustments") as List<Map<*,*>>
        val voidNote = transaction?.get("voidNote") as String
        val type = transaction?.get("type") as String
        val transactionType = transaction?.get("typeDisplay") as String
        val otherPaymentMethodNote = transaction?.get("otherPaymentMethodNote") as String
        val taxAmount = transaction?.get("taxAmount") as Int
        val taxType = transaction?.get("taxType") as String
        val roundingDifference = transaction?.get("roundingDifference") as Int
        val isOnlineOrderDelivery = transaction?.get("isOnlineOrderDelivery") as Boolean
        val deliveryFee = transaction?.get("deliveryFee") as Int
        val platformFee = transaction?.get("platformFee") as Int

        /// Open Bill
        val openBillName = openBill?.get("name") as String?
        val openBillType = openBill?.get("openBillType") as String?

        val codeForClaim = "YTI#${trailID}#${total}";

        val defaultOpenBill: Map<*, *> = mapOf(
            "id" to "",
            "parentBillId" to "",
            "name" to "",
            "createdAt" to "",
            "openBillType" to "",
            "openBillCartItemSequenceList" to emptyList<Map<String, Any>>(),
            "lastSplitBillSequence" to 0,
            "lastOpenBillSequence" to 0,
        )

        Logger.log("\n ///////////////// CONTENT_TO_PRINT_RECEIPT_PAYMENT /////////////////")
        Logger.log("\n ///////////////// isDevicePax : $isDevicePax")

        val header = Bundle()
        header.putInt("font", 2)
        header.putInt("align", 1)
        header.putBoolean("newline", true)

        val body = Bundle()
        body.putInt("font", 2)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val bodySocialMedia = Bundle()
        bodySocialMedia.putInt("font", 2)
        bodySocialMedia.putInt("align", 0)
        bodySocialMedia.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        val formatMerchantLogo = Bundle()
        formatMerchantLogo.putInt("offset", 30)
        formatMerchantLogo.putInt("width", 200)
        formatMerchantLogo.putInt("height", 90)

        val formatQr = Bundle()
        formatQr.putInt("offset", 40)
        formatQr.putInt("expectedHeight", 320)

        val formatBarcode = Bundle()
        formatBarcode.putInt("align", 1)
        formatBarcode.putInt("height", 120)

        printer?.addText(body, "\n\n")
        if(merchantLogoBitmap != null) {
            printer?.addBmpImage(formatMerchantLogo, merchantLogoBitmap)
        }
        printer?.addText(header, merchantName)
        printer?.addText(header, address)
        printer?.addText(header, phone)

        printer?.addTextInLine(body, "Order No", "", orderNumber.toString(), 0)

        if(isCash && isCanceled) {
            printer?.addTextInLine(body, "Status Pesanan", "", "Dibatalkan", 0)
        }

        if(openBill != defaultOpenBill) {
            printer?.addTextInLine(body, "Pesanan", "", openBillName, 0)
            printer?.addTextInLine(body, "Order Type", "", openBillType, 0)
        }

        printer?.addTextInLine(body, "Waktu", "", transactionCreatedAt.toString(), 0)
        printer?.addTextInLine(body, "Trail ID", "", trailID, 0)
        printer?.addText(body, "--------------------------------")

        for (mapTransactionItem in transactionItems) {
            val productName = mapTransactionItem["productName"] as String
            val quantity = mapTransactionItem["quantity"] as Int
            val price = mapTransactionItem["price"] as Int
            val quantityMultiplyWithPrice = (quantity * price)

            printer?.addTextInLine(body, "${quantity}x ${productName}", "", "Rp.${quantityMultiplyWithPrice}", 1)

            val addOnItems = mapTransactionItem["addOnItems"] as List<Map<*,*>>
            for (mapAddOnItem in addOnItems) {
                val addOnItemName = mapAddOnItem["name"] as String
                val addOnItemPrice = mapAddOnItem["price"] as String
                printer?.addTextInLine(body, "- $addOnItemName", "", addOnItemPrice, 1)
            }
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Subtotal", "", subTotal.getInIDR(), 0)
        printer?.addText(body, "--------------------------------")


        for (mapTransactionPriceAdjustments in transactionPriceAdjustments) {
            val name = mapTransactionPriceAdjustments["name"] as String
            val calculatedAmount = mapTransactionPriceAdjustments["calculatedAmount"] as String
            printer?.addTextInLine(body, name, "", calculatedAmount, 0)
        }

        if(taxAmount > 0) {
            printer?.addTextInLine(body, taxType, "", taxAmount.toString(), 0)
        }

        if(roundingDifference > 0) {
            printer?.addTextInLine(body, "Pembulatan", "", roundingDifference.getInIDR(), 0)
        }

        if(isOnlineOrderDelivery && deliveryFee > 0) {
            printer?.addTextInLine(body, "Total Ongkos Kirim", "", deliveryFee.getInIDR(), 0)
        }

        if(platformFee > 0) {
            printer?.addTextInLine(body, "Biaya Layanan Youtap", "", platformFee.getInIDR(), 0)
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "TOTAL", "", total.getInIDR(), 0)
        printer?.addText(body, "--------------------------------")

        if(isCash) {
            printer?.addTextInLine(body, "Pembayaran", "", "Tunai", 0)
            if (!paidAmount.isNullOrEmpty()) {
                printer?.addTextInLine(body, "Uang Pembayaran", "", paidAmount, 0)
            }
            if (!changeAmount.isNullOrEmpty()) {
                printer?.addTextInLine(body, "Kembalian", "", changeAmount, 0)
            }
            if (isCanceled) {
                printer?.addTextInLine(body, "Catatan Batal", "", voidNote, 0)
            }
        } else if(isQRIS) {
            printer?.addTextInLine(body, "Pembayaran", "", type, 0)
        } else {
            printer?.addTextInLine(body, "Pembayaran", "", transactionType, 0)
            if(otherPaymentMethodNote.isNotEmpty()) {
                printer?.addTextInLine(body, "Catatan", "", otherPaymentMethodNote, 0)
            }
        }

        printer?.addText(body, "--------------------------------")

        if(canAccessCustomReceipt && isShowBarcodeTrailId) {
            printer?.addText(body, "Transaksi ID untuk kebutuhan merchant")
            printer?.addBarCode(formatBarcode, trailID)
            printer?.addText(body, trailID)
        }

        if (canAccessCustomReceipt && isShowBarcodeSNAP && isShowRewardQR) {
            var rewardText = ""
            if(reward != null) {
                rewardText = "Selamat! Anda mendapatkan ${rewardTotal} free ${rewardType} ${rewardName}."
            } else {
                rewardText = "Scan QR sekarang! Dapatkan layanan menarik di merchant favorit mu."
            }

            printer?.addText(body, rewardText)
            printer?.addQrCode(formatQr, codeForClaim)
            printer?.addText(body, "Voucher dapat diakses melalui aplikasi SNAP by Youtap.")
        }
        printer?.addText(body, "--------------------------------")

        if (canAccessCustomReceipt) {
            if(isShowEMenuLink) {
                printer?.addText(body, "Cek e-menu $merchantName di")
                printer?.addText(body, eMenuLinkShort)
            }
            if(additionalMessage.isNotEmpty()) {
                printer?.addText(body, additionalMessage)
            }
        }
        printer?.addText(body, "--------------------------------")

        val socialMedia: MutableMap<String, String> = mutableMapOf(
            "instagram" to "",
            "facebook" to "",
            "twitter" to "",
            "tiktok" to "",
            "website" to ""
        )

        if (canAccessCustomReceipt) {
                for (customReceiptLink in customReceiptLinks) {
                    val name = customReceiptLink["name"] as String
                    val link = customReceiptLink["link"] as String
                    socialMedia[name] = link;
                }
        }

        socialMedia.forEach { (key, value) ->
            printer?.addText(bodySocialMedia, "${key.capitalizeFirstLetter()}: @${value}")
        }
        printer?.addText(header, "--------------------------------")

        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")
    }
    fun printOrder(
        printer: IPrinter?,
        youtapLogo: Bitmap?,
        transaction: Map<*, *>,
        orderNumber: Int,
        canShowTicketingQR: Boolean,
        isDevicePax: Boolean,
    ) {

        /// Transaction
        val transactionItems = transaction?.get("transactionItems") as List<Map<*,*>>
        val totalTransactionItemsQuantity = transaction?.get("totalTransactionItemsQuantity") as Int
        val transactionCreatedAt = transaction?.get("createdAt") as String

        Logger.log("\n ///////////////// CONTENT_TO_PRINT_ORDER /////////////////")
        Logger.log("\n ///////////////// isDevicePax : $isDevicePax")

        val body = Bundle()
        body.putInt("font", 2)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        printer?.addTextInLine(body, "Order No", "", orderNumber.toString(), 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Waktu", "", transactionCreatedAt, 0)
        printer?.addText(body, "--------------------------------")

        for (mapTransactionItem in transactionItems) {
            val productName = mapTransactionItem["productName"] as String
            val quantity = mapTransactionItem["quantity"] as Int
            val price = mapTransactionItem["price"] as Int
            val quantityMultiplyWithPrice = (quantity * price)
            printer?.addTextInLine(body, "${quantity}x ${productName}", "", "Rp.${quantityMultiplyWithPrice}", 1)

            val addOnItems = mapTransactionItem["addOnItems"] as List<Map<*,*>>
            for (mapAddOnItem in addOnItems) {
                val addOnItemName = mapAddOnItem["name"] as String
                val addOnItemPrice = mapAddOnItem["price"] as String
                printer?.addTextInLine(body, "- $addOnItemName", "", addOnItemPrice, 1)
            }
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "TOTAL", "", "${totalTransactionItemsQuantity} pcs", 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")

    }

    fun printOpenBill(
        printer: IPrinter?,
        youtapLogo: Bitmap?,
        merchantLogoBitmap: Bitmap?,
        openBill: Map<*, *>?,
        customReceipt: Map<*, *>?,
        isAdditional: Boolean,
        cartItemAdditional: List<Map<*, *>?>,
        orderNumber: Int,
        canAccessCustomReceipt: Boolean,
        eMenuLinkShort: String?,
        isDevicePax: Boolean,
    ) {
        /// Custom Receipt
        val merchantName = customReceipt?.get("merchantName") as String
        val address = customReceipt?.get("address") as String
        val additionalMessage = customReceipt?.get("additionalMessage") as String
        val phone = customReceipt?.get("phone") as String
        val customReceiptLinks = customReceipt?.get("customReceiptLinks") as List<Map<*,*>>
        val isShowEMenuLink = customReceipt?.get("isShowEMenuLink") as Boolean

        val openBillName = openBill?.get("name") as String
        val openBillCreatedAt = openBill?.get("createdAt") as String
        val openBillCartItemSequenceList = openBill?.get("openBillCartItemSequenceList") as List<Map<*,*>>

        Logger.log("\n ///////////////// CONTENT_TO_PRINT_OPEN_BILL /////////////////")
        Logger.log("\n ///////////////// isDevicePax : $isDevicePax")

        val header = Bundle()
        header.putInt("font", 2)
        header.putInt("align", 1)
        header.putBoolean("newline", true)

        val body = Bundle()
        body.putInt("font", 2)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val bodySocialMedia = Bundle()
        bodySocialMedia.putInt("font", 2)
        bodySocialMedia.putInt("align", 0)
        bodySocialMedia.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        val formatMerchantLogo = Bundle()
        formatMerchantLogo.putInt("offset", 30)
        formatMerchantLogo.putInt("width", 200)
        formatMerchantLogo.putInt("height", 90)

        printer?.addText(body, "\n\n")
        if(merchantLogoBitmap != null) {
            printer?.addBmpImage(formatMerchantLogo, merchantLogoBitmap)
        }
        printer?.addText(header, merchantName)
        printer?.addText(header, address)
        printer?.addText(header, phone)
        if(isAdditional) {
            printer?.addText(header, "Pesanan Tambahan")
        }
        printer?.addText(header, openBillName)

        printer?.addTextInLine(body, "No. Order", "", orderNumber.toString(), 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Waktu", "", openBillCreatedAt.toString(), 0)
        printer?.addText(body, "--------------------------------")

        var totalQuantity: Int = 0
        if (isAdditional) {
            for (cartItem in cartItemAdditional) {
                val cartItemName = cartItem?.get("name") as? String ?: continue
                val cartItemQuantity = cartItem["quantity"]?.toString() ?: continue
                val cartProductAddOnItemSelected = cartItem["cartProductAddOnItemSelected"] as? List<Map<*, *>> ?: continue

                printer?.addTextInLine(body, "${cartItemQuantity}x ${cartItemName}", "", "", 0)

                for (cartItemAdditionalSelectedItem in cartProductAddOnItemSelected) {
                    val cartItemAdditionalSelectedItemName = cartItemAdditionalSelectedItem?.get("name") as? String
                    printer?.addTextInLine(body, "- $cartItemAdditionalSelectedItemName", "", "", 0)
                }

                totalQuantity += 1
            }
        } else {
            for (openBillCartItemSequenceListCartItem in openBillCartItemSequenceList) {
                val cartItems = openBillCartItemSequenceListCartItem.get("cartItems") as? List<Map<*, *>> ?: continue

                for (cartItem in cartItems) {
                    val cartItemName = cartItem?.get("name") as? String ?: continue
                    val cartItemQuantity = cartItem["quantity"]?.toString() ?: continue
                    val cartProductAddOnItemSelected = cartItem["cartProductAddOnItemSelected"] as? List<Map<*, *>> ?: continue

                    printer?.addTextInLine(body, "${cartItemQuantity}x ${cartItemName}", "", "", 0)

                    for (cartItemAdditionalSelectedItem in cartProductAddOnItemSelected) {
                        val cartItemAdditionalSelectedItemName = cartItemAdditionalSelectedItem?.get("name") as? String
                        printer?.addTextInLine(body, "- $cartItemAdditionalSelectedItemName", "", "", 0)
                    }

                    totalQuantity += 1
                }
            }
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "TOTAL", "", "${totalQuantity} pcs", 0)
        printer?.addText(body, "--------------------------------")

        if (canAccessCustomReceipt) {
            if(isShowEMenuLink) {
                printer?.addText(body, "Cek e-menu $merchantName di")
                printer?.addText(body, eMenuLinkShort)
            }
            if(additionalMessage.isNotEmpty()) {
                printer?.addText(body, additionalMessage)
            }
        }
        printer?.addText(body, "--------------------------------")

        val socialMedia: MutableMap<String, String> = mutableMapOf(
            "instagram" to "",
            "facebook" to "",
            "twitter" to "",
            "tiktok" to "",
            "website" to ""
        )

        if (canAccessCustomReceipt) {
            for (customReceiptLink in customReceiptLinks) {
                val name = customReceiptLink["name"] as String
                val link = customReceiptLink["link"] as String
                socialMedia[name] = link;
            }
        }

        socialMedia.forEach { (key, value) ->
            printer?.addText(bodySocialMedia, "${key.capitalizeFirstLetter()}: @${value}")
        }
        printer?.addText(header, "--------------------------------")
        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")

    }
    fun printDetailOpenBill(
        printer: IPrinter?,
        youtapLogo: Bitmap?,
        merchantLogoBitmap: Bitmap?,
        openBill: Map<*, *>?,
        priceAdjustmentAddition: List<Map<*, *>?>,
        priceAdjustmentReduction: List<Map<*, *>?>,
        taxAmount: Int,
        roundingAmount: Int,
        totalAmount: Int,
        customReceipt: Map<*, *>?,
        orderNumber: Int,
        canAccessCustomReceipt: Boolean,
        eMenuLinkShort: String?,
        isDevicePax: Boolean,
    ) {
        /// Custom Receipt
        val merchantName = customReceipt?.get("merchantName") as String
        val address = customReceipt?.get("address") as String
        val additionalMessage = customReceipt?.get("additionalMessage") as String
        val phone = customReceipt?.get("phone") as String
        val customReceiptLinks = customReceipt?.get("customReceiptLinks") as List<Map<*,*>>
        val isShowEMenuLink = customReceipt?.get("isShowEMenuLink") as Boolean

        /// Open Bill
        val openBillName = openBill?.get("name") as String
        val openBillCreatedAt = openBill?.get("createdAt") as String
        val cartItemListMixed =  openBill?.get("cartItemListMixed") as? List<Map<*, *>>?
        val totalOpenBillAmount = openBill?.get("totalOpenBillAmount") as Int

        Logger.log("\n ///////////////// CONTENT_TO_PRINT_DETAIL_OPEN_BILL /////////////////")
        val header = Bundle()
        header.putInt("font", 2)
        header.putInt("align", 1)
        header.putBoolean("newline", true)

        val body = Bundle()
        body.putInt("font", 2)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val bodySocialMedia = Bundle()
        bodySocialMedia.putInt("font", 2)
        bodySocialMedia.putInt("align", 0)
        bodySocialMedia.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        val formatMerchantLogo = Bundle()
        formatMerchantLogo.putInt("offset", 30)
        formatMerchantLogo.putInt("width", 200)
        formatMerchantLogo.putInt("height", 90)

        printer?.addText(body, "\n\n")
        if(merchantLogoBitmap != null) {
            printer?.addBmpImage(formatMerchantLogo, merchantLogoBitmap)
        }
        printer?.addText(header, merchantName)
        printer?.addText(header, address)
        printer?.addText(header, phone)

        printer?.addText(header, "---Tagihan Sementara---")
        printer?.addText(header, openBillName)

        printer?.addTextInLine(body, "No. Order", "", orderNumber.toString(), 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Waktu", "", openBillCreatedAt.toString(), 0)
        printer?.addText(body, "--------------------------------")

        if (cartItemListMixed != null) {
            for (cartItem in cartItemListMixed) {
                val cartItemName = cartItem?.get("name") as? String ?: continue
                val cartItemQuantity = cartItem["quantity"]?.toString() ?: continue
                val cartProductAddOnItemSelected = cartItem["cartProductAddOnItemSelected"] as? List<Map<*, *>> ?: continue

                printer?.addTextInLine(body, "${cartItemQuantity}x ${cartItemName}", "", "", 0)

                for (cartItemAdditionalSelectedItem in cartProductAddOnItemSelected) {
                    val cartItemAdditionalSelectedItemName = cartItemAdditionalSelectedItem?.get("name") as? String
                    printer?.addTextInLine(body, "- $cartItemAdditionalSelectedItemName", "", "", 0)
                }
            }
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Subtotal", "", "${totalOpenBillAmount.getInIDR()}", 0)
        printer?.addText(body, "--------------------------------")


        for (priceAdjustmentAdditionItem in priceAdjustmentAddition) {
            val name = priceAdjustmentAdditionItem?.get("name") as String
            val amountFinal = priceAdjustmentAdditionItem?.get("amountFinal") as Int

            printer?.addTextInLine(body, name, "", amountFinal.getInIDR(), 0)
        }

        for (priceAdjustmentReductionItem in priceAdjustmentReduction) {
            val name = priceAdjustmentReductionItem?.get("name") as String
            val amountFinal = priceAdjustmentReductionItem?.get("amountFinal") as Int

            printer?.addTextInLine(body, name, "", "-${amountFinal.getInIDR()}", 0)
        }

        if(taxAmount > 0) {
            printer?.addTextInLine(body, "Pajak", "", taxAmount.getInIDR(), 0)
        }

        if(roundingAmount > 0) {
            printer?.addTextInLine(body, "Pembulatan", "", roundingAmount.getInIDR(), 0)
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "TOTAL", "", totalAmount.getInIDR(), 0)
        printer?.addText(body, "--------------------------------")

        if (canAccessCustomReceipt) {
            if(isShowEMenuLink) {
                printer?.addText(body, "Cek e-menu $merchantName di")
                printer?.addText(body, eMenuLinkShort)
            }
            if(additionalMessage.isNotEmpty()) {
                printer?.addText(body, additionalMessage)
            }
        }
        printer?.addText(body, "--------------------------------")

        val socialMedia: MutableMap<String, String> = mutableMapOf(
            "instagram" to "",
            "facebook" to "",
            "twitter" to "",
            "tiktok" to "",
            "website" to ""
        )

        if (canAccessCustomReceipt) {
            for (customReceiptLink in customReceiptLinks) {
                val name = customReceiptLink["name"] as String
                val link = customReceiptLink["link"] as String
                socialMedia[name] = link;
            }
        }

        socialMedia.forEach { (key, value) ->
            printer?.addText(bodySocialMedia, "${key.capitalizeFirstLetter()}: @${value}")
        }
        printer?.addText(header, "--------------------------------")
        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")

    }
    fun printCloseBill(
        printer: IPrinter?,
        youtapLogo: Bitmap?,
        merchantLogoBitmap: Bitmap?,
        openBill: Map<*, *>?,
        transaction: Map<*, *>?,
        orderNumber: Int,
        customReceipt: Map<*, *>?,
        canAccessCustomReceipt: Boolean,
        eMenuLinkShort: String?,
        showMpmQr: Boolean,
        isDevicePax: Boolean,
    ) {
        val transactionItems = transaction?.get("transactionItems") as List<Map<*,*>>
        val merchantQrCode = transaction?.get("merchantQrCode") as String
        val subTotal = transaction?.get("subTotal") as Int
        val total = transaction?.get("total") as Int
        val transactionPriceAdjustments = transaction?.get("transactionPriceAdjustments") as List<Map<*,*>>
        val taxAmount = transaction?.get("taxAmount") as Int
        val taxType = transaction?.get("taxType") as String
        val roundingDifference = transaction?.get("roundingDifference") as Int

        /// Custom Receipt
        val merchantName = customReceipt?.get("merchantName") as String
        val address = customReceipt?.get("address") as String
        val additionalMessage = customReceipt?.get("additionalMessage") as String
        val phone = customReceipt?.get("phone") as String
        val customReceiptLinks = customReceipt?.get("customReceiptLinks") as List<Map<*,*>>
        val isShowEMenuLink = customReceipt?.get("isShowEMenuLink") as Boolean

        /// Open Bill
        val openBillName = openBill?.get("name") as String
        val openBillCreatedAt = openBill?.get("createdAt") as String

        Logger.log("\n ///////////////// CONTENT_TO_PRINT_DETAIL_CLOSE_BILL /////////////////")
        Logger.log("\n ///////////////// isDevicePax : $isDevicePax")

        val header = Bundle()
        header.putInt("font", 2)
        header.putInt("align", 1)
        header.putBoolean("newline", true)

        val body = Bundle()
        body.putInt("font", 2)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val bodySocialMedia = Bundle()
        bodySocialMedia.putInt("font", 2)
        bodySocialMedia.putInt("align", 0)
        bodySocialMedia.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        val formatMerchantLogo = Bundle()
        formatMerchantLogo.putInt("offset", 30)
        formatMerchantLogo.putInt("width", 200)
        formatMerchantLogo.putInt("height", 90)

        val formatQr = Bundle()
        formatQr.putInt("offset", 40)
        formatQr.putInt("expectedHeight", 320)

        printer?.addText(body, "\n\n")
        if(merchantLogoBitmap != null) {
            printer?.addBmpImage(formatMerchantLogo, merchantLogoBitmap)
        }
        printer?.addText(header, merchantName)
        printer?.addText(header, address)
        printer?.addText(header, phone)

        printer?.addText(header, openBillName)

        printer?.addTextInLine(body, "No. Order", "", orderNumber.toString(), 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Waktu", "", openBillCreatedAt.toString(), 0)
        printer?.addText(body, "--------------------------------")

        for (mapTransactionItem in transactionItems) {
            val productName = mapTransactionItem["productName"] as String
            val quantity = mapTransactionItem["quantity"] as Int
            val price = mapTransactionItem["price"] as Int
            val quantityMultiplyWithPrice = (quantity * price)
            printer?.addTextInLine(body, "${quantity}x ${productName}", "", "Rp.${quantityMultiplyWithPrice}", 1)

            val addOnItems = mapTransactionItem["addOnItems"] as List<Map<*,*>>
            for (mapAddOnItem in addOnItems) {
                val addOnItemName = mapAddOnItem["name"] as String
                val addOnItemPrice = mapAddOnItem["price"] as String
                printer?.addTextInLine(body, "- $addOnItemName", "", addOnItemPrice, 1)
            }
        }

        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Subtotal", "", "${subTotal.getInIDR()}", 0)
        printer?.addText(body, "--------------------------------")

        for (mapTransactionPriceAdjustments in transactionPriceAdjustments) {
            val name = mapTransactionPriceAdjustments["name"] as String
            val calculatedAmount = mapTransactionPriceAdjustments["calculatedAmount"] as String
            printer?.addTextInLine(body, name, "", calculatedAmount, 0)
        }

        if(taxAmount > 0) {
            printer?.addTextInLine(body, taxType, "", taxAmount.getInIDR(), 0)
        }

        if(roundingDifference > 0) {
            printer?.addTextInLine(body, "Pembulatan", "", roundingDifference.getInIDR(), 0)
        }

        if(taxAmount > 0 || roundingDifference > 0 || transactionPriceAdjustments.isNotEmpty()) {
            printer?.addText(body, "--------------------------------")
        }

        printer?.addTextInLine(body, "TOTAL TAGIHAN", "", total.getInIDR(), 0)

        printer?.addText(body, "--------------------------------")
        if (showMpmQr) {
            /// QR MPM
            printer?.addText(body, "Scan kode QR berikut untuk melakukan pembayaran.")
            printer?.addQrCode(formatQr, merchantQrCode)
        }

        if (canAccessCustomReceipt) {
            if(isShowEMenuLink) {
                printer?.addText(body, "Cek e-menu $merchantName di")
                printer?.addText(body, eMenuLinkShort)
            }
            if(additionalMessage.isNotEmpty()) {
                printer?.addText(body, additionalMessage)
            }
        }
        printer?.addText(body, "--------------------------------")

        val socialMedia: MutableMap<String, String> = mutableMapOf(
            "instagram" to "",
            "facebook" to "",
            "twitter" to "",
            "tiktok" to "",
            "website" to ""
        )

        if (canAccessCustomReceipt) {
            for (customReceiptLink in customReceiptLinks) {
                val name = customReceiptLink["name"] as String
                val link = customReceiptLink["link"] as String
                socialMedia[name] = link;
            }
        }

        socialMedia.forEach { (key, value) ->
            printer?.addText(bodySocialMedia, "${key.capitalizeFirstLetter()}: @${value}")
        }
        printer?.addText(header, "--------------------------------")
        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")

    }
    fun printReportCashier(
        printer: IPrinter?,
        youtapLogo: Bitmap?,
        merchantName: String,
        openCashierDate: String,
        closeCashierDate: String,
        reportCashier: Map<*, *>?,
        endCash: String,
        reportCashierSwitcherValue: Map<*, *>?,
        isPreview: Boolean,
        isDevicePax: Boolean,
    ) {

        val initialCash = reportCashier?.get("initialCash") as Double
        val endingCash = reportCashier?.get("endingCash") as Double
        val cashExpenses = reportCashier?.get("cashExpenses") as List<Map<*,*>>
        val products = reportCashier?.get("products") as List<Map<*,*>>
        val tax = reportCashier?.get("tax") as Double
        val completedTransaction = reportCashier?.get("completedTransaction") as Double
        val completedTransactionPHP = reportCashier?.get("completedTransactionPHP") as Double
        val cash = reportCashier?.get("cash") as Double
        val nonCash = reportCashier?.get("nonCash") as Double
        val creditCard = reportCashier?.get("creditCard") as Double
        val debitCard = reportCashier?.get("debitCard") as Double
        val goFood = reportCashier?.get("goFood") as Double
        val grabFood = reportCashier?.get("grabFood") as Double
        val transfer = reportCashier?.get("transfer") as Double
        val qris = reportCashier?.get("qris") as Double
        val others = reportCashier?.get("others") as Double
        val cashExpenseTotal = reportCashier?.get("cashExpenseTotal") as Double
        val openBillNotPaid = reportCashier?.get("openBillNotPaid") as Double
        val phpNotPaid = reportCashier?.get("phpNotPaid") as Double
        val totalPriceAdjustmentReduction = reportCashier?.get("totalPriceAdjustmentReduction") as Double
        val totalPriceAdjustmentAddition = reportCashier?.get("totalPriceAdjustmentAddition") as Double
        val user = reportCashier?.get("user") as Map<*,*>
        val userName = user?.get("name") as String

        val showPaymentMethodReport = reportCashierSwitcherValue?.get("showPaymentMethodReport") as Boolean
        val showPriceAdjustmentReport = reportCashierSwitcherValue?.get("showPriceAdjustmentReport") as Boolean
        val showTransactionInfoReport = reportCashierSwitcherValue?.get("showTransactionInfoReport") as Boolean
        val showSoldProductReport = reportCashierSwitcherValue?.get("showSoldProductReport") as Boolean

        Logger.log("\n ///////////////// CONTENT_TO_PRINT_REPORT_CASHIER /////////////////")
        Logger.log("\n ///////////////// isDevicePax : $isDevicePax")

        val header = Bundle()
        header.putInt("font", 2)
        header.putInt("align", 1)
        header.putBoolean("newline", true)

        val body = Bundle()
        body.putInt("font", 2)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        printer?.addText(header, merchantName)
        printer?.addText(header, "\n")

        printer?.addTextInLine(body, "Kasir", "", userName, 0)
        printer?.addTextInLine(body, "Tgl Buka", "", openCashierDate, 0)
        printer?.addTextInLine(body, "Tgl Tutup", "", closeCashierDate, 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Tunai", "", cash.getInIDRWithSpace, 0)
        printer?.addTextInLine(body, "Non-Tunai", "", nonCash.getInIDRWithSpace, 0)
        printer?.addText(body, "--------------------------------")
        printer?.addTextInLine(body, "Total", "", (cash + nonCash).getInIDRWithSpace, 0)
        printer?.addText(body, "--------------------------------")

        if(showPaymentMethodReport) {
            printer?.addTextInLine(body, "QRIS", "", qris.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Cash", "", cash.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Credit Card", "", creditCard.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Debit Card", "", debitCard.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "GoFood", "", goFood.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "GrabFood", "", grabFood.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Transfer", "", transfer.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Lainnya", "", others.getInIDRWithSpace, 0)
            printer?.addText(body, "--------------------------------")
        }

        if(cashExpenses.isNotEmpty()) {
            printer?.addTextInLine(body, "Pengeluaran Kas", "", "", 0)
        }

        for (cashExpensesItem in cashExpenses) {
            val title = cashExpensesItem["title"] as String
            val price = cashExpensesItem["price"] as Double
            printer?.addTextInLine(body, title, "", price.getInIDRWithSpace, 0)
        }

        if(cashExpenses.isNotEmpty()) {
            printer?.addText(body, "--------------------------------")
        }

        printer?.addTextInLine(body, "Kas Awal", "", initialCash.getInIDRWithSpace, 0)
        printer?.addTextInLine(body, "Total Tunai", "", cash.getInIDRWithSpace, 0)
        printer?.addTextInLine(body, "Pengeluaran Kas", "", cashExpenseTotal.getInIDRWithSpace, 0)

        val formattedEndingCash: String = if (isPreview) {
            endCash.toDouble().getInIDRWithSpace
        } else {
            endingCash.getInIDRWithSpace
        }

        printer?.addTextInLine(body, "Kas Akhir", "", formattedEndingCash, 0)
        printer?.addTextInLine(body, "Selisih", "", getDifferenceAmount(reportCashier, isPreview, endCash).getInIDRWithSpace, 0)
        printer?.addText(body, "--------------------------------")

        if (showPriceAdjustmentReport) {
            printer?.addTextInLine(body, "Pajak", "", tax.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Tambah Harga", "", totalPriceAdjustmentAddition.getInIDRWithSpace, 0)
            printer?.addTextInLine(body, "Kurang Harga", "", totalPriceAdjustmentReduction.getInIDRWithSpace, 0)
            printer?.addText(body, "--------------------------------")
        }

        if (showTransactionInfoReport) {
            printer?.addTextInLine(body, "Total Penjualan", "", completedTransaction.inAmount, 0)
            printer?.addTextInLine(body, "Total PHP", "", completedTransactionPHP.inAmount, 0)
            printer?.addTextInLine(body, "Total Tagihan", "", openBillNotPaid.inAmount, 0)
            printer?.addTextInLine(body, "PHP Diproses", "", phpNotPaid.inAmount, 0)
            printer?.addText(body, "--------------------------------")
        }

        if (showSoldProductReport) {
            for (item in products) {
                val name = item["name"] as String
                val quantity = item["quantity"] as Double
                printer?.addTextInLine(body, name, "", "QTY: ${quantity.inAmount}", 0)
            }
            if(products.isNotEmpty()){
                printer?.addText(body, "--------------------------------")
            }
        }

        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")

    }

    fun getDifferenceAmount(reportCashier: Map<*,*>, isPreview: Boolean, endCash: String): Double {

        val initialCash = reportCashier?.get("initialCash") as Double
        val cash = reportCashier?.get("cash") as Double
        val endingCash = reportCashier?.get("endingCash") as Double
        val cashExpenseTotal = reportCashier?.get("cashExpenseTotal") as Double

        return if (isPreview) {
            if (endCash.isNotEmpty()) {
                endCash.toDouble() -
                        ((initialCash + cash) -
                                cashExpenseTotal)
            } else {
                0.0 -
                        ((initialCash + cash) -
                                cashExpenseTotal)
            }
        } else {
            endingCash -
                    ((initialCash + cash) -
                            cashExpenseTotal)
        }
    }

    fun examplePrint(printer: IPrinter?, youtapLogo: Bitmap?, merchantLogo: Bitmap?) {

        val header = Bundle()
        header.putInt("font", 1)
        header.putInt("align", 1)
        header.putBoolean("newline", true)

        val body = Bundle()
        body.putInt("font", 1)
        body.putInt("align", 1)
        body.putBoolean("newline", true)

        val formatYoutapLogo = Bundle()
        formatYoutapLogo.putInt("offset", 100)
        formatYoutapLogo.putInt("width", 200)
        formatYoutapLogo.putInt("height", 90)

        val formatMerchantLogo = Bundle()
        formatMerchantLogo.putInt("offset", 30)
        formatMerchantLogo.putInt("width", 200)
        formatMerchantLogo.putInt("height", 90)

        val formatQr = Bundle()
        formatQr.putInt("offset", 40)
        formatQr.putInt("expectedHeight", 320)

        printer?.addText(body, "\n\n")
        printer?.addBmpImage(formatMerchantLogo, merchantLogo)
        printer?.addText(header, "WEI RESTAURANT")
        printer?.addText(header, "Jalan ABC no 123 Blok 1-2, Kebayoran Baru Jakarta Selatan")
        printer?.addText(header, "628112348000")

        printer?.addTextInLine(body, "Order No", "", "12", 0)
        printer?.addTextInLine(body, "Date & Time", "", "628112348000", 0)
        printer?.addTextInLine(body, "Trail ID", "", "628112348000", 0)
        printer?.addText(body, "--------------------------------")

        printer?.addTextInLine(body, "1x Mie ayam jamur spesial dengan bakso", "", "Rp.22.000", 0)
        printer?.addTextInLine(body, "2x Mie ayam jamur ", "", "Rp.22.000", 0)
        printer?.addTextInLine(body, "- Pedas ", "", "Rp.22.000", 0)
        printer?.addTextInLine(body, "- Normal ", "", "Rp.22.000", 0)
        printer?.addText(body, "--------------------------------")

        printer?.addTextInLine(body, "TOTAL", "", "Rp.99.000", 0)
        printer?.addText(body, "--------------------------------")

        printer?.addText(body, "Scan kode QR berikut untuk melakukan pembayaran.")
        printer?.addQrCode(formatQr, "mftImwyjc5twrGeEQiWcsxQrgRNUnHAvOUoTfVaekt8.")
        printer?.addText(body, "Usaha Mantap dengan Youtap..")
        printer?.addText(body, "--------------------------------")

        printer?.addTextInLine(body, "Pembayaran", "", "Rp.99.000", 0)
        printer?.addTextInLine(body, "Uang Pembayaran", "", "Rp.99.000", 0)
        printer?.addTextInLine(body, "Kembalian", "", "Rp.99.000", 0)
        printer?.addText(header, "--------------------------------")
        printer?.addTextInLine(body, "", "Powered by Youtap", "", 0)
        printer?.addBmpImage(formatYoutapLogo, youtapLogo)
        printer?.addText(body, "\n\n")
    }

}
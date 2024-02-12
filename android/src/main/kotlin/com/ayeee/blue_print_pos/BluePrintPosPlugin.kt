package com.ayeee.blue_print_pos

import android.annotation.SuppressLint
import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.res.AssetManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.WindowInsets
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.ayeee.blue_print_pos.extension.toBitmap
import com.ayeee.blue_print_pos.extension.toByteArray
import com.vfi.smartpos.deviceservice.aidl.IDeviceService
import com.vfi.smartpos.deviceservice.aidl.IPrinter
import com.vfi.smartpos.deviceservice.aidl.PrinterListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.IOException
import java.io.InputStream
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.SimpleTarget
import com.bumptech.glide.request.transition.Transition

/** BluePrintPosPlugin */
class BluePrintPosPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private lateinit var context: Context

    private var deviceService: IDeviceService? = null
    private var printer: IPrinter? = null
    private val _printTemplate = PrintTemplate()

    private val connection: ServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(p0: ComponentName?, service: IBinder?) {
            deviceService = IDeviceService.Stub.asInterface(service)
            try {
                printer = deviceService?.printer
                Log.d("Services", "bind service success")
            }catch (e: Exception) {
                Log.e("Services", e.message, e)
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.d("Services", "${name?.packageName} is disconnected")
            deviceService = null
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val viewID = "webview-view-type"
        flutterPluginBinding.platformViewRegistry.registerViewFactory(viewID, FLNativeViewFactory())

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "blue_print_pos")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val arguments = call.arguments as Map<*, *>
        if (call.method == "contentToImage") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_IMAGE",
                    "Unsupported Android version",
                    null
                )
                return
            }
            val content = arguments["content"] as String
            val duration = arguments["duration"] as Double?
            val textScaleFactor: Double? = arguments["textScaleFactor"] as? Double?
            val textZoom: Int? = textScaleFactor?.let { (it * 100).toInt() }
            _contentToImage(content, textZoom, result, duration)
        } else if (call.method == "printReceiptPayment") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_PRINT_RECEIPT_PAYMENT",
                    "Unsupported Android version",
                    null
                )
                return
            }

            /// Your code for "printReceiptPayment" goes here
            val merchant = arguments["merchant"] as Map<*, *>
            val transaction = arguments["transaction"] as Map<*, *>
            val customReceipt = arguments["customReceipt"] as? Map<*, *>?
            val orderNumber = arguments["orderNumber"] as Int
            val paidAmount = arguments["paidAmount"] as? String
            val changeAmount = arguments["changeAmount"] as? String
            val reward = arguments["reward"] as? Map<*, *>?
            val canShowRewardQR = arguments["canShowRewardQR"] as Boolean
            val canAccessCustomReceipt = arguments["canAccessCustomReceipt"] as Boolean
            val canShowTicketingQR = arguments["canShowTicketingQR"] as Boolean
            val openDrawer = arguments["openDrawer"] as Boolean
            val eMenuLinkShort = arguments["eMenuLinkShort"] as? String
            val isDevicePax = arguments["isDevicePax"] as Boolean
            val youtapLogo = getBitmapFromAsset("images/main_logo_black.jpg");
            val merchantLogo = customReceipt?.get("logo") as String

            Handler(Looper.getMainLooper()).postDelayed({
                loadBitmapFromUrl(context, merchantLogo) { merchantLogoBitmap ->
                    if (merchantLogoBitmap != null) {
                        _printTemplate.receiptPayment(
                            printer,
                            youtapLogo,
                            merchantLogoBitmap,
                            merchant,
                            transaction,
                            customReceipt,
                            orderNumber,
                            paidAmount,
                            changeAmount,
                            reward,
                            canShowRewardQR,
                            canAccessCustomReceipt,
                            canShowTicketingQR,
                            openDrawer,
                            eMenuLinkShort,
                            isDevicePax
                        )
                        startPrintVerifone()
                    } else {
                        _printTemplate.receiptPayment(
                            printer,
                            youtapLogo,
                            null,
                            merchant,
                            transaction,
                            customReceipt,
                            orderNumber,
                            paidAmount,
                            changeAmount,
                            reward,
                            canShowRewardQR,
                            canAccessCustomReceipt,
                            canShowTicketingQR,
                            openDrawer,
                            eMenuLinkShort,
                            isDevicePax
                        )
                        startPrintVerifone()
                    }
                }
            }, 3000)

        } else if (call.method == "printOrder") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_PRINT_ORDER",
                    "Unsupported Android version",
                    null
                )
                return
            }

            val transaction = arguments["transaction"] as Map<*, *>
            val orderNumber = arguments["orderNumber"] as Int
            val canShowTicketingQR = arguments["canShowTicketingQR"] as Boolean
            val isDevicePax = arguments["isDevicePax"] as Boolean

            val youtapLogo = getBitmapFromAsset("images/main_logo_black.jpg");

            _printTemplate.printOrder(
                printer,
                youtapLogo,
                transaction,
                orderNumber,
                canShowTicketingQR,
                isDevicePax
            )
            startPrintVerifone()

        } else if (call.method == "printOpenBill") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_PRINT_OPEN_BILL",
                    "Unsupported Android version",
                    null
                )
                return
            }

            val openBill = arguments["openBill"] as? Map<*, *>?
            val customReceipt = arguments["customReceipt"] as? Map<*, *>?
            val isAdditional = arguments["isAdditional"] as Boolean
            val cartItemAdditional = arguments["cartItemAdditional"] as List<Map<*, *>?>
            val orderNumber = arguments["orderNumber"] as Int
            val canAccessCustomReceipt = arguments["canAccessCustomReceipt"] as Boolean
            val eMenuLinkShort = arguments["eMenuLinkShort"] as String
            val isDevicePax = arguments["isDevicePax"] as Boolean
            val youtapLogo = getBitmapFromAsset("images/main_logo_black.jpg");
            val merchantLogo = customReceipt?.get("logo") as String

            Handler(Looper.getMainLooper()).postDelayed({
                loadBitmapFromUrl(context, merchantLogo) { merchantLogoBitmap ->
                    if (merchantLogoBitmap != null) {
                        _printTemplate.printOpenBill(
                            printer,
                            youtapLogo,
                            merchantLogoBitmap,
                            openBill,
                            customReceipt,
                            isAdditional,
                            cartItemAdditional,
                            orderNumber,
                            canAccessCustomReceipt,
                            eMenuLinkShort,
                            isDevicePax
                        )
                        startPrintVerifone()
                    } else {
                        _printTemplate.printOpenBill(
                            printer,
                            youtapLogo,
                            null,
                            openBill,
                            customReceipt,
                            isAdditional,
                            cartItemAdditional,
                            orderNumber,
                            canAccessCustomReceipt,
                            eMenuLinkShort,
                            isDevicePax
                        )
                        startPrintVerifone()
                    }
                }
            }, 3000)

        } else if (call.method == "printDetailOpenBill") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_PRINT_DETAIL_OPEN_BILL",
                    "Unsupported Android version",
                    null
                )
                return
            }

            val openBill = arguments["openBill"] as? Map<*, *>?
            val priceAdjustmentAddition = arguments["priceAdjustmentAddition"] as List<Map<*, *>?>
            val priceAdjustmentReduction = arguments["priceAdjustmentReduction"] as List<Map<*, *>?>
            val taxAmount = arguments["taxAmount"] as Int
            val roundingAmount = arguments["roundingAmount"] as Int
            val totalAmount = arguments["totalAmount"] as Int
            val customReceipt = arguments["customReceipt"] as? Map<*, *>?
            val orderNumber = arguments["orderNumber"] as Int
            val canAccessCustomReceipt = arguments["canAccessCustomReceipt"] as Boolean
            val eMenuLinkShort = arguments["eMenuLinkShort"] as String
            val isDevicePax = arguments["isDevicePax"] as Boolean
            val youtapLogo = getBitmapFromAsset("images/main_logo_black.jpg");
            val merchantLogo = customReceipt?.get("logo") as String

            Handler(Looper.getMainLooper()).postDelayed({
                loadBitmapFromUrl(context, merchantLogo) { merchantLogoBitmap ->
                    if (merchantLogoBitmap != null) {
                        _printTemplate.printDetailOpenBill(
                            printer,
                            youtapLogo,
                            merchantLogoBitmap,
                            openBill,
                            priceAdjustmentAddition,
                            priceAdjustmentReduction,
                            taxAmount,
                            roundingAmount,
                            totalAmount,
                            customReceipt,
                            orderNumber,
                            canAccessCustomReceipt,
                            eMenuLinkShort,
                            isDevicePax
                        )
                        startPrintVerifone()
                    } else {
                        _printTemplate.printDetailOpenBill(
                            printer,
                            youtapLogo,
                            null,
                            openBill,
                            priceAdjustmentAddition,
                            priceAdjustmentReduction,
                            taxAmount,
                            roundingAmount,
                            totalAmount,
                            customReceipt,
                            orderNumber,
                            canAccessCustomReceipt,
                            eMenuLinkShort,
                            isDevicePax
                        )
                        startPrintVerifone()
                    }
                }
            }, 3000)

        } else if (call.method == "printCloseBill") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_PRINT_CLOSE_BILL",
                    "Unsupported Android version",
                    null
                )
                return
            }

            val openBill = arguments["openBill"] as? Map<*, *>?
            val transaction = arguments["transaction"] as? Map<*, *>?
            val orderNumber = arguments["orderNumber"] as Int
            val customReceipt = arguments["customReceipt"] as? Map<*, *>?
            val canAccessCustomReceipt = arguments["canAccessCustomReceipt"] as Boolean
            val eMenuLinkShort = arguments["eMenuLinkShort"] as String
            val showMpmQr = arguments["showMpmQr"] as Boolean
            val isDevicePax = arguments["isDevicePax"] as Boolean
            val youtapLogo = getBitmapFromAsset("images/main_logo_black.jpg");
            val merchantLogo = customReceipt?.get("logo") as String

            Handler(Looper.getMainLooper()).postDelayed({
                loadBitmapFromUrl(context, merchantLogo) { merchantLogoBitmap ->
                    if (merchantLogoBitmap != null) {
                        _printTemplate.printCloseBill(
                            printer,
                            youtapLogo,
                            merchantLogoBitmap,
                            openBill,
                            transaction,
                            orderNumber,
                            customReceipt,
                            canAccessCustomReceipt,
                            eMenuLinkShort,
                            showMpmQr,
                            isDevicePax
                        )
                        startPrintVerifone()
                    } else {
                        _printTemplate.printCloseBill(
                            printer,
                            youtapLogo,
                            null,
                            openBill,
                            transaction,
                            orderNumber,
                            customReceipt,
                            canAccessCustomReceipt,
                            eMenuLinkShort,
                            showMpmQr,
                            isDevicePax
                        )
                        startPrintVerifone()
                    }
                }
            }, 3000)


        } else if (call.method == "printReportCashier") {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                result.error(
                    "FAILED_CONTENT_TO_PRINT_REPORT_VERSION",
                    "Unsupported Android version",
                    null
                )
                return
            }

            val merchantName = arguments["merchantName"] as String
            val openCashierDate = arguments["openCashierDate"] as String
            val closeCashierDate = arguments["closeCashierDate"] as String
            val reportCashier = arguments["reportCashier"] as? Map<*, *>?
            val endCash = arguments["endCash"] as String
            val reportCashierSwitcherValue = arguments["reportCashierSwitcherValue"] as? Map<*, *>?
            val isPreview = arguments["isPreview"] as Boolean
            val isDevicePax = arguments["isDevicePax"] as Boolean
            val youtapLogo = getBitmapFromAsset("images/main_logo_black.jpg");

            Handler(Looper.getMainLooper()).postDelayed({
                _printTemplate.printReportCashier(
                    printer,
                    youtapLogo,
                    merchantName,
                    openCashierDate,
                    closeCashierDate,
                    reportCashier,
                    endCash,
                    reportCashierSwitcherValue,
                    isPreview,
                    isDevicePax
                )
                startPrintVerifone()
            }, 3000)


        } else {
            result.notImplemented()
        }
    }

    private fun getBitmapFromAsset(pathFile: String?): Bitmap? {
        val assetManager: AssetManager? = context.assets
        var inputStream: InputStream? = null
        try {
            if (assetManager != null) {
                inputStream = pathFile?.let { assetManager.open(it) }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return BitmapFactory.decodeStream(inputStream)
    }

    private fun loadBitmapFromUrl(context: Context, imageUrl: String, callback: (Bitmap?) -> Unit) {
        Glide.with(context)
            .asBitmap()
            .load(imageUrl)
            .into(object : SimpleTarget<Bitmap>() {
                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    callback(resource)
                }
            })
    }

    private fun startPrintVerifone() {
        printer?.startPrint(object : PrinterListener.Stub() {
            override fun onFinish() {
            }
            override fun onError(error: Int) {
            }
        })
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    @SuppressLint("SetJavaScriptEnabled")
    private fun _contentToImage(
        content: String,
        textZoom: Int?,
        result: Result,
        duration: Double?
    ) {
        val webView = WebView(this.context)
        val dWidth: Int
        val dHeight: Int
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val windowMetrics = activity.windowManager.currentWindowMetrics
            val insets =
                windowMetrics.windowInsets.getInsetsIgnoringVisibility(WindowInsets.Type.systemBars())
            dWidth = windowMetrics.bounds.width() - insets.left - insets.right
            dHeight = windowMetrics.bounds.height() - insets.bottom - insets.top
        } else {
            dWidth = activity.window.windowManager.defaultDisplay.width
            dHeight = activity.window.windowManager.defaultDisplay.height
        }
        Logger.log("\ndwidth : $dWidth")
        Logger.log("\ndheight : $dHeight")
        webView.layout(0, 0, dWidth, dHeight)
        webView.loadDataWithBaseURL(null, content, "text/HTML", "UTF-8", null)
        webView.setInitialScale(1)
        webView.settings.javaScriptEnabled = true
        webView.settings.useWideViewPort = true
        webView.settings.javaScriptCanOpenWindowsAutomatically = true
        webView.settings.loadWithOverviewMode = true
        webView.settings.textZoom = textZoom ?: webView.settings.textZoom
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Logger.log("\n=======> enabled scrolled <=========")
            WebView.enableSlowWholeDocumentDraw()
        }

        Logger.log("\n ///////////////// webview setted /////////////////")

        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView, url: String) {
                super.onPageFinished(view, url)

                Handler(Looper.getMainLooper()).postDelayed({
                    Logger.log("\n ================ webview completed ==============")
                    Logger.log("\n scroll delayed ${webView.scrollBarFadeDuration}")

                    webView.evaluateJavascript("document.body.offsetWidth") { offsetWidth ->
                        webView.evaluateJavascript("document.body.offsetHeight") { offsetHeight ->
                            Logger.log("\noffsetWidth : $offsetWidth")
                            Logger.log("\noffsetHeight : $offsetHeight")
                            if (offsetWidth == null || offsetWidth.isEmpty() || offsetHeight == null || offsetHeight.isEmpty()) {
                                result.error(
                                    "FAILED_CONTENT_TO_IMAGE",
                                    "Failed to convert content to image",
                                    null
                                )
                                return@evaluateJavascript
                            }

                            val data: Bitmap? = webView.toBitmap(
                                offsetWidth.toDouble(),
                                offsetHeight.toDouble(),
                                dWidth,
                            )
                            if (data == null) {
                                result.error(
                                    "FAILED_CONTENT_TO_IMAGE",
                                    "Failed to convert content to image",
                                    null
                                )
                            } else {
                                val bytes: ByteArray = data.toByteArray()
                                result.success(bytes)
                                Logger.log("\n Got snapshot")
                            }

                        }
                    }

                }, (duration ?: 0.0).toLong())

            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Logger.log("onAttachedToActivity")
        activity = binding.activity
        context = activity.applicationContext
        WebView(activity.applicationContext).apply {
            minimumHeight = 1
            minimumWidth = 1
        }

        val intent = Intent()
        intent.action = "com.vfi.smartpos.device_service"
        intent.`package` = "com.vfi.smartpos.deviceservice"

        val serviceConnection = context.bindService(intent, connection, Context.BIND_AUTO_CREATE)
        if (serviceConnection) {
            Log.d("BluePrintPosPlugin", "Connected")
        } else {
            Log.d("BluePrintPosPlugin", "not connected")
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // This call will be followed by onReattachedToActivityForConfigChanges().
        Logger.log("onDetachedFromActivityForConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Logger.log("onAttachedToActivity")
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        Logger.log("onDetachedFromActivity")
        // Unbind the service when the plugin is detached
        if (deviceService != null) {
            context.unbindService(connection)
            deviceService = null
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

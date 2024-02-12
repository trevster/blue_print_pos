package com.vfi.smartpos.deviceservice.aidl;

/**
 * the listener of scanner
 * @author kai.l@verifone.cn
 */
interface ScannerListener {
	/**
     * Scan code successfully
     *
	 * @param barcode the barcode string
     * @since 1.x.x
	 */
    void onSuccess(String barcode);
    
    /**
     * Scan code error
     *
     * @param error the error code  1-scan failed
     * @param message the message of the error
     * @since 1.x.x
     */
    void onError(int error, String message);
    
	/**
     * Scan timeout
     * @since 1.x.x
	 */
    void onTimeout();
    
    /**
     * Scan cancel
     * @since 1.x.x
     */
    void onCancel();
}

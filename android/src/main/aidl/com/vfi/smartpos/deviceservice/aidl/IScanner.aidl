package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.ScannerListener;

/**
 * <p>the object of scanner for scanning the bar-code or QR-code
 *
 * @author: kai.l@verifone.cn
 */
interface IScanner {
	/**
     * <p>start scan
     *
	 * @param param
     *  <BR>topTitleString(String) the title string on the top, align center.
     *  <BR>upPromptString(String) the prompt string upside of the scan box, align center.
     *  <BR>downPromptString(String) the prompt string downside of the scan box , align center.
	 *  <BR>showScannerBorder(boolean, true is default) false for: scanner border & upPromptString &downPromptString will be hided,
	 *  <BR>scannerSelect(int) 0 for front, 1 for rear(if not set this paramater, use IDeviceService.getScanner() to set front/rear position)
	 *  <BR>useMaxResolution(boolean, true is default) true - max resolution; false - middle resolution
	 *  <BR>startPreView(boolean, true is default) true - start preview when start scanner; false - close preview
	 *  <BR>decodeLibName(String) call honeywell scan and config honeywell scan.
	 *      <ul>
	 *      <li>if decodeLibName starts wtith "honeywell;", follows with the string value of Symbology class properties.</li>
	 *      <li>if decodeLibName has multiple properties, split ";" between the properties.</li>
	 *      for example, "honeywell;436297729;436289537". "436297729" refers to the Symbology.CODE39, "436289537" refers to the Symbology.CODE128.
	 *      CODE39:436297729, CODE128:436289537, QR:436379649, OCR:436391937, Interleaved 2 of 5:436310017, etc.
	 *      <li>if you want to set honeywell passport properties, you need to send "honeywell;436391937;453169155" configuration parameter.</li>
	 *      </ul>
	 *      <BR><b>Note that: the honeywell scanner is not free of charge, please contact local Verifone business staff for details</b>

	 * @param timeout  the timeout, millsecond.
	 * @param  listener {@link ScannerListener}the call back listerner
	 * @since 1.x.x
	 *
	 */
	void startScan(in Bundle param, long timeout, ScannerListener listener);
	
	/**
     * <p>stop scan
     *
	 * @since 1.x.x
	 */
	void stopScan();

    /**
     * <p>Custom UI by customers
     * @param param
            <Br>customUI(boolean) default value is false
     *      <Br>x1(int) vertex coordinates x1, default is 0
     *      <Br>y1(int) vertex coordinates y1, default is 0
     *      <Br>width(int) if customUI is true, default is full screen
     *      <Br>height(int) if customUI is true, default is full screen
     * @throws RemoteException
     * @since after 2.21.0
     */
	void scannerInit(in Bundle param);

    /**
     * <p>open/close flash
     * @param enable open/close flash
     * @throws RemoteException
     * @since after 2.21.0
     */
	void openFlashLight(boolean enable);

    /**
     * <p>switch scanner front/rear camera
     * @throws RemoteException
     * @since after 2.21.0
     */
	void switchScanner();

    /**
     * check honeywell key exist or not.
     * @return true-honeywell key is activitied; false- not exist or not yet activitied
     * @throws RemoteException
     */
    boolean checkHoneywellLicense();

    /**
     *
     * @param content
     * @param size, suggest range size 50 ~ 384 (0 will be reset to 150)
     * @param barcodeFormatType
     * @return
     * @throws RemoteException
     * public enum BarcodeFormat {
     *     AZTEC,
     *     CODABAR,
     *     CODE_39,
     *     CODE_93,
     *     CODE_128,
     *     DATA_MATRIX,
     *     EAN_8,
     *     EAN_13,
     *     ITF,
     *     MAXICODE,
     *     PDF_417,
     *     QR_CODE,
     *     RSS_14,
     *     RSS_EXPANDED,
     *     UPC_A,
     *     UPC_E,
     *     UPC_EAN_EXTENSION;
     * }
     */
    Bitmap create1D2DcodeImage(String content, int size, int barcodeFormatType);

    /**
     * @param deviceSn: V9* or V1*
     * @param data format: yyyy-MM-dd
     * @return true-save file successfully; false-Failed to save file
     */
    boolean injectHoneywellLicence(String licenseSn, String deviceSn, String data);
}
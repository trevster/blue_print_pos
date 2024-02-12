package com.vfi.smartpos.deviceservice.aidl;
import com.vfi.smartpos.deviceservice.aidl.TusnData;

/**
 * <p> get device information, including software and hardware information.
 */
interface IDeviceInfo {

    /**
     * <p> get the serial number(SN) of the terminal.
     * @return {@code String}
     * @since 1.x.x
     */
    String getSerialNo();

    /**
     * <p> get the IMSI of the terminal.
     * @return {@code String}
     * @since 1.x.x
     */
    String getIMSI();

    /**
     * <p> get the IMEI of the terminal.
     * @return {@code String}
     * @since 1.x.x
     */
    String getIMEI();

    /**
     * <p> get the ICCID of the SIM card which present.
     * @return {@code String}
     * @since 1.x.x
     */
    String getICCID();

    /**
     * <p> get name of manufacture
     * @return {@code String}
     * @since 1.x.x
     */
    String getManufacture();

    /**
     * <p> get model of the terminal
     * @return {@code String}
     * @since 1.x.x
     */
    String getModel();

    /**
     * <p> get the version of the Android OS.
     * @return {@code String}
     * @since 1.x.x
     */
    String getAndroidOSVersion();

    /**
     * <p> get the version of Android Kernel
     * @return {@code String}
     * @since 1.x.x
     */
    String getAndroidKernelVersion();

    /**
     * <p> get the ROM version of Android.
     * @return {@code String}
     * @since 1.x.x
     */
    String getROMVersion();

    /**
     * <p> get the firmare version of the terminal.
     * @return {@code String}
     * @since 1.x.x
     */
    String getFirmwareVersion();

    /**
     * <p> get the hardware version
     * @return {@code String}
     * @since 1.x.x
     */
    String getHardwareVersion();

    /**
     * <p> update the system time with setting
     *
     * @param yyyyMMdd passing data param, data format is yyyyMMdd.
     * @param HHmmss passing time param, time format is HHmmss.
     * @return true:update system time success; false:update system time fail;
     * @since 1.x.x
     */
    boolean updateSystemTime(String yyyyMMdd, String HHmmss);

    /**
     * <p> set system function by bundle param.
     * Note: INSTALLERAUTOSTART function need ROM support. ROM begin to support from version V1.1.202111150949 INTLv7
     * <p><pre>{@code
     *      Bundle bundle = new Bundle();
     *      bundle.putBoolean("HOMEKEY", true);
     *      bundle.putBoolean("STATUSBARKEY", true);
     * }
     * </pre>
     * @param bundle
     * <ul>
     *     <li>key: HOMEKEY {@code String}; value: true/false @{@code boolean}; true;enable Home-Key, false:disable Home-Key</li>
     *     <li>key: STATUSBARKEY {@code String}; value: true/false @{@code boolean}; true;enable Status-Bar, false:disable Status-Bar</li>
     *     <li>key: INSTALLERAUTOSTART{@code String}; value: true/false @{@code boolean}; true(default) - usbInstaller app run automatically when OTG is connected, false - on the contrary</li>
     * </ul>
     * @return true:set system function success; false:set system function fail;
     * @since 1.x.x
     *
     */
    boolean setSystemFunction(in Bundle bundle);

    /**
     * <p> get the terminal UnionPay serial number.
     *
     * @param mode, passing 0
     * @param input, passing random number for calculating the Mac value of terminal UnionPay serial number. byte array length is between 4 and 10 byte.
     * @return null if fail.
     * @deprecated
     * @since 1.x.x
     */
    TusnData getTUSN(int mode, in byte[] input);

    /**
     * <p> get the PN of the terminal.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getPN();

    /**
     * <p> set power key disable or enable
     *
     * @param status true - disable the power key, false - enable the power key
     * @return {@code String}
     * @since 1.x.x
     */
    void setPowerStatus(boolean status);

    /**
     * <p> get the Total RAM. Unit is byte
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getRamTotal();

    /**
     * <p> get the available RAM capacity. Unit is byte.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getRamAvailable();

    /**
     * <p> get the flash RAM capacity. Unit is byte.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getRomTotal();

    /**
     * <p> get the available flash RAM capacity. Unit is byte.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getRomAvailable();

    /**
     * <p> get the mobile data usage total amount. Unit is byte.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getMobileDataUsageTotal();

    /**
     * <p> get the boot count.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getBootCounts();

    /**
     * <p> get the print paper length. Unit is millimeter.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getPrintPaperLen();

    /**
     * <p> get the times of magnetic card used.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getMagCardUsedTimes();

    /**
     * <p> get the times of smart card used.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getSmartCardUsedTimes();

    /**
     * <p> get the times of CTLS card used.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getCTLSCardUsedTimes();

    /**
     * <p> get the Battery Temperaturd.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getBatteryTemperature();

    /**
     * <p> get the Battery level.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getBatteryLevel();

    /**
     * <p> get the k21 version.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getK21Version();

    /**
     * <p> get the MEID info.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getMEID();

    /**
     * <p> get the tampler code.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getTamperCode();

    /**
     * <p> get the X990 Service Version.
     *
     * @return {@code String}
     * @since 1.x.x
     */
    String getServiceVersion();

    /**
     * <p> Get Kernel version.
     *
     * @return {@code android.os.Bundle}
     * <p> The return Bundle object key: <ul>
     *    <li> @{Code String} SmartEMV</li>
     *    <li> @{Code String} Visa</li>
     *    <li> @{Code String} MasterCard</li>
     *    <li> @{Code String} JCB</li>
     *    <li> @{Code String} AMEX</li>
     *    <li> @{Code String} Discover</li>
     *    <li> @{Code String} QuickPass</li>
     *    <li> @{Code String} GemaltoPure</li>
     *    <li> @{Code String} RuPay</li>
     *    <li> @{Code String} Mir</li>

     *    <li> @{Code String} SmartEMV_Checksum</li>
     *    <li> @{Code String} Visa_Checksum</li>
     *    <li> @{Code String} MasterCard_Checksum</li>
     *    <li> @{Code String} JCB_Checksum</li>
     *    <li> @{Code String} AMEX_Checksum</li>
     *    <li> @{Code String} Discover_Checksum</li>
     *    <li> @{Code String} QuickPass_Checksum</li>
     *    <li> @{Code String} GemaltoPure_Checksum</li>
     *    <li> @{Code String} RuPay_Checksum</li>
     *    <li> @{Code String} Mir_Checksum</li>
     *
     *    <li style="text-decoration:line-through;"> @{Code String} SmartEMV_Checksum_0_0_1_1</li>
     *    <li style="text-decoration:line-through;"> @{Code String} Visa_Checksum_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} MasterCard_Checksum_0_0_1_1</li>
     *    <li style="text-decoration:line-through;"> @{Code String} JCB_Checksum_0_0_2_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} AMEX_Checksum_0_0_2_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} Discover_Checksum_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} QuickPass_Checksum_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} GemaltoPure_Checksum_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} RuPay_Checksum_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} Mir_Checksum_0_0_1_0</li>
     *
     *    <li style="text-decoration:line-through;"> @{Code String} SmartEMV_Expiration_0_0_1_1</li>
     *    <li style="text-decoration:line-through;"> @{Code String} Visa_Expiration_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} MasterCard_Expiration_0_0_1_1</li>
     *    <li style="text-decoration:line-through;"> @{Code String} JCB_Expiration_0_0_2_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} AMEX_Expiration_0_0_2_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} Discover_Expiration_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} QuickPass_Expiration_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} GemaltoPure_Expiration_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} RuPay_Expiration_0_0_1_0</li>
     *    <li style="text-decoration:line-through;"> @{Code String} Mir_Expiration_0_0_1_0</li>
     * </ul>
     * <p><pre>{@code
     *     String smartEMV = bundle.getString("SmartEMV");
     *     String visa = bundle.getString("Visa");
     *     String masterCard = bundle.getString("MasterCard");
     *     String jcb = bundle.getString("JCB");
     *     String amex = bundle.getString("AMEX");
     *     String discover = bundle.getString("Discover");
     *     String quickPass = bundle.getString("QuickPass");
     *     String gemaltoPure = bundle.getString("GemaltoPure");
     * }
     * </pre>
     * @since 1.x.x
     */
    Bundle getKernelVersion();

    /**
     * <p> Get certificate.
     * @param mode 0 : sponsor digest; others : not support.
     * @return {@code String} if param is 0, return sponsor digest certificate. Otherwise, retuen "";
     * @since 1.x.x
     */
    String getCertificate(int mode);

    /**
     * <p> Get Battery charging times.
     * @return {@code String}
     * @since 1.x.x
     */
    String getBatteryChargingTimes();

     /**
     * <p> get device status
     * @param {@link android.os.Bundle}
     * <p><pre>{@code
     *      Bundle bundle = new Bundle();
     *      bundle.putString("DeviceType", "PRINTER");
     * }
     * </pre>
     * <p>the values of DeviceType:
     * <ul>
     *   <li>@{code String}"PRINTER"</li>
     *   <li>@{code String}"ICCARDREADER_SLOT1"</li>
     *   <li>@{code String}"ICCARDREADER_SLOT2"</li>
     *   <li>@{code String}"RFCARDREADER"</li>
     *   <li>@{code String}"SAMCARDREADER_SLOT1"</li>
     *   <li>@{code String}"SAMCARDREADER_SLOT2"</li>
     *   <li>@{code String}"PINPAD"</li>
     *   <li>@{code String}"CAMERA_FRONT"</li>
     *   <li>@{code String}"CAMERA_REAR"</li>
     *   <li>@{code String}"SDCARD"</li>
     * </ul>
     * @return 0:normal; -1:abnormal.
     * @since 1.x.x
     */
     int getDeviceStatus(in Bundle bundle);

    /**
     * <p> get button battery voltage
     * @return value of voltage
     * @since 1.x.x
     */
     String getButtonBatteryVol();

    /**
     * get information of device
     * @return - the key of bundle :
     * <ul>
     *   <li>{code String}SN (description:Serial No)</li>
     *   <li>{code String}PN (description:Product No)</li>
     *   <li>{code String}IMSI</li>
     *   <li>{code String}IMEI (description:International Mobile Equipment Identity)</li>
     *   <li>{code String}MEID (description:Mobile Equipment Identifier)</li>
     *   <li>{code String}manufacture (description:get manufacture message)</li>
     *   <li>{code String}deviceModel (description:get device model)</li>
     *   <li>{code String}androidOsVer (description:get android OS version)</li>
     *   <li>{code String}androidKernalVer (description:get android kernel version)</li>
     *   <li>{code String}romVer (description:get rom version)</li>
     *   <li>{code String}firmwareVer (description:get firmware version)</li>
     *   <li>{code String}hardwareVer (description:get hardware version)</li>
     *   <li>{code String}SPVer (description:get SP version)</li>
     *   <li>{code String}VFSerivceVer (description:get VFService version)</li>
     *   <li>{code String}VRKSn (description:get VRK sn)</li>
     *   <li>{code String}SponsorID (description:get sponsor id)</li>
     * </ul>
     * @since 1.x.x
     */
    Bundle getDeviceInfo();


    /**
     * Get information of device
     * @param getDevInfos - key is device info that you want to get, value is extension conditions(normally is "")
     * key include:
     * <ul>
     *      <li>{code String}SN (description:Serial No)</li>
     *      <li>{code String}PN (description:Product No)</li>
     *      <li>{code String}IMSI</li>
     *      <li>{code String}IMEI (description:International Mobile Equipment Identity)</li>
     *      <li>{code String}MEID (description:Mobile Equipment Identifier)</li>
     *      <li>{code String}manufacture (description:get manufacture message)</li>
     *      <li>{code String}deviceModel (description:get device model)</li>
     *      <li>{code String}androidOsVer (description:get android OS version)</li>
     *      <li>{code String}androidKernalVer (description:get android kernel version)</li>
     *      <li>{code String}romVer (description:get rom version)</li>
     *      <li>{code String}firmwareVer (description:get firmware version)</li>
     *      <li>{code String}hardwareVer (description:get hardware version)</li>
     *      <li>{code String}SPVer (description:get SP version)</li>
     *      <li>{code String}VFSerivceVer (description:get VFService version)</li>
     *      <li>{code String}VRKSn (description:get VRK sn)</li>
     *      <li>{code String}SponsorID (description:get sponsor HashValue)</li>
     *      <li>{code String}SponsorName (description:get sponsor Name)</li>
     *      <li>{code String}bootVer(description:get Boot version)</li>
     *      <li>{code String}IMEIS (iemi list for dual sim,return type is StringArray)</li>
     *      <li>{code String}IMSIS (imsi list for dual sim,return type is StringArray)</li>
     *      <li>{code String}ICCIDS (iccid list for dual sim,return type is StringArray)</li>
     * </ul>
     * @return bundle - return info which you search by key input getDevInfos
     * @throws RemoteException
     * @since 3.11.1
     */
    Bundle getDeviceInfoEx(in Bundle extrend);
}

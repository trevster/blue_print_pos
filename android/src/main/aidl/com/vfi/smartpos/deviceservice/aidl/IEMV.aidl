// IEMV.aidl
package com.vfi.smartpos.deviceservice.aidl;
import com.vfi.smartpos.deviceservice.aidl.CheckCardListener;
import com.vfi.smartpos.deviceservice.aidl.UPCardListener;
import com.vfi.smartpos.deviceservice.aidl.EMVHandler;
import com.vfi.smartpos.deviceservice.aidl.OnlineResultHandler;
import com.vfi.smartpos.deviceservice.aidl.CandidateAppInfo;
import com.vfi.smartpos.deviceservice.aidl.DRLData;
import com.vfi.smartpos.deviceservice.aidl.BLKData;
import com.vfi.smartpos.deviceservice.aidl.IssuerUpdateHandler;
import com.vfi.smartpos.deviceservice.aidl.EMVTransParams;
import com.vfi.smartpos.deviceservice.aidl.RequestACTypeHandler;
import com.vfi.smartpos.deviceservice.aidl.FinalAppSelectHandler;

/**
 * EMV object for processing EMV
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface IEMV {
    /**
     * check card, non-block method
     *
     * @param cardOption the card type (list)
     * <ul>
     * <li>supportMagCard(boolean) support magnetic card</li>
     * <li>supportSmartCard(boolean) support Smart card</li>
     * <li>supportCTLSCard(boolean) support CTLS card</li>
     * </ul>
     * @param timeout the time out(seconds)
     * @param listener the listerner while found card
	 * @since 2.x.x
     */
	void checkCard(in Bundle cardOption, int timeout, CheckCardListener listener);

    /**
     * stop check card
	 * @since 2.x.x
     */
	void stopCheckCard();

    /**
     * start EMV process
     *
     * @param transflow processing type
     * <ul>
     * <li>1：EMV processing</li>
     * <li>2：EMV simplified processing</li>
     * </ul>
     * @param intent request setting
     * <ul>
     * <li>cardType(int): card type
     *      * CARD_INSERT(0)- smart IC card
     *      * CARD_RF(1)- CTLS card </li>
     * <li>transProcessCode(byte): (1Byte) Translation type (9C first two digits of the ISO 8583:1987 Processing Code)</li>
     * <li>authAmount(long): auth-amount (transaction amount)</li>
     * <li>isSupportSM(boolean): is support SM </li>
     * <li>isForceOnline(boolean): is force online </li>
     * <li>merchantName(String):merchant Name (var. bytes)</li>
     * <li>merchantId(String): merchant ID (15 bytes)</li>
     * <li>terminalId(String):terminal ID (8 bytes)</li>
     * <li>transCurrCode(String): currency code(5F2A), if not set, kernel will find the tag in AID string.</li>
     * <li>otherAmount(String): set Other Amount (9F03) value</li>
     * <li>panConfirmTimeOut(int): set timeout of pan confirm, if not set then default 60s(just support smart card)</li>
     * <li>appSelectTimeOut(int): set timeout of selectApp, if not set then default 60s(just support smart card)</li>
     * <li>traceNo(String):trace no (var. bytes)</li>
     * <li>ctlsPriority(byte): CTLS application priority, no necessary, b0-MCCS MyDebit priorty b1-terminal priorty b2~b7 to be define</li>
     * <li>isForceOffline(boolean): is force offline, no necessary, false is default (just support AMEX kernel)</li>
     * <li>ctlsAidsForSingleTrans(ArrayList<String>): CTLS transaction input temporary aid params(AID + KernelID(9F2A01xx) + transType(DF2901xx) + transCurrCode(DF2A02xxxx))</li>
     * <li>isTerminalTypeSetInAID(boolean): default value is false(default vaule is 0x22), you should confirm this tag(9F35) in your AID String when you set this tag is true.</li>
     * <li>ctlsEmvAbortWhenAppBlocked(boolean): when CTLS app blocked then EMV abort</li>
     * <li>paramsGroupName(String): aid/rid/DRL group name</li>
     * <li>merchCateCode(String): set Merchant Category code for each EMV process, default value is 1234</li>
     * <li>isStartVccsFlag(boolean): set this param true(default is false), meanwhile DF2F tag in AID string B1b6 is 1, then open padding 00 rule to change 9F02</li>
     * <li>pureKernelDisable_AC_ECHO(boolean): pure kernel close AC_ECHO TTPI B3b2 (default is false)</li>
     * <li>pureKernelDisable_AC_OfflineCAM(boolean): pure kernel close AC_OfflineCAM TTPI B2b4 (default is false)</li>
     * <li>enableFinalAppSelectCallback(boolean): add a callback function before GPO(default is false)</li>
     * </ul>
     * @param handler the call back handler, please refer EMVHandler
	 * @since 2.x.x
     */
	void startEMV(int processType, in Bundle intent, EMVHandler handler);

    /**
     * stop EMV
     *
	 * @since 2.x.x
     * */
	void abortEMV();

    /**
     * update AID parameter
     *
     * @param operation the setting
     * <ul>
     * <li>1：append</li>
     * <li>2：remove</li>
     * <li>3：clear all</li>
     * </ul>
     * @param aidType type of AID parameter
     * <ul>
     * <li>1：contact(smart card)</li>
     * <li>2：contactless</li>
     * </ul>
     * @param aid the AID parameter
     * @return result, true on success, false on failure
	 * @since 2.x.x
     */
    boolean updateAID(int operation,int aidType, String aid);

    /**
     * update CA public KEY
     *
     * @param operation the setting
     * <ul>
     * <li>1：append</li>
     * <li>2：remove</li>
     * <li>3：clear all</li>
     * </ul>
     * @param rid the CA public KEY
     * @return true on success, false on failure
	 * @since 2.x.x
     */
    boolean updateRID(int operation, String rid);

    /**
     * import amount
     *
     * There is nothing in this method. The amount should be set while call the startEMV.
     * @param amount the amount
	 * @since 2.x.x
     * @deprecated
     */
    void importAmount(long amount);

    /**
     * select application (multi-application card)
     *
     * @param index the index of application, start from 1, and 0 means cancel
	 * @since 2.x.x
     */
    void importAppSelection(int index);

    /**
     * import the PIN
     *
     * @param option(int) - the option
     * <ul>
     * <li> CANCEL(0) cancel</li>
     * <li> CONFIRM(1) confirm</li>
     * </ul>
     * @param pin the PIN data
	 * @since 2.x.x
     */
    void importPin(int option, in byte[] pin);

    /**
     * import the result of card hodler verification
     *
     * @param option the option
     * <ul>
     * <li> CANCEL(0) cancel ( BYPASS )</li>
     * <li> CONFIRM(1) confirm</li>
     * <li> NOTMATCH(2) not match</li>
     * </ul>
	 * @since 2.x.x
     */
    void importCertConfirmResult(int option);

    /**
     * import the result of card verification
     *
     * @param pass true on pass, false on error
	 * @since 2.x.x
     */
    void importCardConfirmResult(boolean pass);


    /**
     * input the online response
     *
     * @param onlineResult  set the result ( response )
     * <ul>
     * <li> isOnline(boolean)is online</li>
     * <li> respCode(String) the response code</li>
     * <li> authCode(String) the authorize code</li>
     * <li> field55(String) the response of field 55 data form HOST(include ARPC or script)</li>
     * </ul>
     * @param handler the result , please refer OnlineResultHandler
	 * @since 2.x.x
     */
    void importOnlineResult(in Bundle onlineResult, OnlineResultHandler handler);

    /**
     * set EMV (kernel) data in trans process (DCC)
     *
     * In emv flow(onConfirmCardInfo callback or onRequestInputPIN callback), you can modify the emv data. <b>just support smartcard</b><br>
     * for example:<br>
     * 1.firt you set aidString 5F2A=0156, but in onConfirmCardInfo callback you want to reset this tag 5F2A=0116, you can use this interface.<br>
     * 2.second you set authAmount=100(9F02) in startEmv, in onConfirmCardInfo callback you can reset the auth amount.
     * @param tlvList the TLV list
	 * @since 2.x.x
     */
    void setEMVData(in List<String> tlvList);

    /**
     * get kernal data list in Tag-Length-Value format
     *
	 * @param taglist the tag list want query
	 * @return the response in TLV format, null means no response got
	 * @since 2.x.x
	 * <pre>
     * {
     *     String[] strlist = {"9F33", "9F40", "9F10", "9F26", "95", "9F37", "9F1E", "9F36",
     *             "82", "9F1A", "9A", "9B", "50", "84", "5F2A", "8F"};
     *     String strs = iemv.getAppTLVList(strlist);
     *  }
	 * </pre>
	 */
	String getAppTLVList(in String[] taglist);

    /**
     * get card (emv) data by tag
     *
	 * @param tagName the tag name
	 * @return the emv data got
	 * @since 2.x.x
	 */
	byte[] getCardData(String tagName);

	/**
     * get EMV data
     *
     * such as card number, valid dtae, card serial number, etc.
     * <em> will return null if the data is not avalible at the current EMV process</em>
	 * @param tagName tag name
	 * <ul>
     * <li> PAN card No.</li>
     * <li> TRACK2 track No.2</li>
     * <li> CARD_SN card SN (Serial Number)</li>
     * <li> EXPIRED_DATE expried date</li>
     * <li> DATE date</li>
     * <li> TIME time</li>
     * <li> BALANCE balance</li>
     * <li> CURRENCY currency</li>
     * </ul>
	 * @return the return data of EMV
	 * @since 2.x.x
	 */
	String getEMVData(String tagName);

    /**
     * get the AID parameter
     *
	 * @param type - 1-contact aid  2-contactless aid
     * @return null if the AID is unavailable
	 * @since 2.x.x
     */
	String[] getAID(int type);

    /**
     * get the RID
     * @return null if the RID is unavailable<br>
	 * @since 2.x.x
     * @deprecated
     */
	String[] getRID();

	/**
     * Obtain the CTLS card type
	 * @return see below:
	 * <pre>
	 *   0-No Type
	 *   1-JCB_CHIP
	 *   2-JCB_MSD
	 *   3-JCB_Legcy
	 *   4-VISA_w1
	 *   5-VISA_w3
	 *   6-Master_EMV
	 *   7-Master_MSD
	 *   8-qPBOC_qUICS
	 * </pre>
	 * @since 2.x.x
     * @deprecated
	*/
	int getProcessCardType();

	/**
     * set EMV kernel to use. set this interface before startEMV()
	 * @param customAidList see below:
	 * <pre>
	 * Map < String, Integer >
	 * String - custom aid
	 * Integer - kernelID(check CTLSKernelID)
	 * </pre>
	 * @since 2.x.x
	 */
	void registerKernelAID(in Map customAidList);

    /**
     * import(input) the online response
     *
     * @param onlineResult - the result ( response )
     * <ul>
     * <li> isOnline(boolean)is online</li>
     * <li> respCode(String) the response code(00-approval)</li>
     * <li> authCode(String) the authorize code</li>
     * <li> field55(String) the response of field 55 data</li>
     * </ul>
     * @param handler the result , please refer OnlineResultHandler
	 * @since 2.x.x
     */
    void inputOnlineResult(in Bundle onlineResult, OnlineResultHandler handler);

    /**
     * update CTLS Visa APID or AMEX DRL parameter
     *
     * @param operation the setting
     * <ul>
     * <li>1：append</li>
     * <li>2：clear</li>
     * </ul>
     * @param DRLData data
     * @return result, true on success, false on failure
	 * @since 2.x.x
     */
    boolean updateVisaAPID(int operation, in DRLData drlData);

    /**
     * update card black parameter
     *
     * @param operation the setting
     * <ul>
     * <li>1：append</li>
     * <li>2：clear</li>
     * </ul>
     * @param BLKData data of card black
     * @param type of card black parameter
     * <ul>
     * <li>1：contact(smart card)</li>
     * <li>2：contactless</li>
     * </ul>
     * @return result, true on success, false on failure
	 * @since 2.x.x
     */
    boolean updateCardBlk(int operation, in BLKData blkData, int type);

    /**
     * set smart card request online after Application Selection and before GAC,
     * it can set TVR B4b4(Merchant forced transaction online) is true.
     *
     * @return result, 0 on success, others on failure
	 * @since 2.x.x
     */
    int emvProcessingRequestOnline();

    /**
     * get the CAPK parameter
     *
	 * @param type - 1-contact aid  2-contactless aid
     * @return null if the CAPK is unavailable
     * @since 2.7.0.0
     */
	String[] getCAPK(int type);

    /**
     * enable Track(It's not necessary.)
	 * @param trkNum - bit0=1 enable trk1; bit1=1 enable trk2; bit2=1 enable trk3. If trkNum < 0 or trkNum > 7 the previous settings will be maintained
     * @since 2.7.0.0
     */
	void enableTrack(int trkNum);

    /**
     * set ctls pre process(It's not necessary.)
     * @param param setting
     * <ul>
     * <li>traceNo(String):trace no (var. bytes)</li>
     * <li>transProcessCode(byte): (1Byte) Translation type (9C first two digits of the ISO 8583:1987 Processing Code)</li>
     * <li>transCurrCode(String): currency code(5F2A), if not set, kernel will find the tag in AID string.</li>
     * <li>otherAmount(String): set Other Amount (9F03) value</li>
     * <li>authAmount(long): auth-amount (transaction amount)</li>
     * <li>isForceOnline(boolean): is force online </li>
     * <li>ctlsPriority(byte): CTLS application priority, no necessary, b0-MyDebit b1~b7 to be define</li>
     * <li>isForceOffline(boolean): is force offline, no necessary, false is default</li>
     * </ul>
     * @return true-sucess false-failed
     * @since 2.11.0.0
     */
	boolean setCtlsPreProcess(in Bundle param);

    /**
     * check card, non-block method
     *
     * @param cardOption the card type (list)
     * <ul>
     * <li>supportMagCard(boolean) support magnetic card</li>
     * <li>supportSmartCard(boolean) support Smart card</li>
     * <li>supportCTLSCard(boolean) support CTLS card</li>
     * </ul>
     * @param timeout the time out(ms)
     * @param listener the listerner while found card
     * @since 2.11.0.0
     */
	void checkCardMs(in Bundle cardOption, long timeout, CheckCardListener listener);

    /**
     * set before startEMV(), set callback for request issuer update script(CTLS request second tap)
     * @since 2.11.0.0
     */
    void setIssuerUpdateHandler(in IssuerUpdateHandler issuerUpdateHandler);

    /**
     * After CTLS second tap to update script
     * @since 2.11.0.0
     */
	void setIssuerUpdateScript();

    /**
    * start EMV process
    * @param EMVTransParam @see EMVTransParams.java
    * @param extend
    * <ul>
    *    <li>panConfirmTimeOut(int): set timeout of pan confirm, if not set then default 60s(just support smart card)</li>
    *    <li>appSelectTimeOut(int): set timeout of selectApp, if not set then default 60s(just support smart card)</li>
    *    <li>ctlsPriority(byte): CTLS application priority, no necessary, b0-MCCS MyDebit priority b1-terminal priority,use DF2D to custom set priority b2~b7 to be define</li>
    *    <li>isForceOffline(boolean): is force offline, no necessary, false is default (just support CTLS AMEX kernel)</li>
    *    <li>ctlsAidsForSingleTrans(ArrayList<String>): CTLS transaction input temporary aid params(AID + KernelID(9F2A01xx) + transType(DF2901xx) + transCurrCode(DF2A02xxxx))</li>
    *    <li>isTerminalTypeSetInAID(boolean): default value is false(default vaule is 0x22), you should confirm this tag(9F35) in your AID String when you set this tag is true.</li>
    *    <li>merchCateCode(String): set Merchant Category code for each EMV process, default value is 1234</li>
    * </ul>
    * @param handler the call back handler, please refer EMVHandler
    * @since 2.11.0.0
    */
	void startEmvWithTransParams(in EMVTransParams emvParams, in Bundle extend, EMVHandler handler);


    /**
     * set before startEMV(), set RequestACTypeHandler callback.
     * @since 2.20.3.12
     */
	void setRequestACTypeCallBack(RequestACTypeHandler requestACTypehandler);

    /**
     * re-set 1GAC AC type
     * @param requestACType: chip card can change 1GAC AC Type(not necessary), 0-AAC, 1-ARQC, 2-TC
     * @since 2.20.3.12
     */
	void setRequestACType(int requestACType);


    /**
     * select spec version of kernel before startEMV(), pls refer CTLSKernelID
	 * @param kernelID:
	 * <pre>
	 * Map < Integer kernelID, Integer ver >
	 *      kernelId- kernelID(check CTLSKernelID) ver- Specification Version
	 *      kernelId:2(Master)  0 - 3.1 ver(default), 1 - 3.1.2 ver, 2 - 3.1.4 ver
	 *      kernelId:4(AMEX)  0 - 3.1 ver (default), 1 - 4.0.2 ver, 2 - 4.1.0 ver
	 *      kernelId:5(JCB)  0 - 1.3 ver(default), 1 - 1.4 ver, 2 - 1.5 ver
	 * </pre>
     * @since 2.20.3.12
     */
	void reRegistKernelVersion(in Map tlvList);

    /**
     * reset emvHandler in EMV process
     * @param EMVHandler please refer EMVHandler
     * @since 2.20.3.12
     */
	void resetEmvHandler(EMVHandler handler);

    /**
     * set bypass all PIN
     * @param byPassAllPin: default is false, if set true, will bypass all PIN
     * @since 2.23.0
     */
	void setByPassAllPin(boolean byPassAllPin);

    /**
     * get bypass all PIN status
	 * @return true - bypass all PIN, false - not bypass all PIN
     * @since 2.23.0
     */
	boolean isByPassAllPin();


    /**
     * update AID/CAPK/DRL parameter
     *
     * @param operation the setting
     * <ul>
     * <li>1：append</li>
     * <li>2：clear</li>
     * </ul>
     * @param paramType.
     * <ul>
     * <li>1：AID contact</li>
     * <li>2：AID contactless</li>
     * <li>3：RID/CAPK</li>
     * <li>4：DRL</li>
     * </ul>
     * @param params the AID/RID/CAPK parameter value, if DRL type, set NULL.
    * @param extend
    * <ul>
    *    <li>groupName(String): group name</li>
    *    <li>DRLData(Parcelable): input DRLData object if paramType is 4</li>
    * </ul>
     * @return result, true on success, false on failure
     * @since 3.6.3
     */
    boolean updateGroupParam(int operation,int paramType, String params, in Bundle extend);

    /**
     * obtain card issuer CTLS specification version.
     * @return Map - Spec version of all CTLS kernels
     * <pre>{@code
      Map <String kernel, String SpecVer>
           kernel: AMEX; MASTER; JCB; VISA; DISCOVER; CUP; RUPAY; PURE; MIR
      }</pre>
     * @since 3.10.x
     */
    Map getCtlsSpecVer();


    /**
     * same as updateVisaAPID() interface
     *
     * @since 3.11.x
     */
    boolean updateDRL(int operation, in DRLData drlData);

    /**
     * check AID and CAPK file valid or not, this file via updateAID/RID to create
     * @param fileType 0-AID 1-CAPK
     * @return
     * @since 3.11.2
     */
    boolean checkFileValidity(int fileType);

    /**
     * set a callback before GPO, need to set before EMV process.
     * @since 3.12.0
     */
	void setFinalAppSelectCallBack(FinalAppSelectHandler finalAppSelectHandler);

    /**
     * import result for final app select handler
     *
     * @param pass true on pass, false on error
	 * @since 3.12.0
     */
    void importFinalAppSelect(boolean pass);
}

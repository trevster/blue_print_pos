package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.CheckCardListener;
import com.vfi.smartpos.deviceservice.aidl.UPCardListener;
import com.vfi.smartpos.deviceservice.aidl.PBOCHandler;
import com.vfi.smartpos.deviceservice.aidl.OnlineResultHandler;
import com.vfi.smartpos.deviceservice.aidl.CandidateAppInfo;

/**
 * PBOC(EMV) object for processing EMV
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface IPBOC {
    /**
     * check card, non-block method
     *
     * @param cardOption the card type (list)
     * <ul>
     * <li>supportMagCard(boolean) support magnetic card</li>
     * <li>supportICCard(boolean) support IC card</li>
     * <li>supportRFCard(boolean) support CTLS card</li>
     * </ul>
     * @param timeout the time out(seconds)
     * @param listener the listerner while found card
	 * @since 1.x.x
     */
	void checkCard(in Bundle cardOption, int timeout, CheckCardListener listener);
	
    /**
     * stop check card
	 * @since 1.x.x
     *
     */
	void stopCheckCard();
	
    /**
     * read UP ( chip in SIM ) card
     * @param listener the listern of the result
	 * @since 1.x.x
     */
    void readUPCard(UPCardListener listener);
	
    /**
     * start PBOC process
     *
     * @param transType transaction type
     * <ul>
     * <li>EC_BALANCE(1) query the balance</li>
     * <li>TRANSFER(2) transfer</li>
     * <li>EC_LOAD(3) EC LOAD</li>
     * <li>EC_LOAD_U(4) EC LOAD without assign account</li>
     * <li>EC_LOAD_CASH(5) EC LOAD with CASH</li>
     * <li>EC_LOAD_CASH_VOID(6) EC LOAD with CASH void</li>
     * <li>PURCHASE(7) purchase</li>
     * <li>Q_PURCHASE(8) quick purchase</li>
     * <li>CHECK_BALANCE(9) get balance</li>
     * <li>PRE_AUTH(10) pre-authorization</li>
     * <li>SALE_VOID(11) sale void</li>
     * <li>SIMPLE_PROCESS(12) simplye process</li>
     * <li>REFUND(13) - refund(full process)</li>
     * </ul>
     * @param intent request setting
     * <ul>
     * <li>cardType(int) card type
     *         * CARD_INSERT(0)- samrt IC card
     *         * CARD_RF(1)- CTLS card 非接触式卡 </li>
     * <li>authAmount(long): auth-amount (transaction amount) </li>
     * <li>isSupportQ(boolean): is support QPBOC </li>
     * <li>isSupportSM(boolean): is support SM </li>
     * <li>isQPBOCForceOnline(boolean): is QPBOC force online </li>
     * <li>merchantName(String):merchant Name </li>
     * <li>merchantId(String): merchant ID </li>
     * <li>terminalId(String):terminal ID </li>
     * </ul>
     * @param handler the call back handler, please refer PBOCHandler
	 * @since 1.x.x
     */
	void startPBOC(int transType, in Bundle intent, PBOCHandler handler);

    /**
     * start EMV process
     *
     * @param processType process type
     * <ul>
     * <li>1：full process</li>
     * <li>2：simple process</li>
     * </ul>
     * @param intent request setting
     * <ul>
     * <li>cardType(int): card type
     *      * CARD_INSERT(0)- smart IC card
     *      * CARD_RF(1)- CTLS card </li>
     * <li>transProcessCode(byte): (1Byte) Translation type (9C first two digits of the ISO 8583:1987 Processing Code)</li>
     * <li>authAmount(long): auth-amount (transaction amount)</li>
     * <li>isSupportQ(boolean): is support QPBOC </li>
     * <li>isSupportSM(boolean): is support SM </li>
     * <li>isQPBOCForceOnline(boolean): is QPBOC force online </li>
     * <li>merchantName(String):merchant Name </li>
     * <li>merchantId(String): merchant ID </li>
     * <li>terminalId(String):terminal ID </li>
     * </ul>
     * @param handler the call back handler, please refer PBOCHandler
	 * @since 1.x.x
     */
	void startEMV(int processType, in Bundle intent, PBOCHandler handler);
	
    /**
     * stop PBOC(EMV)
	 * @since 1.x.x
     *
     * */
	void abortPBOC();

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
	 * @since 1.x.x
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
	 * @since 1.x.x
     */
    boolean updateRID(int operation, String rid);
    
    /**
     * import amount
     *
     * There is nothing in this method. The amount should be set while call the startEMV.
     * @param amount the amount
	 * @since 1.x.x
     * @Deprecated
     */
    void importAmount(long amount);
	
    /**
     * select application (multi-application card)
     *
     * @param index the index of application, start from 1, and 0 means cancel
	 * @since 1.x.x
     */
    void importAppSelect(int index);
    
    /**
     * import the PIN
     *
     * @param option(int) - 操作选项 | the option
     * <ul>
     * <li> CANCEL(0) cancel</li>
     * <li> CONFIRM(1) confirm</li>
     * </ul>
     * @param pin the PIN data
	 * @since 1.x.x
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
	 * @since 1.x.x
     */
    void importCertConfirmResult(int option);
    
    /**
     * import the result of card verification
     *
     * @param pass true on pass, false on error
	 * @since 1.x.x
     */
    void importCardConfirmResult(boolean pass);
    
    
    /**
     * import(input) the online response
     *
     * @param onlineResult - the result ( response )
     * <ul>
     * <li> isOnline(boolean)is online</li>
     * <li> respCode(String) the response code</li>
     * <li> authCode(String) the authorize code</li>
     * <li> field55(String) the response of field 55 data</li>
     * </ul>
     * @param handler the result , please refer OnlineResultHandler
	 * @since 1.x.x
     */
    void inputOnlineResult(in Bundle onlineResult, OnlineResultHandler handler);

    /**
     * set EMV (kernel) data
     *
     * before start emv flow, you can set the data
     * @param tlvList the TLV list
     * Support set following tag. If AID list have the same tag, aid list priority over this interface.<BR>
     * <pre>
     * Such as below tag:
     * 9F33：
     * 9F15：
     * 9F16：
     * 9F4E：
     * 9F1C：
     * 9F35：
     * 9F3C：
     * 9F3D：
     * 5F2A：
     * 5F36：
     * 9F1A：
     * 9F40：
     * </pre>
	 * @since 1.x.x
     */
    void setEMVData(in List<String> tlvList);
    
    /**
     * get kernal data list in Tag-Length-Value format
     *
	 * @param taglist the tag list want query
	 * @return the response in TLV format, null means no response got
	 * @since 1.x.x
	 * <pre>
     * {
     *    String[] strlist = {"9F33", "9F40", "9F10", "9F26", "95", "9F37", "9F1E", "9F36",
     *            "82", "9F1A", "9A", "9B", "50", "84", "5F2A", "8F"};
     *    String strs = ipboc.getAppTLVList(strlist);
     * }
	 * </pre>
	 */
	String getAppTLVList(in String[] taglist);
	
    /**
     * get card (emv) data by tag
     *
	 * @param tagName the tag name
	 * @return the emv data got
	 * @since 1.x.x
	 */
	byte[] getCardData(String tagName);
	
	/**
     * get PBOC(EMV) data
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
	 * @return the return data of PBOC
	 * @since 1.x.x
	 */
	String getPBOCData(String tagName);
	
    /**
     * get the candidate application information
     *
	 * for upload the e-signature
	 * @return the application information, please refer CandidateAppInfo
	 * @since 1.x.x
	 */
	CandidateAppInfo getCandidateAppInfo();

    /**
     * get the AID parameter
     *
	 * @param type - 1-contact aid  2-contactless aid
     * @return null if the AID is unavailable
	 * @since 1.x.x
     */
	String[] getAID(int type);

    /**
     * get the RID
     *
     * @return null if the RID is unavailable
	 * @since 1.x.x
     */
	String[] getRID();

	/**
     * Obtain the CTLS card type(In onRequestOnlineProcess callback you can use this interface to obtain the CTLS card type)
	 * @return
	 *   0-No Type<BR>
	 *   1-JCB_CHIP<BR>
	 *   2-JCB_MSD<BR>
	 *   3-JCB_Legcy<BR>
	 *   4-VISA_w1<BR>
	 *   5-VISA_w3<BR>
	 *   6-Master_EMV<BR>
	 *   7-Master_MSD<BR>
	 *   8-qPBOC_qUICS<BR>
	 * @since 1.x.x
     * @deprecated
     */
	int getProcessCardType();
}

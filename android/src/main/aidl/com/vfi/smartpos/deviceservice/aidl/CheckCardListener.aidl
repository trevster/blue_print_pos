package com.vfi.smartpos.deviceservice.aidl;

/**
 * the listener of check card
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface CheckCardListener {
	/**
     * found magnetic card
     *
	 * @param track the track information
	 * <ul>
     * <li>PAN(String) the main / pan number</li>
     * <li>TRACK1(String) track 1 </li>
     * <li>TRACK2(String) track 2 </li>
     * <li>TRACK3(String) track 3 </li>
     * <li>SERVICE_CODE(String) service code </li>
     * <li>EXPIRED_DATE(String) the expired date </li>
	 * </ul>
     * @since 1.x.x
	 */
	void onCardSwiped(in Bundle track);
	
	/**
     * found smart card
     *
     * run the IPBOC#startEMV to start EMV workflow
     * @since 1.x.x
     *
	 */
	void onCardPowerUp();
	
	/**
     * found contactless card
     *
     * run the IPBOC#startEMV to start EMV workflow
     * @since 1.x.x
     *
	 */
	void onCardActivate();
	
	/**
     * timeout
     *
     * @since 1.x.x
	 */
	void onTimeout();
	
	/**
     * While error got
     *
	 * @param error the error code
	 * <ul>
	 * <li>SERVICE_CRASH(99) - service crash </li>
	 * <li>REQUEST_EXCEPTION(100) - request cause exception</li>
	 * <li>MAG_SWIPE_ERROR(1) - read magnetic error</li>
	 * <li>IC_INSERT_ERROR(2) - read smart card error</li>
	 * <li>IC_POWERUP_ERROR(3) - smart card cannot power up</li>
	 * <li>RF_PASS_ERROR(4) - read contactless card error</li>
	 * <li>RF_ACTIVATE_ERROR(5) - contactless card active error</li>
	 * <li>MULTI_CARD_CONFLICT_ERROR(6) - found multi-cards</li>
	 * <li>M1_CARD_UNSUPPORT_EMV_ERROR(7) - [M1Sn]M1 card unsupport in EMV process</li>
	 * <li>FELICA_CARD_UNSUPPORT_EMV_ERROR(8) - emv unsupport Felica card</li>
	 * <li>DESFIRE_CARD_UNSUPPORT_EMV_ERROR(9) -[DesFireSN] DesFire card unsupport in EMV process</li>
	 * <li>NTAG_CARD_UNSUPPORT_EMV_ERROR(10) -[NtagSN] Ntag card unsupport in EMV process</li>
	 * <li>ULTRALIGHT_CARD_UNSUPPORT_EMV_ERROR(11) -[UltralightSN] Ultralight card unsupport in EMV process</li>
	 * </ul>
	 * @param message the description.
     * @since 1.x.x
	 */
	void onError(int error, String message);
}

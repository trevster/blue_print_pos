package com.vfi.smartpos.deviceservice.aidl;

/**
 *  the object of smart card (contact card, or IC card)
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface IInsertCardReader {
	/**
     * power up the card
	 * @return true for success, false for failure
	 * @since 1.x.x
     *
	 */
	boolean powerUp();
	
	/**
     * power down the card
	 * @return true for success, false for failure
	 * @since 1.x.x
	 */
	boolean powerDown();
	
	/**
     * check if the card avalible
     *
	 * @return true for available, false for unavailable
	 * @since 1.x.x
	 */
	boolean isCardIn();
	
	/**
     * execute an apdu command
     *
	 * @param apdu apdu command input
	 * @return response of the command, null means no response got
	 * @since 1.x.x
	 */
	byte[] exchangeApdu(in byte[] apdu);

	/**
     * check if the PSAM card exist
	 * @since 1.x.x
     */
    boolean isPSAMCardExists();
}

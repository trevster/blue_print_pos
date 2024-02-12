// ISmartCardReader.aidl
package com.vfi.smartpos.deviceservice.aidl;
import com.vfi.smartpos.deviceservice.aidl.SmartCardStatusChangedEvent;

/**
 * the object of smart card (contact card, or IC card)
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface ISmartCardReader {
	/**
     * power up the card
     *
	 * @return true for success, false for failure
	 * @since 2.x.x
     *
	 */
	boolean powerUp();

	/**
     * power down the card
     *
	 * @return true for success, false for failure
	 * @since 2.x.x
	 *
	 */
	boolean powerDown();

	/**
     * check if the card exist
     *
	 * @return true for available, false for unavailable
	 * @since 2.x.x
	 */
	boolean isCardIn();

	/**
     * execute an apdu command
     *
	 * @param apdu apdu command input
	 * @return response of the command, null means no response got
	 * @since 2.x.x
	 */
	byte[] exchangeApdu(in byte[] apdu);

	/**
     * check if the PSAM card exist
	 * @since 2.x.x
     */
    boolean isPSAMCardExists();

	/**
     * check card status
	 * @return 0x00-card not exist, 0x01-card exist, 0x02-card power on
     * @since 2.5.0.1
     */
    byte checkCardStatus();

	/**
     * get ATR data of card power up
	 * @return ATR data
     * @since 2.5.2.4
     */
    byte[] getPowerUpATR();

	/**
     * power up the card
     * @param param the parameter
     * <ul>
     * <li>ATRCheck(boolean) enable/disable ATR check(default is enable)</li>
     * </ul>
	 * @return ATR data
     * @since 3.4.2.rc3
     */
    byte[] powerUpWithConfig(in Bundle param);

    /**
     *
     * @param timeout second, (1~120s)
     * @param callback
     * @throws RemoteException
     */
    void detectCardStatusChanged(int timeout, SmartCardStatusChangedEvent callback);
}

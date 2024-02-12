package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.RFSearchListener;

/**
 * the object of Contactless card, Mifare card, Memory card
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */

interface IRFCardReader {
	/**
     * search card
     *
	 * @param listener the call back listener.
	 * @param timeout timeout in second, should >= 1 sec
	 * @since 1.x.x
     * @see com.vfi.smartpos.deviceservice.aidl.RFSearchListener
	 */
	void searchCard(RFSearchListener listener, int timeout);
	
	/**
     * stop search
	 * @since 1.x.x
     *
	 */
	void stopSearch();
	
	/**
     * active the card
     *
	 * @param driver the driver name
	 * <ul>
     * <li style="text-decoration:line-through;">"S50" - S50(M1) card</li><BR>
     * <li style="text-decoration:line-through;">"S70" - S70(M1) card</li><BR>
     * <li>"CPU" - CUP card</li><BR>
     * <li>"PRO" - PRO、S5O_PRO、S70_PRO</li><BR>
	 * </ul>
	 * @param responseData - the response data from the card
	 * @return 0 for success, others means failure
	 * @since 1.x.x
     *
	 */
	int activate(String driver, out byte[] responseData);
	
	/**
     * same as stopSearch
	 * @since 1.x.x
	 */
	void halt();

	/**
     * check the card is present
	 * @return true while the card is exist, false while the card is not present
	 * @since 1.x.x
	 *
	 */
	boolean isExist();
	
	/**
     * exchange APDU command
     *
	 * @param apdu - the APDU
	 * @return the response APDU
	 * @since 1.x.x
     *
	 */
	byte[] exchangeApdu(in byte[] apdu);
	
	/**
     * reset the card
     *
	 * @return the response from the card
	 * @since 1.x.x
	 */
	byte[] cardReset();

	/**
     * author the block (with given block No.)
     *
	 * @param blockNo the block No.(index) start at 0
	 * @param keyType the key type, KEY_A(0) or KEY_B(1)
	 * @param key     the key, length: 6
	 * @return 0 means success, others while failure
	 * @since 1.x.x
	 *
	 */
	int authBlock(int blockNo, int keyType, in byte[] key);
	
    /**
     * author the sector ( with given sector No.)
     *
	 * @param sectorNo 	the sector No.(index) start at 0.
	 * @param keyType	the key type KEY_A(0) or KEY_B(1)
	 * @param key		the key, length: 6
	 * @return 0 means success, others while failure
	 * @since 1.x.x
     *
	 */
	int authSector(int sectorNo, int keyType, in byte[] key);
	
	/**
     * read a block
     *
	 * @param blockNo the block No.
	 * @param data the data from the block, length: 16
	 * @return 0 means success, others while failure
	 * @since 1.x.x
	 *
	 */
	int readBlock(int blockNo, out byte[] data);
	
	/**
     * write a block
     *
     * The length MUST be 16, others will cause error
	 * @param blockNo the block No.
	 * @param data the source data
	 * @return 0 means success, others while failure
	 * @since 1.x.x
	 *
	 */
	int writeBlock(int blockNo, in byte[] data);
	
	/**
     * increase value
     *
     * <p>increase the value on given block</p>
	 * @param blockNo the block No.
	 * @param value the value
	 * @return 0 means success, others while failure
	 * @since 1.x.x
	 *
	 */
	int increaseValue(int blockNo, int value);
	
	/**
     * decrease value
     *
	 * <p>decrease the value on given block</p>
	 * @param blockNo the block No.
	 * @param value the value
	 * @return 0 means success, others while failure
	 * @since 1.x.x
	 */
	int decreaseValue(int blockNo, int value);

	/**
     * get card info in RFSearchListener.onCardPass callback
     *
	 * @return bundle of cardInfo
     * <ul>
     *     <li>sn(ByteArray)</li>
     *     <li>ATQA(ByteArray) support A/B card and S50 & S70 for now</li>
     *     <li>SAK(ByteArray) support A/B card and S50 & S70 for now</li>
     *     <li>cardInfo(String) all the above card's informations</li>
     * </ul>
	 * @since 1.x.x
	 */
	Bundle getCardInfo();

	/**
     * restore blockNo
	 * @param blockNo the block No.
     *
	 * @return result 0x00-sucess; 0x01-blockNo error; 0x02-operate failed; 0xff-other error
	 * @since 1.x.x
	 */
	byte restore(byte blockNo);

	/**
     * transfer blockNo
	 * @param blockNo set block No.
     *
	 * @return result 0x00-sucess; 0x01-blockNo error; 0x02-operate failed; 0xff-other error
	 * @since 1.x.x
	 */
	byte transfer(byte blockNo);

	/**
     * Close Rf Field (doesn't work from version 3.X.X)
	 * @deprecated pls see stopSearch
	 */
	void CloseRfField();

    /**
     * call tranfer() automatically or not in API increase, decrease, restore
     *
     * @param isAutoTransfer, default is true is no set
     * @throws RemoteException
     */
	void autoTransfer(boolean isAutoTransfer);
}

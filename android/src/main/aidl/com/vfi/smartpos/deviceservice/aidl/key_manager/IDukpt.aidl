// IDukpt.aidl
package com.vfi.smartpos.deviceservice.aidl.key_manager;

/**
 * the object of Dukpt
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */

interface IDukpt {

	/**
     * load the DUKPT key
     *
	 * @param keyId the id (index 0~99)
	 * @param ksn the key serial number
	 * @param key the key
	 * @param checkValue the check value (default NULL)
	 * @param extend - extend param
     * <ul>
     *     <li>isPlainKey(boolean) default value is true(key is plain key), value is false means the key is a encrypt key that encrypt by TEK</li>
     *     <li>TEKIndex(int) index of TEK,if isPlainKey is false, need to set this paramater</li>
     *     <li>KSNAutoIncrease(boolean) default value is true, if value is false, application use increaseKSN() to  increase KSN manually</li>
     * </ul>
	 * @return true on success, false on failure
	 * @since 2.x.x
     *
	 */
	boolean loadDukptKey(int keyId, in byte[] ksn, in byte[] key, in byte[] checkValue, in Bundle extend);

    /**
     *  increase ksn
     * @param index keyID(0~99)
     * @return current ksn
	 * @since 2.x.x
     */
	byte[] increaseKSN(int index);

	/**
     * calcute the MAC with given type
     *
     * @param index keyID(0~99)
	 * @param type Calculation mode <BR>
	 *     |---0x00-MAC X99;<BR>
	 *     |---0x01-MAC X919;<BR>
	 *     |---0x02-ECB (CUP standard ECB algorithm);<BR>
	 *     |---0x03-MAC 9606;<BR>
	 *     |---0x04-CBC MAC calculation;<BR>
	 * @param CBCInitVec - CBC initial vector. fixed length 8, can be null, default 8 bytes 0x00
	 * @param data the source date
	 * @param desType encrypt type<BR>
     *     |--0x00-des<BR>
     *     |--0x01-3des<BR>
     *     |--0x02-sm4<BR>
     *     |--0x03-aes<BR>
	 * @param extend - extend param
     * <ul>
     *     <li>variantRequestKey(boolean) true-Message Authentication, request or both ways; false-Message Authentication, response(default)</li>
     * </ul>
	 * @return the mac value, null means failure
	 * @since 2.x.x
	 */
    byte[] calculateMAC(int keyId, int type, in byte[] CBCInitVec, in byte[] data, int desType, in Bundle extend);

    /**
     * @brief encrypt data
     * @param index keyID(0~99)
     * @param encryptType<BR>
     *    |---TYPE_DES - 0x00 DES Type<BR>
     *    |---TYPE_3DES - 0x01 3DES Type<BR>
     *    |---TYPE_SM4 - 0x02 SM4 Type<BR>
     *    |---TYPE_AES - 0x03 AES Type<BR>
	 * @param algorithmModel<BR>
	 *     |--0x01 CBC encrypt<BR>
	 *     |--0x02 ECB encrypt<BR>
	 *     |--0x03 CBC decrypt<BR>
	 *     |--0x04 ECB decrypt<BR>
	 * @param data the source date
	 * @param initVec cbc init vector
	 * @param extend - extend param
     * <ul>
     *     <li style="text-decoration:line-through;"">variantRequestKey(boolean) true-Data Encryption request or both ways; false-Data Encryption response(default)</li>
     *     <li>dukptDispersionType(byte)</li> <BR>
     *           |---0x00 Data Encryption request or both ways<BR>
     *           |---0x01 Data Encryption response (default)<BR>
     *           |---0x02 Customize, use Pin Variant constant<BR>
     * </ul>
     * @return the encrypted data, null means failure
	 * @since 2.x.x
     */
	byte[] calculateData(int keyId, int encryptType, int algorithmModel, in byte[] data, in byte[] initVec, in Bundle extend);

    /**
     * get the current KSN
     *
     * @param index keyID(0~99)
     * @return the current dukpt ksn
	 * @since 2.x.x
	 */
	 byte[] getDukptKsn(int keyIdx);

    /**
     * get the last error
     *
     * @return the description of the last error
	 * @since 2.x.x
     */
	String getLastError();

    /**
     * get dukpt config file for debug(just support debug version service)
     * @param savePath
     * @return true-success false-failed
     * @since 2.x.x
     */
	boolean getDukptCFG(String savePath);


    /**
     * set dukpt config file
	 * @param keyData
     * <ul>
     *     <li>keyId(int)</li>
     *     <li><b style="text-decoration:line-through;">ksn(String) optional, keep current value if not set</b></li> // ksn(String) parameter was removed
     *     <li>autoIncrease(boolean) optional, keep current value if not set</li>
     * </ul>
     * @return true-success false-failed
     * @since 2.6.0.0
     */
	boolean setDukptCFG(in Bundle keyData);
}

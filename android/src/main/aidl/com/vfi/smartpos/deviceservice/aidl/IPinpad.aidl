package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.PinInputListener;
import com.vfi.smartpos.deviceservice.aidl.PinKeyCoorInfo;

/**
 * the object of PIN pad
 * download keys, data encrypt, pin input
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface IPinpad {
	/**
     * Check if Key is exists (just support ECB key)
     *
	 * @param keyType
	 * <ul>
	 * <li>0 MASTER(main) key</li>
	 * <li>1 MAC key</li>
	 * <li>2 PIN(work) key</li>
	 * <li>3 TD key</li>
	 * <li>4 (SM) MASTER key</li>
	 * <li>5 (SM) MAC key</li>
	 * <li>6 (SM) PIN key</li>
	 * <li>7 (SM) TD key</li>
	 * <li>8 (AES) MASTER key</li>
	 * <li>9 (AES) MAC key</li>
	 * <li>10 (AES) PIN key</li>
	 * <li>11 (AES) TD key</li>
	 * <li>12 dukpt key</li>
	 * <li>13 TEK</li>
	 * <li>14 (SM)TEK</li>
	 * <li>15 (AES)TEK</li>
	 * </ul>
	 * @param keyId the id (dukpt index 0~4, other 0~99) of the key
	 * @return true for exist, false for not exists
	 * @since 1.x.x
     *
	 **/
	boolean isKeyExist(int keyType, int keyId);
	
    /**
     * load plain TEK key(algorithm = 2, 3des plain key default)
     *
	 * TEK is the transfer key to encrypt master key
	 * @param keyId the id (index) , from 0 to 99
	 * @param the key
	 * @param checkValue the check value
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see #loadTEKEX} instead.
     *
	 */
	boolean loadTEK(int keyId, in byte[] key, in byte[] checkValue);

    /**
     * load TEK key with Algorithm Type (ECB default)
     *
     * TEK is the transfer key to encrypt master key
	 * @param keyId the id (index, 0 to 99)
	 * @param key the key
	 * @param algorithmType 1-3des encrypted key <BR>2-3des plain key <BR>3-SM4 encrypte key <BR>4-SM4 plain key <BR>5-AES encrypted key <BR>6-AES plain key
	 * @param checkValue the check value
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see #loadTEKEX} instead.
     *
	 */
	boolean loadTEKWithAlgorithmType(int keyId, in byte[] key, in byte algorithmType, in byte[] checkValue);

	/**
     * load the encrypted master key (3des ECB algorithm, decrypt TEK index = 0)
     *
	 * @param keyId the id (index, 0 to 99)
	 * @param key the encrypted key
	 * @param checkValue check value (default NULL)
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see #loadEncryptMainKeyEX} instead.
     *
	 */
	boolean loadEncryptMainKey(int keyId, in byte[] key, in byte[] checkValue);

	/**
     * load the encrypted master key given Algorithm Type (ECB, decrypt TEK index = 0)
     *
	 * @param keyId the id (index, 0 to 99)
	 * @param key the encrypted key(encrypt by TEK)
	 * @param algorithmType 1-3des algorithm <BR>3-SM4 algorithm <BR>5-AES algorithm
	 * @param checkValue -  check value (default NULL)
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see #loadEncryptMainKeyEX} instead.
	 */
	boolean loadEncryptMainKeyWithAlgorithmType(int keyId, in byte[] key, int algorithmType, in byte[] checkValue);

	/**
     * load the plain master key(3des ECB algorithm default)
     *
	 * @param keyId the id (index)
	 * @param key the key
	 * @param checkValue the check value (default NULL)
	 * @return true on success, false on failure
	 * @since 1.x.x
     *
	 */
	boolean loadMainKey(int keyId, in byte[] key, in byte[] checkValue);

	/**
     * load the plain master key given the algorithm Type (support ECB\CBC)
     *
	 * @param keyId the id (index)
	 * @param key the key
	 * @param algorithmType
	            0x02-3des ecb algorithm<BR> 0x04-SM4 ecb algorithm<BR> 0x06-AES ecb algorithm<BR>
	            0x82-3des cbc algorithm<BR> 0x84-SM4 cbc algorithm<BR> 0x86-AES cbc algorithm<BR>
	 * @param checkValue the check value (default NULL)
	 * @return true on success, false on failure
	 * @since 1.x.x
     *
	 */
	boolean loadMainKeyWithAlgorithmType(int keyId, in byte[] key, int algorithmType, in byte[] checkValue);

	/**
     * load the encrypt DUKPT key(decrypt TEK index = 0)
     *
	 * @param keyId the id (index 0~99)
	 * @param ksn the key serial number
	 * @param key the key
	 * @param checkValue the check value (default NULL)
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see com.vfi.smartpos.deviceservice.aidl.key_manager.IDukpt#loadDukptKey} instead.
     *
	 */
	boolean loadDukptKey(int keyId, in byte[] ksn, in byte[] key, in byte[] checkValue);

	/**
     * load the work key (3DES ECB, decrypt by master key)
     *
	 * @param keyType select the workkey type: 1-MAC key, 2-PIN key, 3-TD key
	 * @param mkId the id of master key for decrypt work key
	 * @param keyId set the workkey id (index 0~99)
	 * @param key the key (16bytes)
	 * @param checkValue check value (null for none)
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see #loadWorkKeyEX} instead.
	 */
	boolean loadWorkKey(int keyType, int mkId, int wkId, in byte[] key, in byte[] checkValue);

	/**
     * load the work key given decrypt type
     *
	 * @param keyType select the workkey type<BR>
	 *     |---1-MAC key, 2-PIN key, 3-TD key<BR>
	 *     |---5-(SM4)MAC key, 6-(SM4)PIN key, 7-(SM4)TD key<BR>
	 *     |---9-(AES)MAC key, 10-(AES)PIN key, 11-(AES)TD key<BR>
	 * @param mkId the id of master key for decrypt work key
	 * @param wkId set the workkey id (index 0~99)
	 * @param decKeyType select decrypt key type<BR>
	 *     |---0-3DES master key<BR>
	 *     |---1-transport key<BR>
	 *     |---2-SM4 master key<BR>
	 *     |---3-AES master key<BR>
	 * @param encrypt key
	 * @param checkValue check value (null for none)
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see #loadWorkKeyEX} instead.
	 */
	boolean loadWorkKeyWithDecryptType(int keyType, int mkId, int wkId, int decKeyType, in byte[] key, in byte[] checkValue);

	/**
     * calcuate the MAC (3des default & X919)
     *
	 * @param keyId the index of MAC KEY
	 * @param data the source date
	 * @return the mac value, null means failure
	 * @since 1.x.x
     * @deprecated pls use {@see #calcMACWithCalType} instead.
     *
	 */
	byte[] calcMAC(int keyId, in byte[] data);

	/**
     * calcute the MAC with given type
     *
	 * @param keyId the index of MAC KEY(0~99) or dukpt key(0~4)
	 * @param type Calculation mode 0x00-MAC X99; 0x01-MAC X919; 0x02-ECB (CUP standard ECB algorithm); 0x03-MAC 9606; 0x04-CBC MAC calculation
	 * @param CBCInitVec - CBC initial vector. fixed length 8, can be null, default 8 bytes 0x00
	 * @param data the source date
	 * @param desType encrypt type<BR>
     * <b style="text-decoration:line-through;">|--0x00-des</b><BR>
     * |--0x01-3des<BR>
     * |--0x02-sm4<BR>
     * |--0x03-aes<BR>
     * @param dukptRequest true means the keyId is dukpt key id
	 * @return the mac value, null means failure
	 * @since 1.x.x
	 */
	byte[] calcMACWithCalType(int keyId, int type, in byte[] CBCInitVec, in byte[] data, int desType, boolean dukptRequest);

	/**
     * encrypt the trace date(3des algorithm default)
     *
	 * @param mode mode , 0 for ECB, 1 for CBC
	 * @param keyId the id of TDK
	 * @param trkData the track date
	 * @return @return the encrypted track data, null means failure
	 * @since 1.x.x
     * @deprecated pls use {@see #encryptTrackDataWithAlgorithmType} instead.
     *
	 */
	byte[] encryptTrackData(int mode, int keyId, in byte[] trkData);

	/**
     * encrypt the trace date given algorithm type
     *
	 * @param mode mode , 0 for ECB, 1 for CBC
	 * @param keyId the id of TDK(0~99) or dukpt key(0~4)
	 * @param AlgorithmType algorithmType type 0x01-3des 0x02-SM4 0x03-AES
	 * @param trkData the track date
	 * @param dukptRequest if true, the keyId is dukpt key id
	 * @return the encrypted track data, null means failure
	 * @since 1.x.x
	 */
	byte[] encryptTrackDataWithAlgorithmType(int mode, int keyId, int algorithmType, in byte[] trkData, boolean dukptRequest);

    /**
     * start PIN input
     *
     * @param keyId the index of PIN KEY(0~99) or dukpt key (0~4)
     * @param param the parameter
     * <ul>
     * <li>pinLimit(byte[]) the valid length(s) array of the PIN (such as {0,4,5,6} means the valid length is 0, 4 ~6)</li>
     * <li>timeout(int) the timeout, second</li>
     * <li>isOnline(boolean) is a online PIN</li>
     * <li>promptString(String) the prompt string</li>
     * <li>pan(String) the pan for encrypt online PIN</li>
     * <li>desType(int) calculate type<BR>
     *   |----0x01 MK/SK + 3DES (default)<BR>
     *   |----0x02 MK/SK + AES<BR>
     *   |----0x03 MK/SK + SM4<BR>
     *   |----0x04 DUKPT + 3DES<BR>
     * </li>
     * <li>numbersFont(String) - url of numbers ttf font (value "" is android system fonts)</li>
     * <li>promptsFont(String) - url of prompt ttf font(value "" is android system fonts)</li>
     * <li>otherFont(String) - url of other ttf font(confirm button & backspace button)(value "" is android system fonts)</li>
     * <li>displayKeyValue(byte[]) - custom the sequence key number of pinpad</li>
     * <li>random(byte[]) - random number participation in pinblock calculation(default not set)</li>
     * <li>notificatePinLenError(boolean) - Notification password is not long enough(default false)</li>
     * <li>pinFormatType(int) - default is format0, 0-format0, 1-format1, 2-format2, 3-format3, 4-format4</li>
     * <li>dispersionType(int) - default is 0(DES112), 0-DES112, 1-DES168, 2-AES128, 3-AES192, 4-AES256</li>
     * </ul>
     * @param listener the call back listener
     * @param globalParam - set global display (if set null, 0~9 are Arabic numerals and confirm/backspace button are english display)
     * <ul>
     *     <li>Display_One(String)</li>
     *     <li>Display_Two(String)</li>
     *     <li>Display_Three(String)</li>
     *     <li>Display_Four(String)</li>
     *     <li>Display_Five(String)</li>
     *     <li>Display_Six(String)</li>
     *     <li>Display_Seven(String)</li>
     *     <li>Display_Eight(String)</li>
     *     <li>Display_Nine(String)</li>
     *     <li>Display_Zero(String)</li>
     *     <li>Display_Confirm(String)</li>
     *     <li>Display_BackSpace(String)</li>
     * </ul>
     * @return
	 * @since 1.x.x
     */
	void startPinInput(int keyId, in Bundle param, in Bundle globleParam, PinInputListener listener);

	/**
     * submit the pin input
	 * @since 1.x.x
     */
    void submitPinInput();
    
    /**
     * stop the pin input
	 * @since 1.x.x
	 * @deprecated pls clicked cannel button on UI page
	 */
    void stopPinInput();
    
    /**
     * get the last error
     * @return the description of the last error
	 * @since 1.x.x
     */
	String getLastError();

    /**
     * same the "calculateData"
	 * @since 1.x.x
	 * @deprecated See {@see #calculateDataEx}
     */
	byte[] colculateData(int mode, int desType, in byte[] key, in byte[] data);


    /**
     * DUKPT encrypt
     *
     * @param desType the type of encrypt
     * <ul>
     * <li>TYPE_DES - 0x00 DES Type </li>
     * <li>TYPE_3DES - 0x01 3DES Type </li>
     * <li>TYPE_SM4 - 0x02 SM4 Type</li>
     * <li>TYPE_AES - 0x03 AES Type</li>
     * </ul>
     * @param algorithm the type of algorithm 0x01-CBC 0x02-ECB
	 * @param keyid - index of key (0~4)
	 * @param data - the source date
	 * @param CBCInitVec - CBC initial vector. fixed length 8, can be null, default 8 bytes 0x00
	 * @since 1.x.x
     * @deprecated pls use {@see com.vfi.smartpos.deviceservice.aidl.key_manager.IDukpt#calculateData} instead.
     *
     */
	byte[] dukptEncryptData(int destype, int algorithm, int keyid, in byte[] data, in byte[] CBCInitVec);

    /**
     * save the plain key(just support 3des, )
     *
	 * @param keyType the key type 1 for MAC ，2 for PIN ，3 for TD
	 * @param keyId the index of KEY
	 * @param key the source key
	 * @since 1.x.x
	 * @deprecated
	 */
    boolean savePlainKey(int keyType, int keyId, in byte[] key);

    /**
     * get the current KSN
     *
     * @return the current dukpt ksn
	 * @since 1.x.x
     * @deprecated pls use {@see com.vfi.smartpos.deviceservice.aidl.key_manager.IDukpt#getDukptKsn} instead.
	 */
	 byte[] getDukptKsn();


    /**
     * get the SM2 public key & private key
     *
     * @return bundle
     * <ul>
     *     <li>publicKey(string)</li>
     *     <li>privateKey(string)</li>
     * </ul>
	 * @since 1.x.x
	 * @deprecated
     *
     */
     Bundle generateSM2KeyPair();

    /**
     * Get SM3 data summary
     *
     * @data - data;
     * @return byte[] summary
	 * @since 1.x.x
	 * @deprecated
     *
     */
     byte[] getSM3Summary(in byte[] data);

    /**
     * get the SM2 sign
     *
     * @param bundle
     * <ul>
     *     <li>prikey(byte[])</li> - the private key
     *     <li>data(byte[])</li> - the data want to sign
     * </ul>
     * @return calculate resule;
	 * @since 1.x.x
	 * @deprecated
     */
     byte[] getSM2Sign(in Bundle bundle);

    /**
     * Get the checkValue of key
     *
     * @keyIndex - the index of key
     * @keyType - type of key<BR>
     *     0x01 data encryption key;<BR>
     *     0x02 PIN working key<BR>
     *     0x03 MAC key;<BR>
     *     0x04 transfer key<BR>
     *     0x05 Main key<BR>
     *     0x11 data encryption key(SM4)<BR>
     *     0x12 PIN working key(SM4)<BR>
     *     0x13 MAC key(SM4)<BR>
     *     0x14 sm4transport key(SM4)<BR>
     *     0x15 master key(SM4)<BR>
     *     0x21 DATA key(AES)<BR>
     *     0x22 PIN key(AES)<BR>
     *     0x23 MAC key(AES)<BR>
     *     0x24 AES transmission key<BR>
     *     0x25 AES master key<BR>
     *  @return the check value of the key
	 * @since 1.x.x
     *
     * */
     byte[] getKeyKCV(int keyIndex, int keyType);

    /**
     * App custom pinpad ui interface
     *
     * @keyId - pinkey id (the id is the loadWorkKey(pin) id);
     * @param - parameter
     * <ul>
     *     <li>pinLimit(byte[]) the valid length(s) array of the PIN (such as 0,4,5,6 means the valid length is 0, 4 ~6)</li>
     *     <li>timeout(int) the timeout, second</li>
     *     <li>isOnline(boolean) - is a online PIN</li>
     *     <li>pan(String) - the pan for encrypt online PIN</li>
     *     <li>desType(int) - calculate type <BR>
     *       |----0x01 MK/SK + 3DES (default)<BR>
     *       |----0x02 MK/SK + AES<BR>
     *       |----0x03 MK/SK + SM4<BR>
     *       |----0x04 DUKPT + 3DES<BR>
     *     </li>
     *     <li>displayKeyValue(byte[]) - custom the sequence key number of pinpad</li>
     *     <li>random(byte[]) - random number participation in pinblock calculation(default not set)</li>
     *     <li>pinFormatType(int) - default is format0, 0-format0, 1-format1, 2-format2, 3-format3, 4-format4</li>
     *     <li>dispersionType(int) - default is 0(DES112), 0-DES112, 1-DES168, 2-AES128, 3-AES192, 4-AES256</li>
     * </ul>
     * @pinKeyInfos - the list of PinKeyCoorInfo
     * @listener - listener of PinInputListener
     * @return  map<String String> - the value of 0~9 key to display
	 * @since 2.x.x
     * */
	Map initPinInputCustomView(int keyId, in Bundle param, in List<PinKeyCoorInfo> pinKeyInfos, PinInputListener listener);

	/**
     * Execute this interface to activate pinpad.
     *
	 * If you get Map<string string>, you should traversal the map to get the value of key to display.
	 * @since 2.x.x
	 * */
	void startPinInputCustomView();

	/**
     * stop custom pinpad
     *
	 * @since 2.x.x
	 */
	void endPinInputCustomView();

    /**
     * encrypt or decrypt data
     *
     * @param mode the mode of encrypt or decrypt
     * <ul>
     * <li>0x00 MK/SK ECB encrypt </li>
     * <li>0x01 MK/SK ECB decrypt </li>
     * <li>0x02 MK/SK CBC encrypt </li>
     * <li>0x03 MK/SK CBC decrypt </li>
     * </ul>
     * @param desType the type of encrypt or decrypt
     * <ul>
     * <li>TYPE_DES - 0x00 DES Type  </li>
     * <li>TYPE_3DES - 0x01 3DES Type(EBC)  </li>
     * <li style="text-decoration:line-through;">TYPE_SM4 - 0x02 SM4 Type </li>
     * <li style="text-decoration:line-through;">TYPE_AES - 0x03 AES Type </li>
     * <li>TYPE_SM2_PUBKEY - 0x04 SM2 Type(use public key) </li>
     * <li>TYPE_SM2_PRIVKEY - 0x05 SM2 Type(use private key) </li>
     * <li>TYPE_3DES - 0x06 3DES Type(CBC, initVec = 00000000) </li>
     * </ul>
	 * @param key the source key
	 * @param data the source date
     *
     * @return the encrypted or decrypted data, null means failure
	 * @since 1.x.x
     * @deprecated pls use {#calculateDataEx} instead.
     */
	byte[] calculateData(int mode, int desType, in byte[] key, in byte[] data);

    /**
     * encrypt or decrypt data
     *
     * @param mode the mode of encrypt or decrypt
     * <ul>
     * <li>0x00 MK/SK ECB encrypt </li>
     * <li>0x01 MK/SK ECB decrypt </li>
     * <li>0x02 MK/SK CBC encrypt </li>
     * <li>0x03 MK/SK CBC decrypt </li>
     * </ul>
     * @param desType the type of encrypt or decrypt
     * <ul>
     * <li>TYPE_DES - 0x00 DES Type </li>
     * <li>TYPE_3DES - 0x01 3DES Type(EBC) </li>
     * <li>TYPE_SM4 - 0x02 SM4 Type </li>
     * <li>TYPE_AES - 0x03 AES Type</li>
     * <li style="text-decoration:line-through;">TYPE_SM2_PUBKEY - 0x04 SM2 Type(use public key) </li>
     * <li style="text-decoration:line-through;">TYPE_SM2_PRIVKEY - 0x05 SM2 Type(use private key) </li>
     * <li style="text-decoration:line-through;">TYPE_3DES - 0x06 3DES Type(CBC) NOTICE: WorkKey(TD) id = 60 will be occupied, so user app should not use 60 index of TD </li>
     * </ul>
	 * @param key the source key
	 * @param data the source date
	 * @param initVec 3des cbc init vector
     *
     * @return the encrypted or decrypted data, null means failure
	 * @since 1.x.x
     */
	byte[] calculateDataEx(int mode, int desType, in byte[] key, in byte[] data, in byte[] initVec);

    /**
     * encrypt pinblock from cardnumber & passwd
     *
     * @param pinKeyId the index of PIN KEY(0~99)
     * @param desType calculate type <BR>
     *   |----0x01 MK/SK + 3DES (default)<BR>
     *   |----0x02 MK/SK + AES<BR>
     *   |----0x03 MK/SK + SM4<BR>
     *   |----0x04 DUKPT + 3DES<BR>
     * @param cardNumber - card number (ascii type, such as "1234", you should input byte[4] = "31 32 33 34")
     * @param passws- plain password (String type, such as "1234", you should input String = "1234")
	 * @since 1.x.x
     */
	byte[] encryptPinFormat0(int pinKeyId, int desType, in byte[] cardNumber, String passwd);


	/**
     * encrypt data or decrypt data by data key
     *
	 * @param keyId - data key index(0~99)
	 * @param encAlg- encryption algorithm<BR>
	 *     |---0x01 3DES<BR>
	 *     |---0x02 SM4<BR>
	 *     |---0x03 AES<BR>
	 * @param encMode - encryption mode of operation<BR>
	 *     |--0x01 ECB<BR>
	 *     |--0x02 CBC<BR>
	 * @param encFlag - encryption flag<BR>
	 *     |--0x00 encrypt<BR>
	 *     |--0x01 decrypt<BR>
	 * @param data - data
	 * @param initVec - init vec，default set null;
	 * @return the result of encrypt data or decrypt data;
	 * @since 1.x.x
	 */
    byte[] calculateByDataKey(int keyId, int encAlg, int encMode, int encFlag, in byte[] data, in byte[] initVec);

	/**
     * load the encrypted master key given Algorithm Type
     *
	 * @param keyId the id (index, 0 to 99)
	 * @param key the encrypted key
	 * @param algorithmType 0x01-3des algorithm<BR> 0x03-SM4 algorithm<BR> 0x05-AES algorithm<BR> 0x81-3des(cbc)<BR> 0x83-SM4(cbc)<BR> 0x85-AES(cbc)<BR>
	 * @param check value (default NULL)
	 * @param extend - extend param
     * <ul>
     *     <li>isCBCType(boolean) judge the mk encrypt mode whether is CBC mode(default false)</li>
     *     <li>initVec(byte[]) cbc initVec(default 16byte 0)</li>
     *     <li>isMasterEncMasterMode(boolean) master key can encrypt master key, if pos has loaded Master key</li>
     *     <li>decryptKeyIndex(int) (index 0 to 99)Decrypt key index. Will use the KeyId if not set and after that the last key will be overwritten.</li>
     * </ul>
	 * @return true for success, false for failure
	 * @since 1.x.x
	 */

	boolean loadEncryptMainKeyEX(int keyId, in byte[] key, int algorithmType, in byte[] checkValue, in Bundle extend);

	/**
     * load the work key given decrypt type
     *
	 * @param keyType select the workkey type<BR>
	 *     |---1-MAC key, 2-PIN key, 3-TD key<BR>
	 *     |---5-(SM4)MAC key, 6-(SM4)PIN key, 7-(SM4)TD key<BR>
	 *     |---9-(AES)MAC key, 10-(AES)PIN key, 11-(AES)TD key<BR>
	 * @param mkId the id of master key for decrypt work key
	 * @param wkId set the workkey id (index 0~99)
	 * @param decKeyType select decrypt key type<BR>
	 *     |---0x00-3DES master key<BR>
	 *     |---0x01-transport key<BR>
	 *     |---0x02-SM4 master key<BR>
	 *     |---0x03-AES master key<BR>
	 *     |---0x04-SM4 transport key<BR>
	 *     |---0x05-AES transport key<BR>
	 *     |---0x80-CBC 3DES master key<BR>
	 *     |---0x81-CBC transport key<BR>
	 *     |---0x82-CBC SM4 master key<BR>
	 *     |---0x83-CBC AES master key<BR>
	 *     |---0x84-CBC SM4 transport key<BR>
	 *     |---0x85-CBC AES transport key<BR>
	 * @param encrypt key
	 * @param checkValue check value (null for none)
	 * @param extend - extend param
     * <ul>
     *     <li>isCBCType(boolean) judge the mk encrypt mode whether is CBC mode(default false)</li>
     *     <li>initVec(byte[]) cbc initVec(default 16byte 0)</li>
     * </ul>
	 * @return true on success, false on failure
	 * @since 1.x.x
	 */
	boolean loadWorkKeyEX(int keyType, int mkId, int wkId, int decKeyType, in byte[] key, in byte[] checkValue, in Bundle extend);


    /**
     * clear MK & WK(k21 version > 169)
     *
     * @param keyId clear key id
     * @param keyType
     * <ul>
     * <li> 0x00-DES MK</li>
     * <li> 0x01-SM4 MK</li>
     * <li> 0x02-AES MK</li>
     * <li> 0x10-DES PIN</li>
     * <li> 0x11-SM4 PIN</li>
     * <li> 0x12-AES PIN</li>
     * <li> 0x20-DES MAC</li>
     * <li> 0x21-SM4 MAC</li>
     * <li> 0x22-AES MAC</li>
     * <li> 0x30-DES DATA</li>
     * <li> 0x31-SM4 DATA</li>
     * <li> 0x32-AES DATA</li>
     * <li> 0x40-DES DUKPT</li>
     * <li> 0x41-AES DUKPT</li>
     * <li> 0x50-DES TEK</li>
     * <li> 0x51-AES TEK</li>
     * </ul>
	 * @since 1.x.x
     */
	boolean clearKey(int keyId, int keyType);

	/**
     * load the DUKPT key
     *
	 * @param keyId the id (index 0~99)
	 * @param ksn the key serial number
	 * @param key the key
	 * @param checkValue the check value (default NULL)
	 * @param extend - extend param
     * <ul>
     *     <li>loadPlainKey(boolean) load plain key or encrypt key</li>
     *     <li>TEKIndex(int) index of TEK,if isPlainKey is false, need to set this paramater</li>
     * </ul>
	 * @return true on success, false on failure
	 * @since 1.x.x
     * @deprecated pls use {@see com.vfi.smartpos.deviceservice.aidl.key_manager.IDukpt#loadDukptKey} instead.
	 */
	boolean loadDukptKeyEX(int keyId, in byte[] ksn, in byte[] key, in byte[] checkValue, in Bundle extend);

    /**
     * load TEK key with Algorithm Type given
     *
     * TEK is the transfer key to encrypt master key
	 * @param keyId the id (index, 0 to 99)
	 * @param key the key
	 * @param algorithmType<BR>
	 *     |---0x01-3des encrypted key <BR>
	 *     |---0x02-3des plain key <BR>
	 *     |---0x03-SM4 encrypte key <BR>
	 *     |---0x04-SM4 plain key <BR>
	 *     |---0x05-AES encrypted key <BR>
	 *     |---0x06-AES plain key
	 *     |---0x81-CBC 3des encrypted key <BR>
	 *     |---0x82-CBC 3des plain key <BR>
	 *     |---0x83-CBC SM4 encrypte key <BR>
	 *     |---0x84-CBC SM4 plain key <BR>
	 *     |---0x85-CBC AES encrypted key <BR>
	 *     |---0x86-CBC AES plain key
	 * @param checkValue the check value
	 * @param extend - extend param
     * <ul>
     *     <li>isCBCType(boolean) judge the mk encrypt mode whether is CBC mode(default false)</li>
     *     <li>initVec(byte[]) cbc initVec(default 16byte 0)</li>
     * </ul>
	 * @return true on success, false on failure
	 * @since 1.x.x
	 */
	boolean loadTEKEX(int keyId, in byte[] key, in byte algorithmType, in byte[] checkValue, in Bundle extend);

	/**
     * encrypt data or decrypt data by data key
     *
	 * @param keyId - data key index(0~99)
	 * @param keyType - key type
	 *     |---0x01 data key<BR>
	 *     |---0x02 mac key<BR>
	 *     <b style="text-decoration:line-through;">|---0x03 pin key</b><BR>
	 * @param encAlg- encryption algorithm<BR>
	 *     |---0x01 3DES<BR>
	 *     |---0x02 SM4<BR>
	 *     |---0x03 AES<BR>
	 * @param encMode - encryption mode of operation<BR>
	 *     |--0x01 ECB<BR>
	 *     |--0x02 CBC<BR>
	 * @param encFlag - encryption flag<BR>
	 *     |--0x00 encrypt<BR>
	 *     |--0x01 decrypt<BR>
	 * @param data - data
	 * @param extend - extend param
     * <ul>
     *     <li>initVec(byte[]) cbc initVec(default null)</li>
     * </ul>
	 * @return the result of encrypt data or decrypt data;
	 * @since 2.x.x
	 */
    byte[] calculateByWorkKey(int keyId, int keyType, int encAlg, int encMode, int encFlag, in byte[] data, in Bundle extend);

	/**
     * calculate by MSKey
     *
	 * @param keyId - data key index(0~99)
	 * @param keyType - key type
	 *     |---0x01 3DES master key<BR>
	 *     |---0x02 SM4 master key<BR>
	 *     |---0x03 AES master key<BR>
	 * @param algorithmMode - encryption algorithm<BR>
	 *     |---0x00 encrypt ECB<BR>
	 *     |---0x01 decrypt ECB<BR>
	 *     |---0x02 encrypt CBC<BR>
	 *     |---0x03 decrypt CBC<BR>
	 * @param data - data
	 * @param extend - extend param
     * <ul>
     *     <li>initVec(byte[]) cbc initVec(default null if not set)</li>
     * </ul>
	 * @return the result of encrypt data or decrypt data;
	 * @since 2.x.x
	 */
    byte[] calculateByMSKey(int keyId, int keyType, int algorithmMode, in byte[] data, in Bundle extend);

    /**
     * get random data
     *
	 * @param length - length of random data(1~255)
	 * @return result of random data;
	 * @since 2.x.x
     */
    byte[] getRandom(byte length);


    /**
     * inject PIN key event direct
     *
     * @param type  see PinType
        enum PinType {
            PINPAD_BUTTON_TYPE_DIGIT,
            PINPAD_BUTTON_TYPE_CLEAR,  //means to clear all characters entered so far
            PINPAD_BUTTON_TYPE_CONFIRM,
            PINPAD_BUTTON_TYPE_CANCEL,
            PINPAD_BUTTON_TYPE_BACKSPACE; //clears only one character
        }
     *
     * @param key if DIGIT type, key is 0~9, other PinType key set '' empty
     * @return 0-success, other-fail
     * @deprecated
     */
    int injectPinKey(int type, char key);

    /**
     *  App custom pinpad ui interface

     * @param - parameter
     * <ul>
     *     <li>pinLimit(byte[]) the valid length(s) array of the PIN (such as 0,4,5,6 means the valid length is 0, 4 ~6)</li>
     *     <li>timeout(int) the timeout, second</li>
     *     <li>random(Boolean) - random Pin number(default is false)</li>
     * </ul>
     * @param pinKeyInfos - the list of PinKeyCoorInfo
     * @return result of start Pin
     * @deprecated
     */
    boolean startPinByInjectType(in Bundle param, inout PinKeyCoorInfo[] pinKeyInfos);


}

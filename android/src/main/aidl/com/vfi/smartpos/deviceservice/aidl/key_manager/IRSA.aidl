// IRSA.aidl
package com.vfi.smartpos.deviceservice.aidl.key_manager;

/**
 * Created by RuoYi
 * @since >= 3.x.x
 */

interface IRSA {

    /**
     * generate RSA Key Pair
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of saved RSA key pair</li>
     * <li>keyLength(int) length of the key(only support 1024(default) and 2048)</li>
     * <li>returnPublicKeyFormat(int) 0 - PEM format  1 - DER format(default) 2 - Private format( Format {'modulus':'xxxxx','exponent':'xxxxx'} )</li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - success ; false - failed</li>
     * <li>publicKey(byte[]) public key data (1 - DER format);   Example code: result.getByteArray("publicKey");</li>
     * <li>publicKey(String) public key data (0 - PEM format(Base64) or 2 - private format);    Example code: result.getString("publicKey");</li>
     * </ul>
     *
     * @since 3.x.x
     */
    Bundle generateRSAKeyPair(in Bundle params);

    /**
     * Encrypting data with RSA algorithm
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>data(byte[]) Encrypt data</li>
     * <li>paddingType(String) Support padding type is NoPadding/PKCS1Padding/OAEPPadding  , default use PKCS1Padding</li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - success ; false - failed</li>
     * <li>encryptedData(byte[]) Encrypted data</li>
     * </ul>
     *
     * @since 3.x.x
     */
    Bundle RSAEncryption(in Bundle params);

    /**
     * Decrypting data with RSA algorithm
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>encryptedData(byte[]) Encrypted data</li>
     * <li>paddingType(String) Support padding type is NoPadding/PKCS1Padding , default use PKCS1Padding  Note:OAEPPadding not support</li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - success ; false - failed</li>
     * <li>data(byte[]) decrypted data</li>
     * </ul>
     *
     * @since 3.x.x
     */
     Bundle RSADecryption(in Bundle params);

     /**
      * Delete RSA key
      *
      * @param params parameters (list)
      * <ul>
      * <li>keyIndex(int) (0~99) index of RSA key</li>
      * </ul>
      *
      * @return (boolean)  true - delete success; false - delete failed
      *
      * @since 3.x.x
      */
     boolean deleteRSAKey(in Bundle params);

     /**
      * Get RSA Public key
      *
      * @param params parameters (list)
      * <ul>
      * <li>keyIndex(int) (0~99) index of RSA key</li>
      * <li>returnPublicKeyFormat(int) 0 - PEM format  1 - DER format(default) 2 - Private format( Format {'modulus':'xxxxx','exponent':'xxxxx'} )</li>
      * </ul>
      *
      * @return result
      * <ul>
      * <li>isSuccess(boolean) true - success ; false - failed</li>
      * <li>publicKey(byte[]) public key data (1 - DER format)</li>
      * <li>publicKey(String) public key data (0 - PEM format(Base64) or 2 - private format)</li>
      * </ul>
      *
      * @since 3.x.x
      */
      Bundle getPublicKey(in Bundle params);

    /**
     * Save RSA Public key
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>modulus(String) Hex format RSA public key modulus</li>
     * <li>exponent(String) Hex format RSA public key exponent</li>
     * </ul>
     *
     * @return (boolean)  true - save success; false - save failed
     *
     * @since 3.x.x
     */
      boolean savePublicKey(in Bundle params);

    /**
     * Save RSA Private key
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>modulus(String) Hex format RSA public key modulus</li>
     * <li>publicExponent(String) Hex format RSA public key exponent</li>
     * <li>privateExponent(String) Hex format RSA private key exponent</li>
     * <li>prime1(String) Hex format RSA private key prime1</li>
     * <li>prime2(String) Hex format RSA private key prime2</li>
     * <li>exponent1(String) Hex format RSA private key exponent1</li>
     * <li>exponent2(String) Hex format RSA private key exponent2</li>
     * <li>coefficient(String) Hex format RSA private key coefficient</li>
     * </ul>
     *
     * @return (boolean)  true - save success; false - save failed
     *
     * @since 3.x.x
     */
      boolean savePrivateKey(in Bundle params);

    /**
     * Signing data with RSA algorithm
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>keyLength(int) length of the key(only support 1024(default) and 2048)</li>
     * <li>hashAlgorithm(String) support algorithms  MD5/SHA1/SHA224/SHA256/SHA384/SHA512 default is SHA1</li>
     * <li>isHashData(Boolean) true - payment application calculate hash (Note: android aidl max parameter length limit is 1Mbit) ;  false - this interface will calculate hash ;   default false</li>
     * <li>data(byte[]) sign data</li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - success ; false - failed</li>
     * <li>signature(byte[]) signature</li>
     * </ul>
     *
     * @since 3.x.x
     */
      Bundle RSASign(in Bundle params);

    /**
     * verify data with RSA algorithm
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>hashAlgorithm(String) support algorithms  MD5/SHA1/SHA224/SHA256/SHA384/SHA512 default is SHA1</li>
     * <li>data(byte[]) data  Note: data limit is 1 Mbit, if over this limit please do RSA Verify in application</li>
     * <li>signature(byte[]) signature</li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - verify success ; false - verify failed</li>
     * </ul>
     *
     * @since 3.x.x
     */
      Bundle RSAVerify(in Bundle params);

    /**
     * Check if exist key
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of RSA key</li>
     * <li>keyType(int) 0 - check RSA public key  ;  1 - check RSA private key (Not support)  default is 0</li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - exist ; false - not exist</li>
     * </ul>
     *
     * @since 3.x.x
     */
      boolean isKeyExist(in Bundle params);

    /**
     * Save Certification
     *
     * @param params parameters (list)
     * <ul>
     * <li>keyIndex(int) (0~99) index of Certification RSA public key</li>
     * <li>data(byte[]) certification data, Code example: x509Certificate.getEncoded() </li>
     * </ul>
     *
     * @return result
     * <ul>
     * <li>isSuccess(boolean) true - success ; false - failed</li>
     * </ul>
     *
     * @since 3.x.x
     */
      boolean saveCertificate(in Bundle params);
}
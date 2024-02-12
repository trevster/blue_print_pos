// IUltraLightCard.aidl
package com.vfi.smartpos.deviceservice.aidl.card_reader;

interface IUltraLightCardEV1 {
    /**
     * init UltraLight card
     * @return 0:success other:fail
     * @since 3.10.7
     */
    int	init();

    /**
     * execute write command
     * @param bAddress address of write
     * @param pData data need to write (16Byte)
     * @return 0:success other:fail
     * @since 3.10.7
     */
    int	compatibilityWrite(byte bAddress, in byte[] pData);

    /**
     * @param bAddress
     * @return 16 bytes data of address, other is fail
     * @since 3.10.7
     */
    byte[] read(byte bAddress);

    /**
     * @param bAddress address to write in
     * @param pData 4 bytes data
     * @return 0-success other-fail
     * @since 3.10.7
     */
    int	write(byte bAddress, in byte[] pData);

    /**
     * Ultralight get version
     * @return get version
     * @since 3.10.7
     */
    String getVersion();


    /**
     * Ultralight EV1 check Tearing event
     * @param bCntNum counter number(0~2)
     * @return One-byte address containing the valid flag byte (the valid flag for normal operation is BD), other is failed
     * @since 3.10.7
     */
    byte chkTearingEvent(byte bCntNum);

    /**
     * Ultralight EV1 Fast read
     * @param bStartAddr start address of read data
     * @param bEndAddr end address of read data
     * @return data,
     * @since 3.10.7
     */
    byte[] fastRead(byte bStartAddr, byte bEndAddr);

    /**
     * Ultralight EV1 Increment count
     * @param bCntNum count number
     * @param pCnt 4byte data of count number, low first.
     * @return 0:success other:fail
     * @since 3.10.7
     */
    int	incrCnt(byte bCntNum, in byte[] pCnt);

    /**
     * @param pPwd 4bytes PW data
     * @return 2bytes PACK data, failed is NULL
     * @since 3.10.7
     */
    byte[] pwdAuth(in byte[] pPwd);

    /**
     * @param bCntNum counter number
     * @return 3 bytes data of counter,low first, other is fail
     * @since 3.10.7
     */
    byte[] readCnt(byte bCntNum);

    /**
     * Ultralight EV1 read signature command
     * @param bAddr addr is always 0x00
     * @return 32 bytes data, other is fail
     * @since 3.10.7
     */
    byte[] readSign(byte bAddr);

    /**
     * Ultralight EV1 Virtual Card Select Command
     * @param pVCIIDbyte data use to select VC
     * @param bVCIIDLen data of length
     * @return 0-success other-fail
     * @since 3.10.7
     */
    int virtualCardSelect(in byte[] pVCIIDbyte, byte bVCIIDLen);
}
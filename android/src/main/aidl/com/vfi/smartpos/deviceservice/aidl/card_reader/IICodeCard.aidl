package com.vfi.smartpos.deviceservice.aidl.card_reader;

// Declare any non-default types here with import statements

interface IICodeCard {

	/**
     *
     * Initialize ISO15693 mode. Call this interface to switching from other modes to ISO15693 mode
     * @param  CodingType:  0-ISO15693_CODING_1_4 1-ISO15693_CODING_1_256
     * @param  ModulationType:
     *          0-ISO15693_MODULATION_PERCENT_10
     *          1-ISO15693_MODULATION_PERCENT_14
     *          2-ISO15693_MODULATION_PERCENT_20
     *          3-ISO15693_MODULATION_PERCENT_30,
     *          4-ISO15693_MODULATION_OOK
	 * @return  0-success other-failed
     *
     * @since later 3.6.0.rc0
     *
	 */
    int	initialize(byte CodingType, byte ModulationType);

	/**
     *
     * Deinitialize ISO15693 mode. This function should be called every time iso 15693 is not needed any more
     * @param  keep_on: if 1 the RF field will not be switched off
	 * @return  0-success other-failed
     *
     * @since later 3.6.0.rc0
     *
	 */
    int	deinitialize(byte keep_on);

	/**
     *
     * Perform an ISO15693 inventory to return all PICCs in field.
     * @param slotcnt:  Slotcount used (16 or 1)
     * @param maskLength: length of the mask if available (0 - 63)
     * @param mask: mask to use if \a maskLength is set, otherwise NULL
     * @param maxCards: maximum number of cards to return (= size of \a cards)
	 * @return: success: return 13bytes otherwise return null, buffer array where found card information is stored and number of cards found and returned
     *                   1byte(number of cards found and returned)+
     *                   1byte(flag byte of response)+
     *                   1byte(Data Storage Format Identifier)+
     *                   8byte(UID of the PICC)+
     *                   2byte(CRC of response)
     *
     * @since later 3.6.0.rc0
     *
	 */
    byte[]	inventory(byte slotcnt, byte maskLength, in byte[] mask, byte maxCards);

	/**
     *
     * Send command 'stay quiet' to given PICC.
     * @param ProximityCard: 12bytes  PICC to be sent into quiet state.
     *                       1byte(flag byte of response)+
     *                       1byte(Data Storage Format Identifier)+
     *                       8byte(UID of the PICC)+
     *                       2byte(CRC of response)
	 * @return  0: success,  other: failed
     *
     * @since later 3.6.0.rc0
     *
	 */
    int	sendStayQuiet(in byte[] ProximityCard);

	/**
     *
     * Send command 'Select' to select a PICC for non-addressed mode.
     * @param ProximityCard: 12bytes  PICC to be sent into quiet state.
     *                           1byte(flag byte of response)+
     *                           1byte(Data Storage Format Identifier)+
     *                           8byte(UID of the PICC)+
     *                           2byte(CRC of response)
	 * @return  0: success,  other: failed
     *
     * @since later 3.6.0.rc0
     *
	 */
    int	selectPicc(in byte[] ProximityCard);

	/**
     *
     * Send command 'get system information' to retrieve information from a given or selected PICC
     * @param ProximityCard:
     *          PICC to retrieve the information from. If card is NULL then this parameter is
     *          ignored and the information is fetched from the PICC priorly selected with #SelectPicc()
     *          12bytes     1byte(flag byte of response)+
     *                      1byte(Data Storage Format Identifier)+
     *                      8byte(UID of the PICC)+
     *                      2byte(CRC of response)
	 * @return  success: return 15bytes, fail: return NULL,
	 *                      1byte（flag byte of response）+
	 *                      1byte（info flags）+
	 *                      8byte （UID of the PICC）+
	 *                      1byte（Data Storage Format Identifier）+
	 *                      1byte（Application Family Identifier）+
	 *                      1byte（ number of blocks available）+
	 *                      1byte（number of bytes per block）+
	 *                      1byte（IC reference field ）
     *
     * @since later 3.6.0.rc0
	 */
    byte[]	getPiccSystemInformation(in byte[] ProximityCard);

	/**
     *
     * Read a single block from a given or selected PICC.
     * @param ProximityCard: PICC to read the block from.
     *                If \a card is NULL then this parameter
     *                is ignored and the information is fetched from the PICC
     *                priorly selected with #SelectPicc()
     *
     *	           12bytes	1byte(flag byte of response)+
     *                      1byte(Data Storage Format Identifier)+
     *                      8byte(UID of the PICC)+
     *                      2byte(CRC of response)
	 * @return  return 37bytes, null failed.
	 *                      1byte（flag byte of response）+
     *                      1byte（errorCode）+
     *                      1byte （security status byte）+
     *                      1byte（blocknr）+
     *                      32byte（the content  data）+
     *                      1byte（ actual size of \a data）
     *
     * @since later 3.6.0.rc0
	 */
    byte[]	readSingleBlock(in byte[] ProximityCard);

	/**
     *
     * Read a multiple blocks from a given or selected PICC.
     * @param ProximityCard: PICC to read the block from.
     *                 If \a card is NULL then this parameter
     *                 is ignored and the information is fetched from the PICC
     *                 priorly selected with #SelectPicc()
     *
     *                12bytes	1byte(flag byte of response)+
     *                          1byte(Data Storage Format Identifier)+
     *                          8byte(UID of the PICC)+
     *                          2byte(CRC of response)
     * @param startblock: number of the first block to read out
     * @param count: number of blocks to read out.
	 * @return return 37bytes, null failed.
	 *                  （1byte（flag byte of response）+
     *                        1byte（errorCode）+
     *                        1byte （security status byte）+
     *                        1byte（blocknr）+
     *                        32byte（the content  data）+
     *                        1byte（ actual size of \a data）+）* count
     *
     * @since later 3.6.0.rc0
	 */
    byte[]	readMultipleBlocks(in byte[] ProximityCard, byte startblock, byte count);
	/**
     *
     * Write a single block from a given or selected PICC.
     * @param ProximityCard: PICC to read the block from.
     *                    If \a card is NULL then this parameter
     *                    is ignored and the information is fetched from the PICC
     *                    priorly selected with #SelectPicc
     *
     *               12bytes    1byte(flag byte of response)+
     *                          1byte(Data Storage Format Identifier)+
     *                          8byte(UID of the PICC)+
     *                          2byte(CRC of response)
     * @param flags: flags to be sent to the card.
     * @param memBlock: :  37bytes  1byte（flag byte of response）+
     *                      1byte（errorCode）+
     *                      1byte （security status byte）+
     *                      1byte（blocknr）+
     *                      32byte（the content  data）+
     *                      1byte（ actual size of \a data
	 * @return  0: success,  other: failed
     *
     * @since later 3.6.0.rc0
     *
	 */
    int	writeSingleBlock(in byte[] ProximityCard, byte flags, in byte[] memBlock);
}
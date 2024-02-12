// INtag.aidl
package com.vfi.smartpos.deviceservice.aidl.card_reader;


interface INtagCard {

	/**
     * obtain Ntag Library version message
	 * @return library version message
     * \en_e
     * \code{.java}
     * \endcode
     * @since later 3.1.2
     * @see
	 */
    byte[]	getVersion();

	/**
     * init NTag card(Need to reinitialize when the card is removed or powered off)
	 * @return 0-success other-fail
     * @since later 3.1.2
	 */
    int init();

	/**
     * authenticate through pwd
	 * @return 0-success other-fail
     * @since later 3.1.2
	 */
    int	pwdAuth(in byte[] pwd);

	/**
     * Read 4 pages of data (16 bytes) starting from the specified address
	 * @return 4 pages of data (16 bytes) starting from the specified address
     * @since later 3.1.2
	 */
    byte[]	read(byte addr);

	/**
     * read data from addrStart to addrEnd
	 * @return data of addrStart to addrEnd
     * @since later 3.1.2
	 */
    byte[]	fastRead(byte addrStart, byte addrEnd);

	/**
     * Write a page of data (4 bytes) to the specified address
     * @param  addr - Page address to be written
     * @param  dataBuf - Data to be written (4 bytes)
	 * @return 0-success other-fail
     * @since later 3.1.2
	 */
    int write(byte addr, in byte[] dataBuf);

	/**
     * Read signature data(The signature data is a 32-byte ECC data containing the chip manufacturer’s identification)
	 * @return null-failed
     * @since later 3.1.2
	 */
    byte[]	readSig();

	/**
     * Read counter
	 * @return null-failed
     * @since later 3.1.2
	 */
    byte[]	readCnt();
}
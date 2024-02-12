package com.vfi.smartpos.deviceservice.aidl;

/**
 * <p> the usb-serial device(such as X9, C520H) connect with OTG cable, default set is 115200 8 N 1
 *
 * Insert the OTG cable to X9, connect the X9 or C520 to the OTG cable with micro-usb cable
 */
interface IUsbSerialPort {
    /**
     * <p> check if usb-serial device available
     *
	 * @return true for available, false for no device available
     * @since 1.x.x
	 */
	boolean isUsbSerialConnect();
	/**
     * <p> read buffer
     *
	 * @param buffer the buffer
	 * @param timeout timeout in milliseconds
	 * @return the buffer length read, -1 for failure
     * @since 1.x.x
	 */
	int read(inout byte[] buffer, int timeout);
    /**
     * @brief write data
     *
	 * @param data the buffer want write
	 * @since 1.x.x
	 */
	void write(in byte[] data);
}

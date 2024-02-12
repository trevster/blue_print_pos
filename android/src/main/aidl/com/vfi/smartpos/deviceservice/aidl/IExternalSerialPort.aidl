// IExternalSerialPort.aidl
package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.SerialDataControl;

/**
 * <p> about the serial port on dock ( base )
 */
interface IExternalSerialPort {
    /**
     * <p> set the base Pinpad port function mode.
     * <p> The mode includes
     * <ul>
     *  <li> {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.MODE_TRANSPARENT} </li>
     *  <li> {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.MODE_PP1000V3_PINPAD} </li>
     *  <li> {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.MODE_PP1000V3_CTLS} </li>
     * </ul>
     * <p> default mode is ExternalSerialConst.MODE_TRANSPARENT. This mode will not be lost after power off.
     * <p> Note that: because base Pinpad port has only one, when you set one mode, other mode function interfaces will not be used. unless you reset the mode.
     *
     * @param portMode you can set ExternalSerialConst.MODE_TRANSPARENT, or ExternalSerialConst.MODE_PP1000V3_PINPAD, or ExternalSerialConst.MODE_PP1000V3_CTLS. other value will not be set but will return current pinpan port mode value.
     * @return current pinpad port mode value.
     * @since 1.x.x
     */
     int setExtPinpadPortMode(int portMode);

    /**
     * <p> check if pos connects pinpad successfully?
     *
     * @return {@code true} success. {@code false} fail.
     * @since 1.x.x
     */
    boolean isExternalConnected();

    /**
     * <p> open serial port and set serial port config (including baud rate, data bit, stop bit, parity bit). if the serial port has opend, return true directly.
     *
     * @param portNum : {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_PINPAD} or {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_RS232}.
     * @param dataControl : set serial port config. please see {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst}.
     * @return {@code true} success. {@code false} fail.
     * @since 1.x.x
     */
    boolean openSerialPort(int portNum, in SerialDataControl dataControl);

    /**
     * <p> non-blocking write serial port data.
     *
     * @param portNum : {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_PINPAD} or {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_RS232}.
     * @param writeData : transport writing data buffer
     * @param dataLength : transport writing data length
     * @return the length of the data actually sent. if return 0, means no data was sent. if return negative number, please see {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst}.
     * @since 1.x.x
     */
    int writeSerialPort(int portNum, in byte[] writeData, int dataLength);

    /**
     * <p> non-blocking read serial port data.
     *
     * @param portNum : {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_PINPAD} or {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_RS232}.
     * @param readData : transport reading data buffer
     * @param dataLength : transport reading data length (the length can not be larger than the buffer size)
     * @return the length of the data actually readed; if return 0, means no data was readed. if return negative number, please see {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst}.
     * @since 1.x.x
     */
    int readSerialPort(int portNum, out byte[] readData, int dataLength);

    /**
     * <p> block writing serial port data until timeout.
     *
     * @param portNum : {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_PINPAD} or {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_RS232}.
     * @param writeData : transport writing data buffer
     * @param dataLength : transport writing data length
     * @param timeoutMs : overtime time(unit is milliseconds)
     * @return the length of the data actually sent. if return 0, means no data was sent. if return negative number, please see {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst}.
     * @since 1.x.x
     */
    int safeWriteSerialPort(int portNum, in byte[] writeData, int Length, long timeoutMs);

    /**
     * <p> block reading serial port data until timeout.
     *
     * @param portNum : {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_PINPAD} or {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_RS232}.
     * @param readData : transport reading data buffer
     * @param dataLength : transport reading data length (the length can not be larger than the buffer size)
     * @param timeoutMs : overtime time(unit is milliseconds)
     * @return the length of the data actually readed; if return 0, means no data was readed. if return negative number, please see {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst}.
     * @since 1.x.x
     */
    int safeReadSerialPort(int portNum, out byte[] readData, int Length, long timeoutMs);

    /**
     * <p> close serial port.
     *
     * @param portNum : {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_PINPAD} or {@link com.vfi.smartpos.deviceservice.aidl.ExternalSerialConst.PORT_RS232}.
     * @since 1.x.x
     */
    void closeSerialPort(int portNum);

    /**
     * clear buffer
     * @param portNum
     * @return
     */
    boolean clearInputBuffer(int portNum);
}

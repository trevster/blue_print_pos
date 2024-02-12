// ISmartCardReaderEx.aidl
package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.SmartCardExSearchListener;
/**
 * Created by Simon on 2019/3/25.
 * @since >= 2.0.9
 */
interface ISmartCardReaderEx {


    /**
     *
     * @param listener, the callback listener for result
     * @param timeout, the timeout in second(s)
     * @since >= 2.0.9
     * @see SmartCardExSearchListener
     * @see #powerUp() for search card success
     */
    void search(SmartCardExSearchListener listener, int timeout);

    /**
     *
     * @since >= 2.0.9
     */
    void stopSearch();

    /**
     * @return true for success, false for failure
     * @brief power up the card
     * @since >= 2.0.9
     * @see #powerDown()
     */
	boolean powerUp();

    /**
     * @return true for success, false for failure
     * @brief power down the card
     * @since >= 2.0.9
     * @see #powerUp()
     */
	boolean powerDown();

    /**
     *
     * @param areaType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java for defines
     * @param credentials, the password, new byte[]{0xff,0xff,0xff}
     * @return true for success
     * @since >= 2.0.9
     * @see ConstISmartCardReaderEx.AreaType
     * @see #certificationRemove(byte, byte[])
     */
	boolean certificationLoad(byte areaType, in byte[] credentials);

    /**
     *
     * @param areaType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java for defines
     * @param credentials, set new password, new byte[]{0xff,0xff,0xff}
     * @return true for success
     * @since >= 2.0.9
     * @see ConstISmartCardReaderEx.CommType
     * @see #certificationLoad(byte, byte[])
     */
    boolean certificationRemove(byte areaType, in byte[] credentials);

    /**
     *
     * @param areaType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java for defines
     * @param offset
     * @param length
     * @return null for errors, others for data
     * @since >= 2.0.9
     * @see ConstISmartCardReaderEx.AreaType
     * @see #write(byte, int, byte[])
     */
	byte[] read(byte areaType, int offset, int length);
    /**
     *
     * @param areaType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java for defines
     * @param offset
     * @param data
     * @return
     * @since >= 2.0.9
     * @see ConstISmartCardReaderEx.AreaType
     * @see #read(byte, int, int)
     */
	boolean write(byte areaType, int offset, in byte[] data);

    /**
     *
     * @param commType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java, class ConstISmartCardReaderEx.CommType for defines
     * @param areaType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java, class ConstISmartCardReaderEx.AreaType for defines
     * @param offset
     * @param length
     * @param data
     * @return Bundle, code for success or error refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java, class ConstISmartCardReaderEx.communicate.returnCode for defines
     * response for response from communication
     * @since >= 2.0.9
     * @see ConstISmartCardReaderEx.CommType
     * @see ConstISmartCardReaderEx.AreaType
     * @see ConstISmartCardReaderEx.communicate.returnCode
     */
	Bundle communicate(byte commType, byte areaType, int offset, int length, in byte[] data);


	/**
     * check logic card status
	 * @return 0x00-card not exist, 0x01-card exist
     * @since 3.11.3
     */
    byte checkLogicCardStatus();

    /**
     * Set Logic card type. It is for AT24Cxx card only now.
     * If the card type is AT24C16, setLogicalCardtype must be set before before search0) , if not set,  default is AT24C64
     * param cardType - refer to ConstISmartCardReaderEX.AT24Cardtype,
     * @throws RemoteException
     */
    boolean setLogicalCardType(byte cardType);
}

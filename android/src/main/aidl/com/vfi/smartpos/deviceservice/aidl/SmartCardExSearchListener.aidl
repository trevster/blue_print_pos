package com.vfi.smartpos.deviceservice.aidl;

/**
 * Created by Simon on 2019/3/26.
 * @since >= 2.0.9
 */
interface SmartCardExSearchListener {

    /**
     *
     * @param cardType, refer the com/vfi/smartpos/deviceservice/constdefine/ConstISmartCardReaderEx.java, class ConstISmartCardReaderEx.CardType for defines
     * @since >= 2.0.9
     * @see ConstISmartCardReaderEx.CommType
     */
    void onSuccess(int cardType);
    /**
     *
     * @param errorCode, -1 for error
     * @since >= 2.0.9
     */
    void onFail( int errorCode);
    /**
     *
     * @since >= 2.0.9
     */
    void onTimeout();
}

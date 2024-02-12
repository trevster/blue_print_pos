package com.vfi.smartpos.deviceservice.aidl;

/**
 * the listener while input PIN
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface PinInputListener {
    /**
     * on input (key press)
     *
     * @param len the length of the PIN inputted
     * @param key the mask key
     */
    void onInput(int len, int key);
    
    /**
     * on confirm the PIN
     *
     * @param data the PIN number, null if no pin inputed
     * @param isNonePin ture if no pin inputted
     */
    void onConfirm(in byte[] data, boolean isNonePin);

    /**
     * on cancel
     */
    void onCancel();
    
    /**
     * on error
     *
     * @param errorCode the error code<BR>
     * errorCode:<BR>
     * -1:input execption <BR>
     * -2:input time out <BR>
     * -3:plain text is null <BR>
     * -4:encrypt error <BR>
     * -5:cipher text is null <BR>
     * 0xff:other error <BR>
     */
    void onError(int errorCode);
}

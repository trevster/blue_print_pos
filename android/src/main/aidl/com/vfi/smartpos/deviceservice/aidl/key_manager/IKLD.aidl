package com.vfi.smartpos.deviceservice.aidl.key_manager;

/**
 * Created by RuoYi
 * @since >= 3.x.x
 */

interface IKLD {

    /**
     * keyStore TR34 Payload
     * @param data json file that download from VHQ, then convert to byte data.
     * @return 0 - success, other - fail
     */
    int keyStoreTR34Payload(in byte[] data);

    /**
     * KBPK and Master for AES are shared the same block & slots
     * So, please use them without conflict
     * @param slot the slot to inject the kbkp
     * @param kbpk the kbpk to be injected
     * @param extend KEY: overwrite(boolean), overwrite if not empty, otherwise return -1.
     *               KEY: checkValue(byte[]), the check value to verify the kbpk.
     * @return 0, success.
     *          -1, slot was injected a key, but not set overwrite or overwrite set to false.
     *          -2, inject failed, please if kbpk is correct or checkValue is correct.
     * @throws RemoteException
     */
    int loadKBPK( in int slot, in String kbpk, in Bundle extend );

    /**
     *
     * @param slot the slot to inject the key.
     * @param data the data to be injected.
     * @param extend KEY KBPKSlot(int), the kbpk slot to decrypt the TR31.
     * @return 0 for success, others for error
     *              * 0x42 : Key length error
     *              * 0x64 : Other error
     *              * 0xA2 : invalid TR31 block
     * @throws RemoteException
     */
    int loadTR31Payload( in int slot, in String data, in Bundle extend );
}

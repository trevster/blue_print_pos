// IWirelessBaseHelper.aidl
package com.vfi.smartpos.deviceservice.aidl;
import com.vfi.smartpos.deviceservice.aidl.WirelessConnectListener;
import com.vfi.smartpos.deviceservice.aidl.ConnectReceiverListener;


// Declare any non-default types here with import statements

interface IWirelessBaseHelper {

    /**
     * @param bundle extend for the future
     * @return bundle
     * <ul> null or no key, value set means base is not connected, or cannot get the details
     * <li> keys are defined from ConstWirelessBase</li>
     * </ul>
     * @throws RemoteException
     */
    Bundle getBaseInfo(in Bundle bundle);

    /**
     * @param bundle - if null or doesn't contain a key/value, then try to connect the last connected deviceInfo
     *               <ul> key - value. Keys defined from ConstWirelessBase.
     *               <li> BaseSN is requested, others are not</li>
     *               </ul>
     * @throws RemoteException
     */
    void bindBase(in Bundle bundle);


    /**
     * This API is for unbind with a base, and need set new BaseSN to bindBase with another one
     * @return
     * <ul>
     * <li>
     * </ul>
     * @throws RemoteException
     */
    int unbindBase();

    /**
     * @param timeout 0~255, timeout >= 20, than it will try to connect / bind the base if no connected.
     *                otherwise, only get the connect status.
     * @param wirelessConnectListener , null for blocking the API till connected or timeout;
     *                                otherwise, it's none-blocking, and wirelessConnectListener tells the result
     * @return while none-blocking, 0 means processing;
     *         while blocking, 0 means connected, -1 for timeout, others for errors
     *
     * @throws RemoteException
     */
    int connectStatus(int timeout, WirelessConnectListener wirelessConnectListener);

     /**
      * @param ConnectReceiverListener, listen to DX30 base connection/disconnection broadcasts
      * only support Korea ROM
      */
    void connectReceiver(ConnectReceiverListener connectReceiverListener);

}
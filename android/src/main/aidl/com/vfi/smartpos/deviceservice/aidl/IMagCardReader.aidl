package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.MagCardListener;

/**
 * the object of IMagCardReader
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface IMagCardReader {
	/**
     * search card, non-block method
     *
	 * @param timeout timeout of the search, second
	 * @param listener the callback listener whild card swiped
     * @since 1.x.x
     * @see com.vfi.smartpos.deviceservice.aidl.MagCardListener
	 */
	void searchCard(int timeout, MagCardListener listener);
	
	/**
     * stop search
     *
     * @since 1.x.x
	 */
	void stopSearch();

    /**
     * default is 7, enable track1 track2 and track3
     * @param trkNum 1byte, bit0-track1, bit1-track2, bit2-track3
     * @throws RemoteException
     */
	void enableTrack(int trkNum);
}

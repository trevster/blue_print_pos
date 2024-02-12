package com.vfi.smartpos.deviceservice.aidl;

import com.vfi.smartpos.deviceservice.aidl.PinInputListener;
import com.vfi.smartpos.deviceservice.aidl.PinKeyCoorInfo;

/**
 * the object of X990Pinpad plain keyboard
 */
interface IX990Pinpad {

    /**
     * start X990Pinpad keyboard input
     *
     * @param param the parameter
     * <ul>
     * <li>timeout(int) the timeout, second</li>
     * </ul>
     * @param listener the call back listener
     * @return
	 * @since 1.x.x
     */
	void startKeyboardInput(in Bundle param, PinInputListener listener);

    boolean endInputPin();
}

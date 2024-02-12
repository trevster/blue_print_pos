package com.vfi.smartpos.deviceservice.aidl;

/**
 * the object of beeper
 * @author Kai.L@verifone.cn, Chao.L@verifone.cn
 */
interface IBeeper {
	/**
     * start beep
	 * <p>Will not beep if setting with 0. It's a non-block method.<br>
	 * @param msec the period of beeping, millisecond.
	 * @since 1.x.x
	 */
	void startBeep(int msec);

	/**
     * stop beep
     * <p>beep will stop after stopBeep be called.<br>
	 * @since 1.x.x
	 */
	void stopBeep();

	/**
     * @brief  start beep
     *
     * Will not beep if setting with 0.
     * It's a non-block method.
     * @param msec the period of beeping, millisecond(200 is minimum).
     * @param bundle
     * <ul>
     * <li>HZ(int) the hz of beeping, default value is 850(scope:20~20000)</li>
     * </ul>
	 * @since 1.x.x
     */
    void startBeepWithConfig(int msec, in Bundle bunble);

}

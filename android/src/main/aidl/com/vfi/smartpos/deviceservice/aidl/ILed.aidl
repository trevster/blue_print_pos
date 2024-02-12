package com.vfi.smartpos.deviceservice.aidl;

/**
 * the object of LED
 * @author kai.l@verifone.cn
 */
interface ILed {
    /**
     * turn on the led
     * @param led
     * <ul>
     * <li> 1 - the blue</li>
     * <li> 2 - the yellow</li>
     * <li> 3 - the green</li>
     * <li> 4 - the red</li>
     * </ul>
     * @since 1.x.x
     */
	void turnOn(int led);

    /**
     * turn off the led
     * @param led
     * <ul>
     * <li> 1 - the blue</li>
     * <li> 2 - the yellow</li>
     * <li> 3 - the green</li>
     * <li> 4 - the red</li>
     * </ul>
     * @since 1.x.x
     */
	void turnOff(int led);


    /**
     * control led
     * @param led 0x01-blue, 0x02-green, 0x04-yellow, 0x08-red
     * @param status status 0-close 1-open
     * @since 1.x.x
     */
	void ledControl(byte led, byte status);
}


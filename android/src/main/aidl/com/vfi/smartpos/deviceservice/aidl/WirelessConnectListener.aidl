// WirelessConnectListener.aidl
package com.vfi.smartpos.deviceservice.aidl;

// Declare any non-default types here with import statements

interface WirelessConnectListener {
	void onSuccess();
	void onTimeout();
	void onError(int errorCode);
}
// UpdateListener.aidl
package com.verifone.baseconnect;

// Declare any non-default types here with import statements

interface UpdateListener {


    void onProgress(float percent);

    void onResult(int code);
}

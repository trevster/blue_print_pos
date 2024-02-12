// StateListener.aidl
package com.verifone.baseconnect;

// Declare any non-default types here with import statements

interface StateListener {

//00：操作成功
//10:设备搜索
//11:链路请求连接
//12:请求登入设备
    void onState(int code);

}

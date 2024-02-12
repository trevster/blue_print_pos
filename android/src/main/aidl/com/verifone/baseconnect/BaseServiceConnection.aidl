// IMyAidlInterface.aidl
package com.verifone.baseconnect;

import com.verifone.baseconnect.BindInfo;
import com.verifone.baseconnect.UpdateListener;
import com.verifone.baseconnect.StateListener;
import com.verifone.baseconnect.SavedInfo;
// Declare any non-default types here with import statements

interface BaseServiceConnection {

    /**
    * 获取底座设备信息
    */
    int getBaseInfo(out byte[] info); //int 结果大于0为info数组长度，失败为负数

    /**
    *获取本地保存的信息。
    */
    int getSavedInfo(out SavedInfo info);
    /**
    * 底座绑定
    */
    void bindBase(in BindInfo info,StateListener listener);

    /**
    * 底座解绑
    */
    int unbindBase();

    /**
    * 升级底座设备的固件
    */
    void updateTerminal(String filePath,UpdateListener listener);

    /**
    *  获取连接状态
    */
    int getConnectState();

    /**
    *  连接或断开连接操作
    */
    void connectBase(int operation,StateListener listener);

    /**
    * 释放监听状态
    */
    void realeaseListener();

    /**
    * 设置设备属性信息
    */
    int setBaseInfo(in byte[] info);

    /**
    * 底座设备重启
    */
    int restartBase();

    /**
    * 获取挂载结果
    */
    byte getAttachResult();

    /**
    * 设置底座状态监听
    */
    void setBaseStateListener(StateListener listener);
}

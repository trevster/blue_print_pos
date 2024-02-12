package com.verifone.baseconnect;

import android.os.Parcel;
import android.os.Parcelable;

/***
 *  绑定信息类
 */
public class BindInfo implements Parcelable {

    private String bindingSN; //绑定设备的SN
    private String bindingPN; //绑定设备的PN
    private String bindingWiFiMac; //绑定设备的WiFi Mac
    private String deviceSN; //底座的SN
    private String devicePN; //底座的PN
    private String deviceWiFiMac; //底座的WiFi Mac
    private boolean isBinding; //true：建立登入绑定  false：建立临时绑定

    public String getBindingSN() {
        return bindingSN;
    }

    public void setBindingSN(String bindingSN) {
        this.bindingSN = bindingSN;
    }

    public String getBindingPN() {
        return bindingPN;
    }

    public void setBindingPN(String bindingPN) {
        this.bindingPN = bindingPN;
    }

    public String getBindingWiFiMac() {
        return bindingWiFiMac;
    }

    public void setBindingWiFiMac(String bindingWiFiMac) {
        this.bindingWiFiMac = bindingWiFiMac;
    }

    public String getDeviceSN() {
        return deviceSN;
    }

    public void setDeviceSN(String deviceSN) {
        this.deviceSN = deviceSN;
    }

    public String getDevicePN() {
        return devicePN;
    }

    public void setDevicePN(String devicePN) {
        this.devicePN = devicePN;
    }

    public String getDeviceWiFiMac() {
        return deviceWiFiMac;
    }

    public void setDeviceWiFiMac(String deviceWiFiMac) {
        this.deviceWiFiMac = deviceWiFiMac;
    }

    public boolean isBinding() {
        return isBinding;
    }

    public void setBinding(boolean binding) {
        isBinding = binding;
    }

    public BindInfo() {
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.bindingSN);
        dest.writeString(this.bindingPN);
        dest.writeString(this.bindingWiFiMac);
        dest.writeString(this.deviceSN);
        dest.writeString(this.devicePN);
        dest.writeString(this.deviceWiFiMac);
        dest.writeByte(this.isBinding ? (byte) 1 : (byte) 0);
    }

    protected BindInfo(Parcel in) {
        this.bindingSN = in.readString();
        this.bindingPN = in.readString();
        this.bindingWiFiMac = in.readString();
        this.deviceSN = in.readString();
        this.devicePN = in.readString();
        this.deviceWiFiMac = in.readString();
        this.isBinding = in.readByte() != 0;
    }

    public static final Creator<BindInfo> CREATOR = new Creator<BindInfo>() {
        @Override
        public BindInfo createFromParcel(Parcel source) {
            return new BindInfo(source);
        }

        @Override
        public BindInfo[] newArray(int size) {
            return new BindInfo[size];
        }
    };
}

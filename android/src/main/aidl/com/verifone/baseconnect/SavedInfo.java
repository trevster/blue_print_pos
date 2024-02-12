package com.verifone.baseconnect;

import android.os.Parcel;
import android.os.Parcelable;

public class SavedInfo implements Parcelable {

    private String baseSN;

    public String getBaseSN() {
        return baseSN;
    }

    public void setBaseSN(String baseSN) {
        this.baseSN = baseSN;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.baseSN);
    }

    public void readFromParcel(Parcel in){
        this.baseSN = in.readString();
    }

    public SavedInfo() {
    }

    protected SavedInfo(Parcel in) {
        this.baseSN = in.readString();
    }

    public static final Creator<SavedInfo> CREATOR = new Creator<SavedInfo>() {
        @Override
        public SavedInfo createFromParcel(Parcel source) {
            return new SavedInfo(source);
        }

        @Override
        public SavedInfo[] newArray(int size) {
            return new SavedInfo[size];
        }
    };
}

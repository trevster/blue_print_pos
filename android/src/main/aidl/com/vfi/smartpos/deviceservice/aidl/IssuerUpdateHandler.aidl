package com.vfi.smartpos.deviceservice.aidl;

/**
 * the listener of Issuer Update request
 */
interface IssuerUpdateHandler {
    /**
     * set callback for request issuer update script(CTLS request second tap)
     * @since 2.11.0
     */
    void onRequestIssuerUpdate();
}


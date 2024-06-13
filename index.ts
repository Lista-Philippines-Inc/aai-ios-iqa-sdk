import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNAAIIOSIQASDK } = NativeModules;

export default class AAIIOSIQASDK {
    static initSDK(paramsConfig, uiConfig) {
        RNAAIIOSIQASDK.initSDK(paramsConfig, uiConfig)
    }

    static setLicenseAndCheck(license, callback) {
        RNAAIIOSIQASDK.setLicenseAndCheck(license, callback)
    }

    static showSDKPage(callback) {
        this._callback = callback

        const sdkEmitter = new NativeEventEmitter(NativeModules.RNAAIIOSIQASDKEvent);
        this._sdkEventListener = sdkEmitter.addListener('RNAAIIOSIQASDKEvent', (info) => {
        this._sdkEventCallback[info.name](info.body)
        });
    
        RNAAIIOSIQASDK.showSDKPage()
    }

    static sdkVersion(callback) {
        RNAAIIOSIQASDK.sdkVersion(callback)
    }

    static _sdkEventListener = null
    static _callback = {}

    // Callback
    static _sdkEventCallback = {
        onDetectionComplete: (info) => {
            // {"success": "true", "cardImg": "base64Str...", "IDVID": "xxx", "transactionId": "xxx", "pictureType": "takePhoto"}
            if (typeof(this._callback === "function")) {
                this._callback(info)
            }
            
            if (this._sdkEventListener) {
                this._sdkEventListener.remove()
            }
        }
    }
}

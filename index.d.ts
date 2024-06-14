import { NativeEventEmitter } from 'react-native';

export interface ParamsConfig {
  // Define the structure of ParamsConfig based on what your JS code expects.
}

export interface UIConfig {
  // Define the structure of UIConfig based on what your JS code expects.
}

export interface License {
  // Define the structure of License based on what your JS code expects.
}

export interface SDKEventInfo {
  name: string;
  body: any;
}

export interface DetectionCompleteInfo {
  success: string;
  cardImg: string;
  IDVID: string;
  transactionId: string;
  pictureType: string;
}

export default class AAIIOSIQASDK {
  static initSDK(paramsConfig: ParamsConfig, uiConfig: UIConfig): void;
  static setLicenseAndCheck(license: License, callback: (response: any) => void): void;
  static showSDKPage(callback: (info: DetectionCompleteInfo) => void): void;
  static sdkVersion(callback: (version: string) => void): void;
  private static _sdkEventListener: ReturnType<NativeEventEmitter['addListener']> | null;
  private static _callback: Record<string, (info: DetectionCompleteInfo) => void>;
  private static _sdkEventCallback: {
    onDetectionComplete: (info: DetectionCompleteInfo) => void;
  };
}

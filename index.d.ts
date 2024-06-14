declare module 'AAIIOSIQASDK' {
    type ParamsConfig = {
        // Define the expected shape of paramsConfig here
        // For example:
        // key1: string;
        // key2: number;
    };

    type UIConfig = {
        // Define the expected shape of uiConfig here
        // For example:
        // theme: string;
        // colorScheme: string;
    };

    type License = string;

    type Info = {
        success: string;
        cardImg: string;
        IDVID: string;
        transactionId: string;
        pictureType: string;
    };

    type Callback = (info: Info) => void;

    export default class AAIIOSIQASDK {
        static initSDK(paramsConfig: ParamsConfig, uiConfig: UIConfig): void;
        static setLicenseAndCheck(license: License, callback: Callback): void;
        static showSDKPage(callback: Callback): void;
        static sdkVersion(callback: (version: string) => void): void;
        private static _sdkEventListener: any;
        private static _callback: Record<string, Callback>;
        private static _sdkEventCallback: {
            onDetectionComplete: (info: Info) => void;
        };
    }
}

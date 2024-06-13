/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {useState, useEffect} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  Button
} from 'react-native';

import AAIIOSIQASDK from 'react-native-aaiios-iqa-sdk';


const tapTestButton = () => {
  // Init SDK
  var paramsConfig = {
    //(Required)
    // Regional ISO code, you can use 2-digit or 3-digit shortcode, see Wikipedia https://zh.wikipedia.org/wiki/ISO_3166-1
    "region": "ID",

    //(Required)
    // The card types currently supported by sdk are as follows:
    // "IDCARD" or "ID_CARD", "DRIVINGLICENSE" or "DRIVING_LICENSE", "UMID", "SSS", "TIN", "PASSPORT", "VOTERID", "NATIONALID", "PRC", "PAGIBIG", "POSTALID"
    "cardType": "IDCARD",

    //(Required)
    // "FRONT", "BACK"
    "cardSide": "FRONT",

    // --- All fields below are optional --
    // You can uncomment these codes to enable the specific configuration.

    //(Optional)
    // Detection timeout interval in seconds. Default is 20s.
    // "detectionTimeoutInterval": 20,

    //(Optional)
    // The duration of the alert view displayed when SDK are about to enter the photo mode,
    // the default is 3s, if set to 0, the alert view will not be displayed.
    // "takePhotoAlertViewTimeoutInterval": 3,

    //(Optional)
    // Whether to play a prompt audio during the detection process. Default is YES.
    // "soundPlayEnable": true,

    //(Optional)
    // Whether to return null value on fields that recognized as empty, defaults is NO.
    // "returnEmptyOfOCR": false,

    //(Optional)
    // Specifies the language lproj file to be loaded by the SDK. Available values are: "en", "id", "zh-Hans".
    // If this value is not set, the system language will be used by default. If the system language is not supported,
    // English will be used.
    // "languageLprojName": "id",

    //(Optional)
    // You can pass your user unique identifier to us, we will establish a mapping relationship
    // based on the identifier. It is helpful for us to check the log when encountering problems.
    // "userId": "your user unique identifier",

    //(Optional)
    // Specify the operating mode of the SDK.
    // The SDK can have different operating modes, such as real-time scanning mode, photo mode, default mode(Scanning + Photo).
    // Available values are: "Default", "Scanning", "Photo". Default is 'Default'.
    // "operatingMode": "Default"
  }

  //(Optional) All fields in this configuration are optional. 
  // You can uncomment these codes to enable the specific configuration.
  var uiConfig = {
    // The left and right margin on x-axis of cameraView when device in portrait mode.
    // "cameraViewMarginLRInPortraitMode": 12,

    // Whether to show the flip camera button. Default is YES.
    // "flipCameraBtnVisible": false,

    // Whether to show the light button. Default is YES.
    // "lightBtnVisible": false,

    // Whether the show the timer label in the upper right corner of the view. Default is YES.
    // "timerLabelVisible": true,

    // Navigation bar title text color. Default is #333333.
    // "navBarTitleTextColor": "#333333",

    // Navigation bar background color. Default is clear color.
    // "navBarBackgroundColor": "#00000000",

    // Default is Default. Available values are: "Default", "LightContent"
    // "statusBarStyle": "Default",

    // Page background color. Default is #F6F6F5.
    // "pageBackgroundColor": "#F6F6F5",

    // Viewfinder(Camera overlay view) color. Default is #333333.
    // "viewfinderColor": "#333333",

    // Primary text color. Default is #333333.
    // "primaryTextColor": "#333333",

    // Submit & Retake button theme color. Default is #30B043 and alpha is 0.5.
    // "toolButtonThemeColor": "#30B04380",

    // The bottom tip view text color in take photo mode. Default is #333333.
    // "takePhotoTipTextColor": "#333333",

    // The bottom tip view background color in take photo mode. Default is #E0E0E0 and alpha is 0.8.
    // "takePhotoTipBackgroundColor": "#E0E0E0CC",
    
    // The bottom tip view background color in preview photo mode. Default is #E0E0E0 and alpha is 0.8.
    // "previewPhotoTipBackgroundColor": "#E0E0E0CC",

    // The bottom tip view text color in preview photo mode. Default is #333333.
    // "previewPhotoTipTextColor": "#333333",

    // Interface orientation when the SDK is displayed.  Default is Auto. Available values are: "Auto", "Landscape", "Portrait"
    // "orientation": "Auto"
  }

  AAIIOSIQASDK.initSDK(paramsConfig, uiConfig)

  // The license content is obtained by your server calling our openapi (auth-license api).
  let licenseStr = "your-license-str"
  AAIIOSIQASDK.setLicenseAndCheck(licenseStr, (licenseResult) => {
      if (licenseResult === "SUCCESS") {
          // Show SDK Page.
          showSDKPage()
      } else {
          // Print error message ...
          if (licenseResult === "LICENSE_EXPIRE") {
              console.log("LICENSE_EXPIRE: Please call your server's api(auth-license api) to generate a new license")
          } else if (licenseResult === "APPLICATION_ID_NOT_MATCH") {
              console.log("APPLICATION_ID_NOT_MATCH: Please pass your applicationId(the bundle identifier of the application) when calling the auth-license api")
          } else {
              console.log('setLicenseAndCheck failed:, ', licenseResult)
          }
      }
  })
}

const showSDKPage = () => {
  AAIIOSIQASDK.showSDKPage((result) => {
      console.log('>>>> onDetectionComplete')
      console.log(result)
      if (result.success) {
          var IDVID = result.IDVID
          var cardImgBase64Str = result.cardImg

          /**
           * This field is used to indicate which mode the image is from, and it has two values: "takePhoto" and "scan".
           * "takePhoto" mean `cardImg` is from photo mode, "scan" mean `cardImg` is from scan mode.
           */
          var pictureType = result.pictureType
      } else {
          /**
           *
           * Error code list:
           *
           * CAMERA_OPEN_FAILED
           * USER_GIVE_UP
           * DEVICE_NOT_SUPPORT
           * CAMERA_PERMISSION_DENIED
           * MODEL_ERROR
           * NETWORK_REQUEST_FAILED
           * NO_CARD
           * TOO_SMALL_CARD
           * EDGE_CROSS
           * CARD_POOR_QUALITY
           * SCAN_TIMEOUT (Note this code appears only when you set the `operatingMode` of `paramsConfig` to "Scanning".)
           * ...(other code)
           */
          if (result.errorCode) {
              var errorCode = result.errorCode
          }
          
          if (result.errorMsg) {
              var errorMsg = result.errorMsg
          }
          
          if (result.transactionId) {
              var transactionId = result.transactionId
          }
          
      }
  })

}


const App = () => {
  const [sdkVersion, setSDKVersion] = useState('-');

  useEffect(() => {
    AAIIOSIQASDK.sdkVersion((value) => setSDKVersion(value))
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.instructions}>SDK Version: {sdkVersion}</Text>
      <Button
        onPress={()=> {
          tapTestButton()
        }}
        title="show iqa view"
        color="#841584"
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  sdkContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  }
});

export default App;

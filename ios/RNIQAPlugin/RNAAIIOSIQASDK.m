#import "RNAAIIOSIQASDK.h"
#import "RNAAIIOSIQASDKEvent.h"
@import AAIGlobalIQASDK;

@interface RNAAIIOSIQASDK()<AAIGlobalIQADelegate>

@end
@implementation RNAAIIOSIQASDK

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t)methodQueue
{
   return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)params uiConfig:(nullable NSDictionary *)uiConfig)
{
    if (params == nil) {
        return;
    }

    // Card type
    NSString *cardTypeStr = [params[@"cardType"] uppercaseString];
    AAIIQACardType cardType;
    if ([cardTypeStr isEqualToString: @"IDCARD"] || [cardTypeStr isEqualToString: @"ID_CARD"]) {
        cardType = AAIIQACardTypeIDCard;
    } else if ([cardTypeStr isEqualToString: @"DRIVINGLICENSE"] || [cardTypeStr isEqualToString: @"DRIVING_LICENSE"]) {
        cardType = AAIIQACardTypeDrivingLicense;
    } else if ([cardTypeStr isEqualToString: @"UMID"]) {
        cardType = AAIIQACardTypeUMID;
    } else if ([cardTypeStr isEqualToString: @"SSS"]) {
        cardType = AAIIQACardTypeSSS;
    } else if ([cardTypeStr isEqualToString: @"TIN"]) {
        cardType = AAIIQACardTypeTIN;
    } else if ([cardTypeStr isEqualToString: @"PASSPORT"]) {
        cardType = AAIIQACardTypePassport;
    } else if ([cardTypeStr isEqualToString: @"VOTERID"]) {
        cardType = AAIIQACardTypeVOTERID;
    } else if ([cardTypeStr isEqualToString: @"NATIONALID"]) {
        cardType = AAIIQACardTypeNATIONALID;
    } else if ([cardTypeStr isEqualToString: @"PRC"]) {
        cardType = AAIIQACardTypePRC;
    } else if ([cardTypeStr isEqualToString: @"PAGIBG"] || [cardTypeStr isEqualToString: @"PAGIBIG"]) {
        cardType = AAIIQACardTypePAGIBIG;
    } else if ([cardTypeStr isEqualToString: @"POSTALID"]) {
        cardType = AAIIQACardTypePOSTALID;
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"Unsupported card type: %@", cardTypeStr];
        NSLog(@"%@", errMsg);
        return;
    }

    // Card Side
    NSString *cardSideStr = [params[@"cardSide"] uppercaseString];
    AAIIQACardSide cardSide;
    if ([cardSideStr isEqualToString: @"FRONT"]) {
        cardSide = AAIIQACardSideFront;
    } else if ([cardSideStr isEqualToString: @"BACK"]) {
        cardSide = AAIIQACardSideBack;
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"Unsupported card side: %@", cardSideStr];
        NSLog(@"%@", errMsg);
        return;
    }

    AAIGlobalIQAConfig *config = [AAIGlobalIQAConfig initWithRegion:params[@"region"] cardType:cardType cardSide:cardSide];

    // Other config
    NSNumber *dectionTI = [self valueForKey:@"detectionTimeoutInterval" defaultValue: nil ofDict:params];
    if ([dectionTI isKindOfClass:[NSNumber class]]) {
        config.detectionTimeoutInterval = [dectionTI integerValue];
    }

    NSNumber *takePhotoTI = [self valueForKey:@"takePhotoAlertViewTimeoutInterval" defaultValue: nil ofDict:params];
    if ([takePhotoTI isKindOfClass:[NSNumber class]]) {
        config.takePhotoAlertViewTimeoutInterval = [takePhotoTI integerValue];
    }

    NSNumber *soundPlayEnable = [self valueForKey:@"soundPlayEnable" defaultValue: nil ofDict:params];
    if ([soundPlayEnable isKindOfClass:[NSNumber class]]) {
        config.soundPlayEnable = [soundPlayEnable boolValue];
    }

    NSNumber *returnEmptyOfOCR = [self valueForKey:@"returnEmptyOfOCR" defaultValue: nil ofDict:params];
    if ([returnEmptyOfOCR isKindOfClass:[NSNumber class]]) {
        config.returnEmptyOfOCR = [returnEmptyOfOCR boolValue];
    }

    NSString *lanLprojName = [self valueForKey:@"languageLprojName" defaultValue: nil ofDict:params];
    if ([lanLprojName isKindOfClass:[NSString class]]) {
        config.languageLprojName = lanLprojName;
    }

    NSString *opModeStr = [self valueForKey:@"operatingMode" defaultValue: nil ofDict:params];
    if (opModeStr != nil && [opModeStr isKindOfClass:[NSString class]]) {
        if ([opModeStr isEqualToString:@"Default"]) {
            config.operatingMode = AAIIQAOperatingModeDefault;
        } else if ([opModeStr isEqualToString:@"Scanning"]) {
            config.operatingMode = AAIIQAOperatingModeScanning;
        } else if ([opModeStr isEqualToString:@"Photo"]) {
            config.operatingMode = AAIIQAOperatingModePhoto;
        }
    }
    
    // UI config
    if (uiConfig != nil && [uiConfig isKindOfClass:[NSDictionary class]]) {
        [self configUI:config.uiConfig configInfo: uiConfig];
    }
    
    config.delegate = self;
    config.callbackAfterPageDismissed = YES;
    [AAIGlobalIQASDK initWithConfig:config];

    // Bind user id
    NSString *userId = [self valueForKey:@"userId" defaultValue: nil ofDict:params];
    if (userId != nil && [userId isKindOfClass:[NSString class]]) {
        [AAIGlobalIQASDK bindUser:userId];
    }
}

RCT_EXPORT_METHOD(setLicenseAndCheck:(NSString *)license callback:(RCTResponseSenderBlock)callback)
{
    NSString *result = [AAIGlobalIQASDK setLicenseAndCheck:license];
    callback(@[result]);
}

RCT_EXPORT_METHOD(sdkVersion:(RCTResponseSenderBlock)callback)
{
    NSString *version = [AAIGlobalIQASDK sdkVersion];
    callback(@[version]);
}

RCT_EXPORT_METHOD(showSDKPage)
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootVC == nil) {
        NSString *errMsg = [NSString stringWithFormat:@"Could not find a valid rootViewController"];
        NSLog(@"%@", errMsg);
        return;
    }
    [AAIGlobalIQASDK startWithRootVC:rootVC];
}

- (void)configUI:(AAIGlobalIQAUIConfig *)uiConfig configInfo:(NSDictionary *)configInfo
{
    NSNumber *cameraViewMarginLeft = [self valueForKey:@"cameraViewMarginLRInPortraitMode" defaultValue: nil ofDict:configInfo];
    if ([cameraViewMarginLeft isKindOfClass:[NSNumber class]]) {
        uiConfig.cameraViewMarginLRInPortraitMode = cameraViewMarginLeft;
    }

    NSNumber *flipCameraBtnVisible = [self valueForKey:@"flipCameraBtnVisible" defaultValue: nil ofDict:configInfo];
    if ([flipCameraBtnVisible isKindOfClass:[NSNumber class]]) {
        uiConfig.flipCameraBtnVisible = [flipCameraBtnVisible boolValue];
    }

    NSNumber *lightBtnVisible = [self valueForKey:@"lightBtnVisible" defaultValue: nil ofDict:configInfo];
    if ([lightBtnVisible isKindOfClass:[NSNumber class]]) {
        uiConfig.lightBtnVisible = [lightBtnVisible boolValue];
    }

    NSNumber *timerLabelVisible = [self valueForKey:@"timerLabelVisible" defaultValue: nil ofDict:configInfo];
    if ([timerLabelVisible isKindOfClass:[NSNumber class]]) {
        uiConfig.timerLabelVisible = [timerLabelVisible boolValue];
    }
    
    NSString *navBarTitleTextColorStr = [self valueForKey:@"navBarTitleTextColor" defaultValue: nil ofDict:configInfo];
    UIColor *navBarTitleTextColor = [self colorFromHexStr: navBarTitleTextColorStr];
    if (navBarTitleTextColor) {
        uiConfig.navBarTitleTextColor = navBarTitleTextColor;
    }

    NSString *navBarBackgroundColorStr = [self valueForKey:@"navBarBackgroundColor" defaultValue: nil ofDict:configInfo];
    UIColor *navBarBackgroundColor = [self colorFromHexStr: navBarBackgroundColorStr];
    if (navBarBackgroundColor) {
        uiConfig.navBarBackgroundColor = navBarBackgroundColor;
    }

    NSString *statusBarStyle = [self valueForKey:@"statusBarStyle" defaultValue: nil ofDict:configInfo];
    if (statusBarStyle != nil && [statusBarStyle isKindOfClass:[NSString class]]) {
        if ([statusBarStyle isEqualToString:@"Default"]) {
            uiConfig.statusBarStyle = UIStatusBarStyleDefault;
        } else if ([statusBarStyle isEqualToString:@"LightContent"]) {
            uiConfig.statusBarStyle = UIStatusBarStyleLightContent;
        }
    }

    NSString *pageBackgroundColorStr = [self valueForKey:@"pageBackgroundColor" defaultValue: nil ofDict:configInfo];
    UIColor *pageBackgroundColor = [self colorFromHexStr: pageBackgroundColorStr];
    if (pageBackgroundColor) {
        uiConfig.pageBackgroundColor = pageBackgroundColor;
    }

    NSString *viewfinderColorStr = [self valueForKey:@"viewfinderColor" defaultValue: nil ofDict:configInfo];
    UIColor *viewfinderColor = [self colorFromHexStr: viewfinderColorStr];
    if (viewfinderColor) {
        uiConfig.viewfinderColor = viewfinderColor;
    }

    NSString *primaryTextColorStr = [self valueForKey:@"primaryTextColor" defaultValue: nil ofDict:configInfo];
    UIColor *primaryTextColor = [self colorFromHexStr: primaryTextColorStr];
    if (primaryTextColor) {
        uiConfig.primaryTextColor = primaryTextColor;
    }

    NSString *toolButtonThemeColorStr = [self valueForKey:@"toolButtonThemeColor" defaultValue: nil ofDict:configInfo];
    UIColor *toolButtonThemeColor = [self colorFromHexStr: toolButtonThemeColorStr];
    if (toolButtonThemeColor) {
        uiConfig.toolButtonThemeColor = toolButtonThemeColor;
    }

    NSString *takePhotoTipTextColorStr = [self valueForKey:@"takePhotoTipTextColor" defaultValue: nil ofDict:configInfo];
    UIColor *takePhotoTipTextColor = [self colorFromHexStr: takePhotoTipTextColorStr];
    if (takePhotoTipTextColor) {
        uiConfig.takePhotoTipTextColor = takePhotoTipTextColor;
    }

    NSString *takePhotoTipBcgColorStr = [self valueForKey:@"takePhotoTipBackgroundColor" defaultValue: nil ofDict:configInfo];
    UIColor *takePhotoTipBcgColor = [self colorFromHexStr: takePhotoTipBcgColorStr];
    if (takePhotoTipBcgColor) {
        uiConfig.takePhotoTipBackgroundColor = takePhotoTipBcgColor;
    }

    NSString *previewPhotoTipBcgColorStr = [self valueForKey:@"previewPhotoTipBackgroundColor" defaultValue: nil ofDict:configInfo];
    UIColor *previewPhotoTipBcgColor = [self colorFromHexStr: previewPhotoTipBcgColorStr];
    if (previewPhotoTipBcgColor) {
        uiConfig.previewPhotoTipBackgroundColor = previewPhotoTipBcgColor;
    }

    NSString *previewPhotoTipTextColorStr = [self valueForKey:@"previewPhotoTipTextColor" defaultValue: nil ofDict:configInfo];
    UIColor *previewPhotoTipTextColor = [self colorFromHexStr: previewPhotoTipTextColorStr];
    if (previewPhotoTipTextColor) {
        uiConfig.previewPhotoTipTextColor = previewPhotoTipTextColor;
    }

    NSString *orientationStr = [self valueForKey:@"orientation" defaultValue: nil ofDict:configInfo];
    AAIIQAOrientation orientation = AAIIQAOrientationAuto;
    if (orientationStr != nil && [orientationStr isKindOfClass:[NSString class]]) {
        if ([orientationStr isEqualToString:@"Auto"]) {
            orientation = AAIIQAOrientationAuto;
        } else if ([orientationStr isEqualToString:@"Landscape"]) {
            orientation = AAIIQAOrientationLandscape;
        } else if ([orientationStr isEqualToString:@"Portrait"]) {
            orientation = AAIIQAOrientationPortrait;
        }
    }
    uiConfig.orientation = orientation;
}

- (nullable id)valueForKey:(NSString *)key defaultValue:(nullable id)defaultValue ofDict:(NSDictionary *)dict
{
    if (dict == nil || [dict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    id value = dict[key];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return defaultValue;
    }
    return value;
}

- (UIColor *)colorFromHexStr:(NSString *)hexStr
{
    if (!hexStr) {
        return nil;
    }

    if (![hexStr isKindOfClass:[NSString class]]) {
        return nil;
    }

    NSInteger len = hexStr.length;

    if (len == 0 || ((len != 7) && (len != 9))) {
        return nil;
    }

    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&result];

    if (len == 7) {
        CGFloat r = ((result >> 16) & 0xFF) / 255.0;
        CGFloat g = ((result >> 8) & 0xFF) / 255.0;
        CGFloat b = (result & 0xFF) / 255.0;
        return [UIColor colorWithRed:r green:g blue:b alpha:1];
    } if (len == 9) {
        CGFloat r = ((result >> 24) & 0xFF) / 255.0;
        CGFloat g = ((result >> 16) & 0xFF) / 255.0;
        CGFloat b = ((result >> 8) & 0xFF) / 255.0;
        CGFloat a = (result & 0xFF) / 255.0;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }

    return nil;
}

# pragma mark AAIGlobalIQADelegate
- (void)iqaOnDetectionComplete:(AAIGlobalIQAResult *)result
{
    NSMutableDictionary *mutiDict = [[NSMutableDictionary alloc] init];
    mutiDict[@"success"] =  @(result.success);
    mutiDict[@"pay"] =  @(result.pay);

    if (result.IDVID) {
        mutiDict[@"IDVID"] =  result.IDVID;
    }

    if (result.transactionId) {
        mutiDict[@"transactionId"] = result.transactionId;
    }

    if (result.errorCode) {
        mutiDict[@"errorCode"] = result.errorCode;
    }

    if (result.errorMsg) {
        mutiDict[@"errorMsg"] = result.errorMsg;
    }

    if (result.idForgeryResult) {
        mutiDict[@"idForgeryResult"] = result.idForgeryResult;
    }

    if (result.ocrResult) {
        mutiDict[@"ocrResult"] = result.ocrResult;
    }

    if (result.pictureType) {
        mutiDict[@"pictureType"] = result.pictureType;
    }

    if (result.cardImg) {
        NSString *base64Str = [UIImageJPEGRepresentation(result.cardImg, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        mutiDict[@"cardImg"] = base64Str;
    }

    [RNAAIIOSIQASDKEvent postNotiToReactNative:@"onDetectionComplete" body:mutiDict];
}

@end

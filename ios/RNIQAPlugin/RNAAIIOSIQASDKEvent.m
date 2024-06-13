//
//  RNAAIIOSIQASDKEvent.m
//  Pods
//
//  Created by aaaa zhao on 2020/10/29.
//

#import "RNAAIIOSIQASDKEvent.h"

@interface RNAAIIOSIQASDKEvent()
{
    bool _hasListeners;
}
@end
@implementation RNAAIIOSIQASDKEvent

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
   return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"RNAAIIOSIQASDKEvent"];
}

- (void)startObserving
{
    _hasListeners = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emitEventInternal:) name:@"RNAAIIOSIQASDKEventNotify" object:nil];
    });
}

- (void)stopObserving
{
    _hasListeners = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    });
}

- (void)emitEventInternal:(NSNotification *)notification
{
    [self sendEventWithName:@"RNAAIIOSIQASDKEvent" body:notification.object];
}

+ (void)postNotiToReactNative:(NSString *)name body:(NSDictionary * _Nullable)body
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"name"] = name;
        if (body) {
            dic[@"body"] = body;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RNAAIIOSIQASDKEventNotify" object:dic];
    });
}

@end

#import "XSignInstallBridge.h"
#import "XSignInstallSDK.h"
#include "XSignInstallInterface.hpp"

static bool bRegisterWakeUpFunc = false;
static NSString *wakeUpData = nil;

@implementation XSignInstallBridge

+(void)reportRegister{
    [XSignInstallSDK reportRegister];
    NSLog(@"XSignInstallSDK: iOS原生层已调用注册统计方法");
}

+(void)getInstall{
    [XSignInstallSDK getInstallParams:^(NSDictionary*_Nullable appData) {
        NSString *json = [self jsonStringWithObject:appData];
        NSLog(@"XSignInstallSDK:ios原生层返回的json串为%@", wakeUpData);
        XSignInstallInterface::getInstallCallback([json UTF8String]);
    }];
}

+(void)registerWakeupCallback{
    bRegisterWakeUpFunc = true;
    if (wakeUpData && wakeUpData.length > 0) {
        NSLog(@"XSignInstallSDK:ios原生层返回的json串为%@", wakeUpData);
        XSignInstallInterface::wakeupCallback([wakeUpData UTF8String]);
        wakeUpData = nil;
    }
}

+ (NSString *)jsonStringWithObject:(id)jsonObject{
    id arguments = (jsonObject == nil ? [NSNull null] : jsonObject);
    NSArray* argumentsWrappedInArr = [NSArray arrayWithObject:arguments];
    NSString* argumentsJSON = [self cp_JSONString:argumentsWrappedInArr];
    argumentsJSON = [argumentsJSON substringWithRange:NSMakeRange(1, [argumentsJSON length] - 2)];
    return argumentsJSON;
}

+ (NSString *)cp_JSONString:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return @"";
    }
}

+(void)checkWakeUpJson:(NSDictionary *)dict{
    wakeUpData = [self jsonStringWithObject:dict];
    if (wakeUpData && wakeUpData.length > 0) {
        if (bRegisterWakeUpFunc) {
            NSLog(@"XSignInstallSDK:ios原生层返回的json串为%@", wakeUpData);
            XSignInstallInterface::wakeupCallback([wakeUpData UTF8String]);
            wakeUpData = nil;
        }else{
            [wakeUpData retain];
        }
    }
}

@end

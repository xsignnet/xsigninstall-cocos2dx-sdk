#import "XSignInstallBridge.h"
#import "XSignInstallSDK.h"
#include "cocos2d.h"
#include "cocos/scripting/js-bindings/jswrapper/SeApi.h"

using namespace cocos2d;

static bool registerWakeup = false;
static NSString *wakeUpData = nil;

@implementation XSignInstallBridge

+(void)reportRegister{
    [XSignInstallSDK reportRegister];
    NSLog(@"XSignInstallSDK: iOS原生层已调用注册统计方法");
}

+(void)getInstall{
    NSLog(@"getInstall");
    [XSignInstallSDK getInstallParams:^(NSDictionary*_Nullable appData) {
        NSString *json = [self jsonStringWithObject:appData];
        [self callScriptMethod:@"installCallback" withData:json];
    }];
}

+(void)registerWakeupCallback{
    NSLog(@"registerWakeupCallback");
    registerWakeup = true;
    if (wakeUpData && wakeUpData.length > 0) {
        [self callScriptMethod:@"wakeupCallback" withData:wakeUpData];
        wakeUpData = nil;
    }
}

+(void)checkWakeUpJson:(NSDictionary *)dict{
    NSLog(@"checkWakeUpJson");
    wakeUpData = [self jsonStringWithObject:dict];
    if (wakeUpData && wakeUpData.length > 0) {
        if (registerWakeup) {
            [self callScriptMethod:@"wakeupCallback" withData:wakeUpData];
            wakeUpData = nil;
        }else{
            [wakeUpData retain];
        }
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

+(void)callScriptMethod:(NSString *)methodKey withData:(NSString *)data{
    NSLog(@"XSignInstallSDK:ios原生层返回的json串为%@",data);
    NSString * scriptStr = [[NSString alloc] initWithFormat:@"globalThis.XSignInstall.%@(%@);", methodKey, data];
    // NSLog(@"执行脚本:%@",scriptStr);
    std::string mehtodCallStr = [scriptStr cStringUsingEncoding:NSUTF8StringEncoding];
    se::ScriptEngine::getInstance()->evalString(mehtodCallStr.c_str());
}
@end

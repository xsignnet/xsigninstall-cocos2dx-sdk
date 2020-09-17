#import "XSignInstallBridge.h"
#import "XSignInstallSDK.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#endif

static int wakeupFunctionId = 0;
static NSString *wakeUpData = nil;

@implementation XSignInstallBridge

+(void)reportRegister{
    [XSignInstallSDK reportRegister];
    NSLog(@"XSignInstallSDK: iOS原生层已调用注册统计方法");
}

+(void)getInstall:(NSDictionary *)dict
{
    [XSignInstallSDK getInstallParams:^(NSDictionary*_Nullable appData) {
        NSString *json = [self jsonStringWithObject:appData];
        int functionId = [[dict objectForKey:@"callback"] intValue];
        [self sendWakeUpJsonBack:json byFunctionId:functionId];
    }];
}

+(void)registerWakeupCallback:(NSDictionary *)dict{
    wakeupFunctionId = [[dict objectForKey:@"callback"] intValue];
    if (wakeupFunctionId > 0 && wakeUpData && wakeUpData.length > 0) {
        [self sendWakeUpJsonBack:wakeUpData byFunctionId:wakeupFunctionId];
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

+(void)sendWakeUpJsonBack:(NSString *)json byFunctionId:(int)functionId{
    NSLog(@"XSignInstallSDK:ios原生层返回的json串为%@",json);
    cocos2d::LuaObjcBridge::pushLuaFunctionById(functionId);
    //将需要传递给 Lua function 的参数放入 Lua stack
    cocos2d::LuaObjcBridge::getStack()->pushString([json UTF8String]);//返回json字串
    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);//1个参数
}

+(void)checkWakeUpJson:(NSDictionary *)dict{
    wakeUpData = [self jsonStringWithObject:dict];
    if (wakeUpData && wakeUpData.length > 0) {
        if (wakeupFunctionId > 0) {
            [self sendWakeUpJsonBack:wakeUpData byFunctionId:wakeupFunctionId];
            wakeUpData = nil;
        }else{
            [wakeUpData retain];
        }
    }
}

@end

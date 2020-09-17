#import <Foundation/Foundation.h>

@interface XSignInstallBridge : NSObject

+(void)reportRegister;

+(void)getInstall;

+(void)registerWakeupCallback;

+(void)checkWakeUpJson:(NSDictionary *)dict;

@end

#import <Foundation/Foundation.h>

@interface XSignInstallBridge : NSObject

+(void)reportRegister;

+(void)getInstall:(NSDictionary *)dict;

+(void)registerWakeupCallback:(NSDictionary *)dict;

+(void)checkWakeUpJson:(NSDictionary *)dict;

@end

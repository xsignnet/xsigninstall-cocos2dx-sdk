#import <Foundation/Foundation.h>

@interface XSignInstallBridge : NSObject

+(void)reportRegister;

+(void)getInstall:(NSString *)methodKey;

+(void)registerWakeupCallback:(NSString *)methodKey;

+(void)checkWakeUpJson:(NSDictionary *)dict;

@end

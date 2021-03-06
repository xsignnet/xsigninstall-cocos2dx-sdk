
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol XSignInstallDelegate <NSObject>
@optional
/// 唤醒时获取h5页面动态参数（如果是渠道链接，渠道编号会一起返回）
/// @param dic 动态参数对象
- (void)getWakeUpParams:(NSDictionary *_Nullable)dic;
@end

@interface XSignInstallSDK : NSObject


/// 初始化XSignInstall SDK
/// @param delegate 委托方法所在的类的对象
/// @discussion 调用该方法前，需在Info.plist文件中配置键值对,键为com.XSigninstall.APP_KEY不能修改，值为相应的应用的appKey，可在XSignInstall官方后台查看
+ (void)initWithDelegate:(id<XSignInstallDelegate> _Nonnull)delegate;

    
/// 开发者在需要获取用户安装app后由web网页传递过来的”动态参数“（如邀请码、游戏房间号，渠道编号等）时调用该方法,可第一时间返回数据，可在任意位置调用
/// @param completionHandler 回调block
/// @discussion 1、不要自己保存动态安装参数，在每次需要用到参数时，请调用该方法去获取；
///2.该方法默认超时为8秒，尽量写在业务场景需要参数的位置调用（在业务场景时，网络一般都是畅通的），例如，可以选择在用户注册成功后调用该方法获取参数，对用户进行奖励。
///原因是iOS首次安装、首次启动的app，会询问用户获取网络权限，用户允许后SDK才能正常联网去获取参数。如果调用过早，可能导致网络权限还未允许就被调用，导致参数无法及时拿到，误以为参数不存在（此时getInstallParmsCompleted法已超时，回调返回空
///3.该方法可重复获取参数，如需在首次安装才获取安装参数，请自行判断.
+ (void)getInstallParams:(void (^_Nullable)(NSDictionary * _Nullable dic))completionHandler;


/// 注册量统计
/// @discussion 使用XSignInstallSDK 控制中心提供的渠道统计时，在App用户注册完成后调用，可以统计渠道注册量。
/// 必须在注册成功的时再调用该方法，避免重复调用，否则可能导致注册统计不准
+ (void)reportRegister;


/// 处理 URI schemes
/// @param url 系统回调传回的URL
/// @return bool  URL是否被XSignInstallSDK识别
+ (BOOL)handLinkURL:(NSURL *_Nonnull)url;


/// 处理 通用链接
/// @param userActivity 存储了页面信息，包括url
/// @return bool  URL是否被XSignInstallSDK识别
+ (BOOL)continueUserActivity:(NSUserActivity *_Nonnull)userActivity;


/// 当前XSignInstallSDK 版本号 "0.6.0"
+ (NSString *_Nullable)sdkVersion;

@end

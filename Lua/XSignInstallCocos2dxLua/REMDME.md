# xsigninstall-cocos2dx-lua

cocos2d-x 集成 xsigninstall SDK

## Android 集成
集成 xsigninstall SDK 到 cocos2d-x Android 项目中，请参考 [Android 集成指南](https://www.zsign.net/web/build/index.html#/ditribution/androidPakage/combineSdk)


## 桥接文件集成
#### 下载桥接文件
	下载后将XSignInstallCocos2dxLua整个目录放到Classes目录下（或其他文件目录），再将src内文件放入android工程src目录下
#### 导入头文件
在`AppActivity.java`中导入头文件
``` cpp
import io.xsigninstall.cocos2dx.XSignInstallInterface;
```
#### 初始化
在 `AppActivity.java` 的 `onCreate` 的方法中进行初始化。
``` cpp
@Override
protected void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	XSignInstallInterface.init(this);
}
```
#### 代理设置
``` cpp
@Override
protected void onResume(){
	super.onResume();
	XSignInstallInterface.initStatistics(this);
}
@Override
protected void onStart() {
	super.onStart();
	XSignInstallInterface.checkWakeup();
}
```


--------------------------------分割线--------------------------------


## iOS 集成
集成 xsigninstall SDK 到 cocos2d-x iOS 项目中，请参考 [iOS 集成指南](https://www.zsign.net/web/build/index.html#/ditribution/iosPakage/combineSdk)


## 桥接文件集成
#### 下载并导入桥接文件
	下载后将XSignInstallCocos2dxLua整个目录放到Classes目录下（或其他文件目录），并导入整个目录到项目中（除了android子目录外）
    ![上传安装包](res/ios_classes.jpg)
#### 导入头文件
在 `AppController.mm`中导入头文件
``` cpp
#import "XSignInstallBridge.h"
```
*注：请根据文件目录结构适当调整引用路径*
#### 初始化
在 `AppController.mm` 的 `didFinishLaunchingWithOptions` 的方法中进行初始化。
``` cpp
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[XSignInstallSDK initWithDelegate:self];

    return YES;
}
```
#### 代理设置
``` cpp
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
  //处理通过XSigninstall一键唤起App时传递的数据
  [XSignInstallSDK continueUserActivity:userActivity];
  //其他第三方回调；
   return YES;
}

//适用目前所有iOS版本
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //处理通过XSignInstall URL Scheme唤起App的数据
    [XSignInstallSDK handLinkURL:url];
    //其他第三方回调；
    return YES;
}

//通过XSignInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
-(void)getWakeUpParams:(NSDictionary *)appData{
    [XSignInstallBridge checkWakeUpJson:appData];
}
```


--------------------------------分割线--------------------------------


### 功能使用
`首先将script目录下的xsigninstall.lua导入项目脚本目录下`
#### 1 携带参数安装
##### 获取安装参数
在应用需要安装参数时，调用以下 api 获取由 SDK 保存的安装参数
``` cpp
    xsigninstall:getInstall(function (customData)
        dump(customData, "获取携带安装参数")
    end)
```

#### 2 一键拉起
##### 获取拉起数据
同样，注册拉起回调，这样当 App 被拉起时，会回调方法，并可在回调中获取拉起数据
``` cpp
    xsigninstall:registerWakeupCallback(function (wakeupData)
        dump(wakeupData, "获取一键拉起数据")
    end)
```

#### 3 渠道统计 
##### SDK 会自动完成访问量、点击量、安装量、活跃量、留存率等统计工作。其它业务相关统计由开发人员代码埋点上报

##### 3.1 注册上报
根据自身的业务规则，在确保用户完成 app 注册的情况下调用相关api
``` cpp
    xsigninstall:reportRegister()
```

## 导出apk/api包并上传
- 代码集成完毕后，需要导出安装包上传xsigninstall后台，xsigninstall会自动完成所有的应用配置工作。  
- 上传完成后即可开始在线模拟测试，体验完整的App安装/拉起流程；待测试无误后，再完善下载配置信息。  


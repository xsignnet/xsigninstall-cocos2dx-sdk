#ifndef __WECHATINTERFACE__
#define __WECHATINTERFACE__
#include <string>
#include <vector>
#include <map>
#include "cocos2d.h"
USING_NS_CC;
using namespace std;

#define XSignInstallDataCallback std::function<void(const string&)>

class XSignInstallInterface
{
public:
	XSignInstallInterface();
	~XSignInstallInterface();

	static void reportRegister();
	static void getInstall(const XSignInstallDataCallback& callback);
	static void registerWakeupCallback(const XSignInstallDataCallback& callback);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    static void getInstallCallback(const string& data);
    static void wakeupCallback(const string& data);
#endif
};

#endif



#include "../XSignInstallInterface.hpp"
#include "cocos2d.h"
USING_NS_CC;
#import "XSignInstallBridge.h"

static XSignInstallDataCallback s_GetInstallCallback = nullptr;
static XSignInstallDataCallback s_WakeupCallback = nullptr;

XSignInstallInterface::XSignInstallInterface()
{

}

XSignInstallInterface::~XSignInstallInterface()
{
}

void XSignInstallInterface::reportRegister()
{
    [XSignInstallBridge reportRegister];
}

void XSignInstallInterface::getInstall(const XSignInstallDataCallback& callback)
{
	s_GetInstallCallback = callback;
    [XSignInstallBridge getInstall];
}

void XSignInstallInterface::registerWakeupCallback(const XSignInstallDataCallback& callback)
{
	s_WakeupCallback = callback;
    [XSignInstallBridge registerWakeupCallback];
}

void XSignInstallInterface::getInstallCallback(const string& data)
{
    if (s_GetInstallCallback) {
        s_GetInstallCallback(data);
    }
}

void XSignInstallInterface::wakeupCallback(const string& data)
{
    if (s_WakeupCallback) {
        s_WakeupCallback(data);
    }
}


#include "../XSignInstallInterface.hpp"
#include "cocos2d.h"
USING_NS_CC;
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "jni/JniHelper.h"
#include <jni.h>
#include <functional>
#define PAGEPATH "io/xsigninstall/cocos2dx/XSignInstallInterface"

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
	JniMethodInfo t;
	if (JniHelper::getStaticMethodInfo(t, PAGEPATH, "reportRegister", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
	}
}

void XSignInstallInterface::getInstall(const XSignInstallDataCallback& callback)
{
	s_GetInstallCallback = callback;
	JniMethodInfo t;
	if (JniHelper::getStaticMethodInfo(t, PAGEPATH, "getInstall", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
	}
}

void XSignInstallInterface::registerWakeupCallback(const XSignInstallDataCallback& callback)
{
	s_WakeupCallback = callback;
	JniMethodInfo t;
	if (JniHelper::getStaticMethodInfo(t, PAGEPATH, "registerWakeupCallback", "()V")) {
		t.env->CallStaticVoidMethod(t.classID, t.methodID);
	}
}

#ifdef __cplusplus
extern "C" {
#endif
	JNIEXPORT void JNICALL Java_io_xsigninstall_cocos2dx_XSignInstallInterface_getInstallCallback(JNIEnv* env, jclass method, jstring jData)
	{
		std::string data = JniHelper::jstring2string(jData);
		if (s_GetInstallCallback) {
			s_GetInstallCallback(data);
		}

	}
	JNIEXPORT void JNICALL Java_io_xsigninstall_cocos2dx_XSignInstallInterface_wakeupCallback(JNIEnv* env, jclass method, jstring jData)
	{
		std::string data = JniHelper::jstring2string(jData);
		if (s_WakeupCallback) {
			s_WakeupCallback(data);
		}
	}
#ifdef __cplusplus
}
#endif

#endif

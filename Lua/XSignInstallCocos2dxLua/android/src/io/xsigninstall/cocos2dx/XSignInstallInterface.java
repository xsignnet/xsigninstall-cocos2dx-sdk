package io.xsigninstall.cocos2dx;

import android.net.Uri;
import android.util.Log;

import com.project.xinstallsdk.XSignInstall;
import com.project.xinstallsdk.inter.ConfigCallBack;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONObject;

import java.util.Map;

public class XSignInstallInterface {

    private static final String TAG = "XSignInstallInterface";
    public static Cocos2dxActivity _cocos2dxActivity = null;
    private static String _wakeupDataHolder = null;
    private static int _wakeUpLuaFunc = -1;

    public static void init(final Cocos2dxActivity cocos2dxActivity) {
        Log.d(TAG, "init XSignInstallInterface");
        _cocos2dxActivity = cocos2dxActivity;
    }

    //初始化统计
    public static void initStatistics(final Cocos2dxActivity cocos2dxActivity) {
        _cocos2dxActivity = cocos2dxActivity;
        PermissionTransition.init((AppActivity) _cocos2dxActivity);
        if (0 <= PermissionTransition.hasAllPermissions()) {
            Log.d(TAG, "initStatistics");
            //统计
            new XSignInstall(_cocos2dxActivity, "Installation_with_parameters");
        }
    }

    /* 注册量统计 如需统计每个渠道的注册量（对评估渠道质量很重要），可根据自身的业务规则，在确保用户完成 app 注册的情况下调用以下接口 */
    public static void reportRegister() {
        _cocos2dxActivity.runOnUiThread(new Runnable() {
            public void run() {
                Log.d(TAG, "reportRegister");
                //用户注册成功后调用
                new XSignInstall(_cocos2dxActivity, "register");
            }
        });
    }

    /* 获取installid及自定义安装携带参数 */
    public static void getInstall(final int luaFunc) {
        _cocos2dxActivity.runOnUiThread(new Runnable() {
            public void run() {
                Log.d(TAG, "getInstall");
                XSignInstall get_config = new XSignInstall(_cocos2dxActivity , "Get_config", new ConfigCallBack() {
                    @Override
                    public void OnSuccess(Map configinfo) {
                        if (configinfo != null) {
                            JSONObject json = new JSONObject(configinfo);
                            String data = json.toString();
                            _cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, data);
                                    Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
                                }
                            });
                        }
                    }
        
                    @Override
                    public void RouseCallBack(Map rouse) {
        
                    }
                });
                get_config = null;
            }
        });
    }

    //初始化一键唤起相关
    public static void checkWakeup() {
        Log.d(TAG, "checkWakeup");
        Uri uri = _cocos2dxActivity.getIntent().getData();
        Log.d(TAG, "uri" + uri);
        if (uri != null) {
            String uriString = ((Uri) uri).toString();
            Log.d(TAG, "wakeupCallback not register , uriString = " + uriString);
            XSignInstall xsigninstall = new XSignInstall(_cocos2dxActivity, uriString, new ConfigCallBack() {
                @Override
                public void OnSuccess(Map configinfo) {

                }

                @Override
                public void RouseCallBack(Map rouse) {
                    if (rouse != null) {
                        JSONObject json = new JSONObject(rouse);
                        String data = json.toString();
                        if (-1 == _wakeUpLuaFunc) {
                            Log.d(TAG, "wakeupCallback not register , wakeupData = " + data);
                            _wakeupDataHolder = data;
                            return;
                        }
                        Log.d(TAG, "wakeupData = " + data);
                        _cocos2dxActivity.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(_wakeUpLuaFunc, data);
                            }
                        });
                    }
                }
            });
            xsigninstall = null;
        }
    }

    //注册一键唤醒传参回调
    public static void registerWakeupCallback(final int luaFunc) {
        Log.d(TAG, "registerWakeupCallback");
        _wakeUpLuaFunc = luaFunc;
        if (_wakeupDataHolder != null) {
            Log.d(TAG, "_wakeupDataHolder = " + _wakeupDataHolder);
            _cocos2dxActivity.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(_wakeUpLuaFunc, _wakeupDataHolder);
                    _wakeupDataHolder = null;
                }
            });
        }
    }

}

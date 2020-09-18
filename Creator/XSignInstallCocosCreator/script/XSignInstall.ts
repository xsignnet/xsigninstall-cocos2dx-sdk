export default class XSignInstall {
    private static activityClassName = cc.sys.OS_ANDROID == cc.sys.os ? "io/xsigninstall/cocos2dx/XSignInstallInterface" : "XSignInstallBridge";
    private static _wakeupCallback(appData){

    }

    private static _installCallback(appData){

    }

    public static getInstall(callback) {
        this._installCallback = callback;
        if (cc.sys.OS_ANDROID == cc.sys.os) {
            jsb.reflection.callStaticMethod(this.activityClassName, "getInstall", "()V");
        } else if(cc.sys.OS_IOS == cc.sys.os){
            jsb.reflection.callStaticMethod(this.activityClassName, "getInstall");
        }
    }
    public static registerWakeupCallback(callback) {
        this._wakeupCallback = callback;
        if (cc.sys.OS_ANDROID == cc.sys.os) {
            jsb.reflection.callStaticMethod(this.activityClassName, "registerWakeupCallback", "()V");
        } else if(cc.sys.OS_IOS == cc.sys.os){
            jsb.reflection.callStaticMethod(this.activityClassName, "registerWakeupCallback");
        }
    }

    public static reportRegister() {
        if (cc.sys.OS_ANDROID == cc.sys.os) {
            jsb.reflection.callStaticMethod(this.activityClassName, "reportRegister", "()V");
        } else if(cc.sys.OS_IOS == cc.sys.os){
            jsb.reflection.callStaticMethod(this.activityClassName, "reportRegister");
        }
    }

    public static installCallback(data) {
        cc.log("安装参数：" + JSON.stringify(data));
        this._installCallback(data);
    }

    public static wakeupCallback(data) {
        cc.log("拉起参数：" + JSON.stringify(data));
        this._wakeupCallback(data);
    }
};
globalThis.XSignInstall = XSignInstall;
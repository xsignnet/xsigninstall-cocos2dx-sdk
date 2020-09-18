package io.xsigninstall.cocos2dx;

import android.app.Activity;
import android.util.Log;

import org.cocos2dx.javascript.AppActivity;


public class PermissionTransition {

    public static PermissionChecker _permission;
    public static void init(AppActivity activity) {
        _permission = new PermissionChecker(activity);
    }
    
    public static boolean hasPermission (String permission){
    	Log.i("hasPermission", "result : " + _permission.hasPermission(permission));
    	return _permission.hasPermission(permission);
    }
   
    public static int hasAllPermissions(){
    	return _permission.hasAllPermissions();
    }
    
}


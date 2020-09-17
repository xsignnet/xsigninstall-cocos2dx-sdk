package io.xsigninstall.cocos2dx;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;

public class PermissionChecker {
    private Activity _currentActivity;
    public static final int MY_PERMISSIONS_REQUEST = 100;

    public static final int PERMISSION_NO_READ_PHONE_STATE = -10;

    final String TAG = "PermissionChecker";

    private final HashMap<String, Integer> _permissionToIndex = new HashMap<String, Integer>();
    private final String[] _permissionArray = new String[] {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
    };

    public PermissionChecker(Activity context) {
        _currentActivity = context;
    }

    public int hasAllPermissions() {
        int permissionState = 0;
        ArrayList<String> needRequestPermissionList = new ArrayList<String>();
        for (String permission : _permissionArray) {
            if (hasPermission(permission)) {
                continue;
            } else {
                needRequestPermissionList.add(permission);
                if (permission.equals(Manifest.permission.READ_PHONE_STATE)) {
                    permissionState = PERMISSION_NO_READ_PHONE_STATE;
                } else if (permissionState >= 0){
                    permissionState = -1;
                }
            }
        }
        if (permissionState < 0) {
            ActivityCompat.requestPermissions(_currentActivity, needRequestPermissionList.toArray(new String[0]), MY_PERMISSIONS_REQUEST);
        }
        return permissionState;
    }

    public boolean hasPermission(String permission) {
    	Log.i("permission", "hasPermission call");
    	boolean result = false;
    	try {
            result =  ContextCompat.checkSelfPermission(_currentActivity.getApplicationContext(), permission) == PackageManager.PERMISSION_GRANTED;
            Log.i(TAG, "result :" + result + "  permission :" + permission);
        }catch (Exception e){
    	    Log.i(TAG, "get permission :" + permission + " error");
        }
        return result;
    }
    
    public static int getSDKVersion(){
        return android.os.Build.VERSION.SDK_INT;
    }
}


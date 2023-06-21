package com.arklnk.plugins.dfu;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;

import androidx.annotation.Nullable;

public class NotificationActivity extends Activity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // If this activity is the root activity of the task, the app is not running
        if (isTaskRoot()) {
            PackageManager pm = this.getApplication().getPackageManager();
            Intent intent = pm.getLaunchIntentForPackage(this.getApplication().getPackageName());
            startActivity(intent);
        }

        finish();
    }
}

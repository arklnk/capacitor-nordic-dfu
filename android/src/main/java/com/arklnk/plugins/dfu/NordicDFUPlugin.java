package com.arklnk.plugins.dfu;

import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.io.File;

import no.nordicsemi.android.dfu.DfuProgressListenerAdapter;
import no.nordicsemi.android.dfu.DfuServiceController;
import no.nordicsemi.android.dfu.DfuServiceInitiator;
import no.nordicsemi.android.dfu.DfuServiceListenerHelper;

@CapacitorPlugin(name = "NordicDFU")
public class NordicDFUPlugin extends Plugin {

    private PluginCall pendingCall;
    private DfuServiceController pendingDfuController;

    private final DfuProgressListenerAdapter mDfuProgressListener = new DfuProgressListenerAdapter() {

        @Override
        public void onDeviceConnecting(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Connecting", deviceAddress);
        }

        @Override
        public void onDfuProcessStarting(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Starting", deviceAddress);
        }

        @Override
        public void onDfuProcessStarted(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Uploading", deviceAddress);
        }

        @Override
        public void onEnablingDfuMode(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Enabling DFU Mode", deviceAddress);
        }

        @Override
        public void onProgressChanged(@NonNull String deviceAddress, int percent, float speed, float avgSpeed, int currentPart, int partsTotal) {
            NordicDFUPlugin.this.triggerDfuProgressDidChangeEvent(deviceAddress, percent, speed, avgSpeed, currentPart, partsTotal);
        }

        @Override
        public void onFirmwareValidating(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Validating", deviceAddress);
        }

        @Override
        public void onDeviceDisconnecting(String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Disconnecting", deviceAddress);
        }

        @Override
        public void onDeviceDisconnected(@NonNull String deviceAddress) {
            // iOS unsupport
        }

        @Override
        public void onDfuCompleted(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Completed", deviceAddress);

            if (pendingCall != null) {
                pendingCall.resolve();

                pendingCall = null;
            }

            pendingDfuController = null;
        }

        @Override
        public void onDfuAborted(@NonNull String deviceAddress) {
            NordicDFUPlugin.this.triggerDfuStateDidChangeEvent("Aborted", deviceAddress);

            if (pendingCall != null) {
                JSObject ret = new JSObject();
                ret.put("deviceAddress", deviceAddress);
                ret.put("error", -1);
                ret.put("message", "Aborted");
                pendingCall.reject("Aborted", ret);

                pendingCall = null;
            }

            pendingDfuController = null;
        }

        @Override
        public void onDeviceConnected(@NonNull String deviceAddress) {
            // iOS unsupport
        }

        @Override
        public void onError(@NonNull String deviceAddress, int error, int errorType, String message) {
            if (pendingCall != null) {
                JSObject ret = new JSObject();
                ret.put("deviceAddress", deviceAddress);
                ret.put("error", error);
                ret.put("message", message);
                pendingCall.reject(message, ret);

                pendingCall = null;
            }

            pendingDfuController = null;
        }
    };

    @Override
    public void load() {
        super.load();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            DfuServiceInitiator.createDfuNotificationChannel(this.getContext());
        }
    }

    @PluginMethod
    @SuppressWarnings({"ConstantConditions"})
    public void startDFU(PluginCall call) {
        if (this.pendingCall != null) {
            call.reject("DFU Pending");
            return;
        }

        String filePath = call.getString("filePath");
        if (TextUtils.isEmpty(filePath)) {
            call.reject("filePath is empty");
            return;
        }

        Uri fileUri = Uri.parse(filePath);
        File zipFile = new File(fileUri.getPath());
        if (!zipFile.exists()) {
            call.reject("file is not exist");
            return;
        }

        String deviceAddress = call.getString("deviceAddress");
        if (TextUtils.isEmpty("deviceAddress")) {
            call.reject("deviceAddress is empty");
            return;
        }

        Boolean forceDfu = call.getBoolean("forceDfu");
        Boolean enableUnsafeExperimentalButtonlessServiceInSecureDfu = call.getBoolean("enableUnsafeExperimentalButtonlessServiceInSecureDfu");
        Boolean disableResume = call.getBoolean("disableResume");
        Boolean forceScanningForNewAddressInLegacyDfu = call.getBoolean("forceScanningForNewAddressInLegacyDfu");
        Boolean disableNotification = call.getBoolean("disableNotification");
        Boolean foreground = call.getBoolean("foreground");
        Long dataObjectPreparationDelay = call.getLong("dataObjectPreparationDelay");

        final DfuServiceInitiator dfuInitiator = new DfuServiceInitiator(deviceAddress).setZip(fileUri);

        if (forceDfu != null) {
            dfuInitiator.setForceDfu(forceDfu);
        }
        if (enableUnsafeExperimentalButtonlessServiceInSecureDfu != null) {
            dfuInitiator.setUnsafeExperimentalButtonlessServiceInSecureDfuEnabled(enableUnsafeExperimentalButtonlessServiceInSecureDfu);
        }
        if (disableResume != null) {
            dfuInitiator.setForceScanningForNewAddressInLegacyDfu(forceScanningForNewAddressInLegacyDfu);
        }
        if (disableNotification != null) {
            dfuInitiator.setDisableNotification(disableNotification);
        }
        if (foreground != null) {
            dfuInitiator.setForeground(foreground);
        }
        if (disableResume != null && disableResume) {
            dfuInitiator.disableResume();
        }
        if (dataObjectPreparationDelay != null) {
            dfuInitiator.setPrepareDataObjectDelay(dataObjectPreparationDelay);
        }

        DfuServiceListenerHelper.registerProgressListener(this.getContext(), mDfuProgressListener);

        // pending task
        this.pendingDfuController = dfuInitiator.start(this.getContext(), DfuService.class);
        this.pendingCall = call;
    }

    @PluginMethod
    public void abortDFU(PluginCall call) {
        if (this.pendingDfuController != null && !this.pendingDfuController.isAborted()) {
            this.pendingDfuController.abort();
        }

        this.pendingDfuController = null;

        call.resolve();
    }

    @Override
    protected void handleOnResume() {
        super.handleOnResume();

        DfuServiceListenerHelper.registerProgressListener(this.getContext(), mDfuProgressListener);
    }

    @Override
    protected void handleOnPause() {
        super.handleOnPause();

        DfuServiceListenerHelper.unregisterProgressListener(this.getContext(), mDfuProgressListener);
    }

    private void triggerDfuStateDidChangeEvent(String state, String deviceAddress) {
        JSObject data = new JSObject();
        data.put("state", state);
        data.put("deviceAddress", deviceAddress);
        notifyListeners("dfuStateDidChange", data);
    }

    private void triggerDfuProgressDidChangeEvent(@NonNull String deviceAddress, int percent, float speed, float avgSpeed, int currentPart, int partsTotal) {
        JSObject data = new JSObject();
        data.put("deviceAddress", deviceAddress);
        data.put("percent", percent);
        data.put("speed", speed);
        data.put("avgSpeed", avgSpeed);
        data.put("currentPart", currentPart);
        data.put("partsTotal", partsTotal);
        notifyListeners("dfuProgressDidChange", data);
    }
}

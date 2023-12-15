import Foundation
import Capacitor
import NordicDFU

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NordicDFUPlugin)
public class NordicDFUPlugin: CAPPlugin, DFUServiceDelegate, DFUProgressDelegate {

    private var pendingCall: CAPPluginCall?
    private var pendingDfuController: DFUServiceController?
    private var pendingDeviceAddress: String?

    @objc func startDFU(_ call: CAPPluginCall) {
        if self.pendingDfuController != nil {
            call.reject("dfu pending")
            return
        }

        guard let filePath = call.getString("filePath") else {
            call.reject("filePath is empty")
            return
        }

        guard let fileURL = URL(string: filePath) else {
            call.reject("invalid filePath")
            return
        }

        guard let deviceAddress = call.getString("deviceAddress") else {
            call.reject("deviceAddress is empty")
            return
        }

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            call.reject("file is not exist")
            return
        }

        guard let deviceUUID = UUID(uuidString: deviceAddress) else {
            call.reject("invalid deviceAddress")
            return
        }

        let forceDfu = call.getBool("forceDfu")
        let enableUnsafeExperimentalButtonlessServiceInSecureDfu = call.getBool("enableUnsafeExperimentalButtonlessServiceInSecureDfu")
        let disableResume = call.getBool("disableResume")
        let forceScanningForNewAddressInLegacyDfu = call.getBool("forceScanningForNewAddressInLegacyDfu")
        let dataObjectPreparationDelay = call.getDouble("dataObjectPreparationDelay")

        do {
            let dfuFirmware = try DFUFirmware(urlToZipFile: fileURL)
            let dfuInitiator = DFUServiceInitiator(queue: nil).with(firmware: dfuFirmware)

            if forceDfu != nil {
                dfuInitiator.forceDfu = forceDfu!
            }
            if enableUnsafeExperimentalButtonlessServiceInSecureDfu != nil {
                dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = enableUnsafeExperimentalButtonlessServiceInSecureDfu!
            }
            if disableResume != nil {
                dfuInitiator.disableResume = disableResume!
            }
            if forceScanningForNewAddressInLegacyDfu != nil {
                dfuInitiator.forceScanningForNewAddressInLegacyDfu = forceScanningForNewAddressInLegacyDfu!
            }
            if dataObjectPreparationDelay != nil {
                dfuInitiator.dataObjectPreparationDelay = dataObjectPreparationDelay!
            }

            // delegate
            dfuInitiator.delegate = self
            dfuInitiator.progressDelegate = self

            self.pendingCall = call
            self.pendingDeviceAddress = deviceAddress
            self.pendingDfuController = dfuInitiator.start(targetWithIdentifier: deviceUUID)
        } catch {
            call.reject("could not start dfu")
        }
    }

    @objc func abortDFU(_ call: CAPPluginCall) {
        _ = self.pendingDfuController?.abort()

        self.pendingDfuController = nil

        call.resolve()
    }

    public func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int,
                                     currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        notifyListeners("dfuProgressDidChange", data: [
            "deviceAddress": self.pendingDeviceAddress ?? "",
            "currentPart": part,
            "partsTotal": totalParts,
            "percent": progress,
            "speed": currentSpeedBytesPerSecond,
            "avgSpeed": avgSpeedBytesPerSecond
        ])
    }

    public func dfuStateDidChange(to state: DFUState) {
        switch state {
        case .completed:
            self.pendingCall?.resolve()

            self.pendingCall = nil
            self.pendingDfuController = nil
            self.pendingDeviceAddress = nil
        case .aborted:
            self.pendingCall?.reject("Aborted", nil, nil, [
                "deviceAddress": self.pendingDeviceAddress ?? "",
                "error": -1,
                "message": "Aborted"
            ])

            self.pendingCall = nil
            self.pendingDfuController = nil
            self.pendingDeviceAddress = nil
        case .connecting, .starting, .enablingDfuMode, .uploading, .validating, .disconnecting:
            notifyListeners("dfuStateDidChange", data: ["state": state.description, "deviceAddress": self.pendingDeviceAddress ?? ""])
        }
    }

    public func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        self.pendingCall?.reject(message, nil, nil, [
            "deviceAddress": self.pendingDeviceAddress ?? "",
            "error": error,
            "message": message
        ])

        self.pendingCall = nil
        self.pendingDfuController = nil
        self.pendingDeviceAddress = nil
    }

}

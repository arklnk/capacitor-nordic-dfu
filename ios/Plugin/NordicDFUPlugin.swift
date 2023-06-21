import Foundation
import Capacitor
import iOSDFULibrary

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NordicDFUPlugin)
public class NordicDFUPlugin: CAPPlugin, LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate {

    public func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int,
                                     currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        
    }
    
    public func dfuStateDidChange(to state: iOSDFULibrary.DFUState) {
        notifyListeners("dfuStateDidChange", data: ["state": state.description])
    }
    
    public func dfuError(_ error: iOSDFULibrary.DFUError, didOccurWithMessage message: String) {
        
    }
    
    public func logWith(_ level: iOSDFULibrary.LogLevel, message: String) {
        
    }

    @objc func startDFU(_ call: CAPPluginCall) {
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
        
        let forceDfu = call.getBool("forceDfu", false)
        let enableUnsafeExperimentalButtonlessServiceInSecureDfu = call.getBool("enableUnsafeExperimentalButtonlessServiceInSecureDfu", false)
        let disableResume = call.getBool("disableResume", false)
        
        do {
            let dfuFirmware = try DFUFirmware(urlToZipFile: fileURL)
            let dfuInitiator = DFUServiceInitiator(queue: DispatchQueue(label: "DFU"))
            
            dfuInitiator.forceDfu = forceDfu
            dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = enableUnsafeExperimentalButtonlessServiceInSecureDfu
            dfuInitiator.disableResume = disableResume
            
            // delegate
            dfuInitiator.logger = self
            dfuInitiator.delegate = self
            dfuInitiator.progressDelegate = self
            
            guard let _ = dfuInitiator
                .with(firmware: dfuFirmware).start(targetWithIdentifier: deviceUUID) else {
                call.reject("initial failure")
                return
            }
        } catch {
            call.reject("dfu start error")
        }
    }
}

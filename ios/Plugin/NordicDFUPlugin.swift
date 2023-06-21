import Foundation
import Capacitor
import iOSDFULibrary

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NordicDFUPlugin)
public class NordicDFUPlugin: CAPPlugin, LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate {

    public func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        
    }
    
    public func dfuStateDidChange(to state: iOSDFULibrary.DFUState) {
        notifyListeners("dfuStateDidChange", data: ["state": state.description])
    }
    
    public func dfuError(_ error: iOSDFULibrary.DFUError, didOccurWithMessage message: String) {
        
    }
    
    public func logWith(_ level: iOSDFULibrary.LogLevel, message: String) {
        
    }

    @objc func startDFU(_ call: CAPPluginCall) {
        guard let fileUrlString = call.getString("fileurl") else {
            call.reject("fileurl is empty")
            return
        }
        
        guard let fileURL = URL(string: fileUrlString) else {
            call.reject("invalid fileurl")
            return
        }
        
        guard let peripheral = call.getString("peripheral") else {
            call.reject("peripheral is empty")
            return
        }
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            call.reject("file is not exist")
            return
        }
        
        guard let deviceUUID = UUID(uuidString: peripheral) else {
            call.reject("invalid peripheral uuid")
            return
        }
        
        do {
            let dfuFirmware = try DFUFirmware(urlToZipFile: URL(string: fileUrlString)!)
            let dfuInitiator = DFUServiceInitiator(queue: DispatchQueue(label: "DFU"))
            
            dfuInitiator.forceDfu = false
            
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

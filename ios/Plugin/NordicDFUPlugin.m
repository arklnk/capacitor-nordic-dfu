#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(NordicDFUPlugin, "NordicDFU",
           CAP_PLUGIN_METHOD(startDFU, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(abortDFU, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeAllListeners, CAPPluginReturnPromise);
)

import type { PluginListenerHandle } from '@capacitor/core';

export interface NordicDFUPlugin {
  startDFU(options: StartDFUOptions): Promise<void>;

  abortDFU(): Promise<void>;

  addListener(
    eventName: 'dfuStateDidChange',
    listenerFunc: (params: { state: string; deviceAddress?: string }) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  addListener(
    eventName: 'dfuProgressDidChange',
    listenerFunc: (params: {
      percent: number;
      speed: number;
      avgSpeed: number;
      currentPart: number;
      partsTotal: number;
      deviceAddress?: string;
    }) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  removeAllListeners(): Promise<void>;
}

export interface StartDFUOptions {
  /**
   * Supported Platforms: Android \ iOS
   */
  filePath: string;

  /**
   * Supported Platforms: Android \ iOS
   */
  deviceAddress: string;

  /**
   * Supported Platforms: Android \ iOS
   */
  forceDfu?: boolean;

  /**
   * Supported Platforms: Android \ iOS
   */
  enableUnsafeExperimentalButtonlessServiceInSecureDfu?: boolean;

  /**
   * Supported Platforms: Android \ iOS
   */
  forceScanningForNewAddressInLegacyDfu?: boolean;

  /**
   * Supported Platforms: Android \ iOS
   */
  disableResume?: boolean;
  /**
   * Supported Platforms: Android
   */
  foreground?: boolean;
  /**
   * Supported Platforms: Android
   */
  disableNotification?: boolean;
}

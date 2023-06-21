import type { PluginListenerHandle } from '@capacitor/core';

export interface NordicDFUPlugin {
  startDFU(options: {
    filePath: string;
    deviceAddress: string;
    forceDfu?: boolean;
    enableUnsafeExperimentalButtonlessServiceInSecureDfu?: boolean;
    disableResume?: boolean;
  }): Promise<void>;

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

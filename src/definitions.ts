import type { PluginListenerHandle } from '@capacitor/core';

export interface NordicDFUPlugin {
  startDFU(options: { fileurl: string, peripheral: string }): Promise<void>;

  addListener(
    eventName: 'dfuStateDidChange',
    listenerFunc: (params: { state: string }) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  removeAllListeners(): Promise<void>;
}

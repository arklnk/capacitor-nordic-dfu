export interface NordicDFUPlugin {
  startDFU(options: { fileurl: string, peripheral: string }): Promise<void>;
}

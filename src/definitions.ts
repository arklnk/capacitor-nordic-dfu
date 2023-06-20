export interface NordicDFUPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}

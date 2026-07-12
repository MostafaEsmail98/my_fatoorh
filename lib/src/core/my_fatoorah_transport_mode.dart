/// Controls where SDK HTTP requests are sent.
enum MyFatoorahTransportMode {
  /// Send requests to a merchant-controlled backend proxy.
  ///
  /// The backend should hold the MyFatoorah API key and forward the supported
  /// SDK endpoint paths to MyFatoorah.
  backendProxy,
}

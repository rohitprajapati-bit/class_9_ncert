class AppConfig {
  String? appName;
  String? appVersion;
  int? appVersionCode;
  bool? bookJsonModified;
  bool? showAds;
  bool? showNativeAds;
  bool? enableDownload;

  AppConfig(
      {this.appName,
      this.appVersion,
      this.appVersionCode,
      this.bookJsonModified,
      this.showAds,
      this.showNativeAds,
      this.enableDownload});

  AppConfig.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appVersion = json['app_version'];
    appVersionCode = json['app_version_code'];
    bookJsonModified = json['bookJsonModified'];
    showAds = json['showAds'];
    showNativeAds = json['showNativeAds'];
    enableDownload = json['enableDownload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['app_version'] = appVersion;
    data['app_version_code'] = appVersionCode;
    data['bookJsonModified'] = bookJsonModified;
    data['showAds'] = showAds;
    data['showNativeAds'] = showNativeAds;
    data['enableDownload'] = enableDownload;
    return data;
  }
}

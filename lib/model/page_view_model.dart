class PageViewModel {
  int id;
  String imgeUrl;
  PageViewModel(this.id, this.imgeUrl);

  factory PageViewModel.fromJson(Map<String, dynamic> jsonObject) {
    return PageViewModel(jsonObject['id'], jsonObject['image_url']);
  }
}

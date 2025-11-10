class PageViewModel {
  int id;
  String imgUrl;
  PageViewModel(this.id, this.imgUrl);

  factory PageViewModel.fromJson(Map<String, dynamic> jsonObject) {
    return PageViewModel(jsonObject['id'], jsonObject['imgUrl']);
  }
}

class PageViewModel {
  int id;
  String imageUrl;
  PageViewModel(this.id, this.imageUrl);

  factory PageViewModel.fromJson(Map<String, dynamic> jsonObject) {
    return PageViewModel(jsonObject['id'], jsonObject['image_url']);
  }
}

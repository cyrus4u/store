class EventsModel {
  String imageUrl;
  EventsModel(this.imageUrl);
  factory EventsModel.fromJson(Map<String, dynamic> jsonObject) {
    return EventsModel(jsonObject['image_url'] ?? '');
  }
}

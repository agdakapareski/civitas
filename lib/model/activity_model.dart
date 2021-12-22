class ActivityModel {
  int? id;
  String? userId;
  String? activity;
  String? place;
  String? room;
  String? course;
  String? note;
  String? isActive;
  String? createdAt;
  String? userName;
  String? userJob;
  String? userPicture;

  ActivityModel({
    this.id,
    this.userId,
    this.activity,
    this.place,
    this.room,
    this.course,
    this.note,
    this.isActive,
    this.createdAt,
    this.userName,
    this.userJob,
    this.userPicture,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      userId: json['user_id'],
      activity: json['activity'],
      place: json['place'],
      room: json['class'],
      course: json['course'],
      note: json['note'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      userName: json['user']['name'],
      userJob: json['user']['job'],
      userPicture: json['user']['picture'],
    );
  }
}

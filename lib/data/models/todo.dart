class Todo {
  int? id;
  int? parentId;
  String? taskName;
  bool? isDone;
  String? startDate;
  String? dueDate;
  bool? starred;
  int? createdAt;
  int? updatedAt;

  Todo(
      {this.id,
      this.parentId,
      this.taskName,
      this.isDone,
      this.startDate,
      this.dueDate,
      this.starred,
      this.createdAt,
      this.updatedAt});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    taskName = json['taskName'];
    isDone = json['isDone'];
    startDate = json['startDate'].toString();
    dueDate = json['dueDate'].toString();
    starred = json['starred'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parentId'] = parentId;
    data['taskName'] = taskName;
    data['isDone'] = isDone;
    data['startDate'] = startDate;
    data['dueDate'] = dueDate;
    data['starred'] = starred;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

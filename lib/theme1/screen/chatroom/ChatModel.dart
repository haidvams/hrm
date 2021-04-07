
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/theme1/screen/employee/EmployeeModel.dart';

class AChatsModel {
  String avatar;
  String name;
  String employee_name;
  String type;
  String room_name;
  List users;
  dynamic last_message;

  AChatsModel({
    this.avatar,
    this.name,
    this.employee_name,
    this.last_message,
    this.type,
    this.room_name,
    this.users,
  });

  RestDatasource api = new RestDatasource();

  getProfile(String name) async {
    Iterable data = await api.getDataPublic('/api/resource/Employee/' + name);

    return data.map((model) => Profile.fromJson(model)).toList();
  }

  factory AChatsModel.fromJson(Map<String, dynamic> json) {
      return AChatsModel(
        name: json['name'] ??= null,
        employee_name: json["type"] == "Direct" ? json["users"].first : "Group",
        type: json['type'] ??= null,
        room_name: json['room_name'] ??= null,
        avatar: json['avatar'] ??= null,
        users: json['users'] ??= null,
        last_message: json['last_message'] ??= null,
      );
  }
}

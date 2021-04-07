
import 'package:flutter/material.dart';

class TaskModel {
  String subject;
  String owner;
  String report_to;
  String progress;
  String status;
  String complexity;
  String exp_end_date;
  String name;
  Color color;
  String project;
  String priority;
  double task_weight;
  String project_bucket;
  int score_volum;
  String score_process;
  String score_range;
  String score_complexity;
  String score_quality;
  String range;

  TaskModel({
    this.subject,
    this.owner,
    this.report_to,
    this.progress,
    this.name,
    this.color,
    this.status,
    this.complexity,
    this.project,
    this.priority,
    this.task_weight,
    this.project_bucket,
    this.exp_end_date,
    this.score_volum,
    this.score_process,
    this.score_range,
    this.score_complexity,
    this.score_quality,
    this.range,
  });

  static ChangeStatus(String status) {
    switch (status) {
      case "Pending":
        return "20";
        break;
      case "Overdue":
        return "00";
      case "Open":
        return "1O";
      case "Working":
        return "30";
      case "Completed":
        return "100";
        break;
    }
  }

  static ChangeColors(String status) {
    switch (status) {
      case "Pending":
        return Colors.blue;
        break;
      case "Overdue":
        return Colors.red;
      case "Open":
        return Colors.grey;
      case "Working":
        return Colors.yellow;
      case "Completed":
        return Colors.green;
        break;
    }
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      subject: json['subject'],
      owner: json['owner'],
      report_to: json['report_to'],
      progress: ChangeStatus(json['status']),
      status: json['status'],
      name: json['name'],
      complexity: json['complexity'],
      color: ChangeColors(json['status']),
      project: json['project'] ??= null,
      priority: json['priority'] ??= null,
      task_weight: json['task_weight'] ??= null,
      project_bucket: json['project_bucket'] ??= null,
      score_volum: json['score_volum'] ??= null,
      score_process: json['score_process'] ??= null,
      score_range: json['score_range'] ??= null,
      score_complexity: json['score_complexity'] ??= null,
      score_quality: json['score_quality'] ??= null,
      range: json['range'] ??= null,
      exp_end_date: json['exp_end_date'] ??= null,
    );
  }
}

class Profile {
  final String employee_name;
  final String employee;
  final String employment_type;
  final String company;
  final String date_of_joining;
  final String date_of_birth;
  final String emergency_phone_number;
  final String user_id;
  final String job_applicant;
  final String branch;
  final String department;
  final String designation;
  final String reports_to;
  final String expense_approver;
  final String leave_approver;
  final String shift_request_approver;
  final String salary_mode;
  final String bank_name;
  final String bank_ac_no;
  final String health_insurance_provider;
  final String health_insurance_no;
  final String bio;
  final String passport_number;
  final String date_of_issue;
  final String valid_upto;
  final String place_of_issue;
  final String family_background;
  final String blood_group;
  final String health_details;
  final String gender;
  final List education;
  final List external_work_history;
  final List internal_work_history;
  final String attendance_device_id;
  final String default_shift;
  final String payroll_cost_center;
  final String cell_number;
  final String prefered_email;

  Profile({
    this.employee_name,
    this.employee,
    this.employment_type,
    this.company,
    this.date_of_joining,
    this.date_of_birth,
    this.emergency_phone_number,
    this.user_id,
    this.job_applicant,
    this.branch,
    this.department,
    this.designation,
    this.reports_to,
    this.expense_approver,
    this.leave_approver,
    this.shift_request_approver,
    this.salary_mode,
    this.bank_name,
    this.bank_ac_no,
    this.health_insurance_provider,
    this.health_insurance_no,
    this.health_details,
    this.blood_group,
    this.bio,
    this.passport_number,
    this.date_of_issue,
    this.valid_upto,
    this.place_of_issue,
    this.family_background,
    this.education,
    this.external_work_history,
    this.internal_work_history,
    this.gender,
    this.attendance_device_id,
    this.default_shift,
    this.payroll_cost_center,
    this.cell_number,
    this.prefered_email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      employee: json['employee'] ??= null,
      employee_name: json['employee_name'] ??= null,
      employment_type: json['employment_type'] ??= null,
      company: json['company'] ??= null,
      date_of_joining: json['date_of_joining'] ??= null,
      date_of_birth: json['date_of_birth'] ??= null,
      emergency_phone_number: json['emergency_phone_number'] ??= null,
      user_id: json['user_id'] ??= null,
      job_applicant: json['job_applicant'] ??= null,
      branch: json['branch'] ??= null,
      department: json['department'] ??= null,
      designation: json['designation'] ??= null,
      reports_to: json['reports_to'] ??= null,
      expense_approver: json['expense_approver'] ??= null,
      leave_approver: json['leave_approver'] ??= null,
      shift_request_approver: json['shift_request_approver'] ??= null,
      salary_mode: json['salary_mode'] ??= null,
      bank_name: json['bank_name'] ??= null,
      bank_ac_no: json['bank_ac_no'] ??= null,
      health_insurance_provider: json['health_insurance_provider'] ??= null,
      health_insurance_no: json['health_insurance_no'] ??= null,
      health_details: json['health_details'] ??= null,
      blood_group: json['blood_group'] ??= null,
      bio: json['bio'] ??= null,
      passport_number: json['passport_number'] ??= null,
      date_of_issue: json['date_of_issue'] ??= null,
      valid_upto: json['valid_upto'] ??= null,
      place_of_issue: json['place_of_issue'] ??= null,
      family_background: json['family_background'] ??= null,
      education: json['education'] ??= null,
      external_work_history: json['external_work_history'] ??= null,
      internal_work_history: json['internal_work_history'] ??= null,
      gender: json['gender'] ??= null,
      attendance_device_id: json['attendance_device_id'] ??= null,
      default_shift: json['default_shift'] ??= null,
      payroll_cost_center: json['payroll_cost_center'] ??= null,
      cell_number: json['cell_number'] ??= null,
      prefered_email: json['prefered_email'] ??= null,
    );
  }
}

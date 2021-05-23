class ModelSheet {
  final String _uin;
  final String _date;
  final String _leaveType;

  ModelSheet(this._uin, this._date, this._leaveType);
  String toParams() => "?uin=$_uin&date=$_date&leavetype=$_leaveType";
}

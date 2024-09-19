class ListOutLet{
  final int status;
  final String message;
  final List<Data> data;

  ListOutLet({
    required this.status,
    required this.message,
    required this.data
  });
}

class Data{
  final int outletId;
  final String outletName;
  final String outletAddress;
  final int areaId;
  final String areaName;
  final String photo;
  final String latitude;
  final String longtitude;
  final String createdAt;
  final int createdBy;
  final bool activeFlag;

  Data({
    required this.outletId,
    required this.outletName,
    required this.outletAddress,
    required this.areaId,
    required this.areaName,
    required this.photo,
    required this.latitude,
    required this.longtitude,
    required this.createdAt,
    required this.createdBy,
    required this.activeFlag,
  });

}
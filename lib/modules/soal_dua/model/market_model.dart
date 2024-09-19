class MarketModel {
  String? marketKode;
  final String marketName;
  final String marketAddress;
  final String latitudeLongitude;
  final String photo;
  final String photoPath;
  final String createdDate;
  final String updatedDate;


  MarketModel({
    this.marketKode,
    required this.marketName,
    required this.marketAddress,
    required this.latitudeLongitude,
    required this.photo,
    required this.photoPath,
    required this.createdDate,
    required this.updatedDate
  });

  Map<String, dynamic> toMap(){
    return {
    'market_kode' : marketKode,
    'market_name' : marketName,
    'market_address' : marketAddress,
    'latitude_longitude' : latitudeLongitude,
    'photo' : photo,
    'photo_path' : photoPath,
    'created_date' : createdDate,
    'updated_date' : updatedDate,
    };
  }

  factory MarketModel.fromMap(Map<String,dynamic> map){
    return MarketModel(
        marketKode: map['market_kode'],
        marketName: map['market_name'],
        marketAddress: map['market_address'],
        latitudeLongitude: map['latitude_longitude'],
        photo: map['photo'],
        photoPath: map['photo_path'],
        createdDate: map['created_date'],
        updatedDate: map['updated_date']
    );
  }

}
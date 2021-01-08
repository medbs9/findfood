class Product {
  String pName;
  String pPrice;
  String pLocation;
  String pDescription;
  String pCategory;
  String plat;
  String plong;
  int pQuantity;
  String pSoc;
  String pId;
  String puser;
  String pcodep;
  String padresse;
  String date;
  String time;
  List<String> searchindex;

  Product(
      {this.pQuantity,
      this.searchindex,
      this.padresse,
      this.pcodep,
      this.puser,
      this.pName,
      this.pId,
      this.date,
      this.time,
      this.pCategory,
      this.pDescription,
      this.pLocation,
      this.plat,
      this.pSoc,
      this.plong,
      this.pPrice});
}

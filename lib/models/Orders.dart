class Order {
  String iName;
  String iQuantity;
  String iImage;
  String iPrice;
  String iuser;
  String orderid;
  List<dynamic> iproductuser;
  String dateTime;
  String username;
  Order({
    this.dateTime,
    this.orderid,
    this.username,
    this.iImage,
    this.iName,
    this.iproductuser,
    this.iPrice,
    this.iuser,
    this.iQuantity,
  });
}

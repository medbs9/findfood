import 'package:find_food/acheteur/Confirmer.dart';
import 'package:find_food/acheteur/components/carte.dart';
import 'package:find_food/acheteur/components/title_price_rating.dart';
import 'package:find_food/models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsScreen extends StatelessWidget {
  static String id = 'details';

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: size.height * 0.40,
                    padding: EdgeInsets.all(20),
                    //width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(product.pLocation),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${product.pSoc}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 45,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new CupertinoPageRoute(
                                            builder: (context) => Carte(
                                                  long: product.plong,
                                                  lat: product.plat,
                                                  addresse: product.padresse,
                                                )));
                                  },
                                  child: Text(
                                      "Cliquer ici pour voir la localisation")),
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TitlePriceRating(
                            name: "${product.pName}",
                            //numOfReviews: 24,
                            //rating: 4,
                            price: double.parse(product.pPrice),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${product.pDescription}",
                            style: TextStyle(
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: size.height * 0.1),
                          // Free space  10% of total height
                          //OrderButton(
                          //size: size,
                          //press: () {},
                          // )
                          Container(
                            // padding: EdgeInsets.all(20),
                            width: size.width * 0.8,
                            // it will cover 80% of total width
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, Confirmer.id,
                                      arguments: product);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/icons/bag.svg"),
                                      SizedBox(width: 10),
                                      Text(
                                        "Order Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

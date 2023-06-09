import 'package:ecommerce/controller/CartController.dart';
import 'package:ecommerce/screens/details/components/ProductPrice.dart';
import 'package:ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../models/Product.dart';
import '../../../size_config.dart';
import 'product_description.dart';
import 'product_images.dart';
import 'top_rounded_container.dart';

class Body extends StatefulWidget {
  final Product product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CartController cartController = CartController();
  final ValueNotifier<int> quantity = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView(
      children: [
        ProductImage(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    ProductPrice(product: widget.product, quantity: quantity),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: "Add To Cart",
                          press: () {_addToCart();},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addToCart() async {
    int selectedQuantity = quantity.value;
    int productQuantity =
        widget.product.quantity; // Số lượng sản phẩm trong kho từ Firestore

    if (selectedQuantity > productQuantity) {
      // Hiển thị thông báo số lượng vượt quá tồn kho
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Số lượng sản phẩm vượt quá số lượng tồn kho.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    } else {
        User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, SignInScreen.routeName);
    } else{
      // Thêm sản phẩm vào giỏ hàng
      await cartController.addProductToCart(
        user.uid, // Thay thế 'userId' bằng mã người dùng thích hợp
        widget.product.id,
        selectedQuantity,
      );

      // Hiển thị thông báo thêm thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Sản phẩm đã được thêm vào giỏ hàng thành công.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    }

    }
  }
}

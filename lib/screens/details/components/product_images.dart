import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductImage extends StatefulWidget {
  final Product product;

  const ProductImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late ImageProvider productImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      String downloadURL =
          await storage.refFromURL(widget.product.imageUrl).getDownloadURL();
      setState(() {
        productImage = NetworkImage(downloadURL);
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product.id.toString(),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Image(image: productImage),
            ),
          ),
        ),
      ],
    );
  }
}

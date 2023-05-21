import 'package:ecommerce/controller/CategoryController.dart';
import 'package:ecommerce/models/Category.dart';
import 'package:ecommerce/screens/home/components/category_product.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final categoryController = CategoryController();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    await categoryController.fetchCategories();
    _categories = categoryController.categories;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SizedBox(
      height: getProportionateScreenWidth(80),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) => CategoryCard(
          icon: _categories[index].icon,
          text: _categories[index].name,
          press: () {
            String categoryName = _categories[index].name;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductsScreen(categoryName: categoryName),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.text,
    //icon of categories
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text;
  final String icon;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.only(right: getProportionateScreenWidth(10)),
        child: SizedBox(
          width: getProportionateScreenWidth(55),
          child: Column(
            children: [
              SizedBox(height: 5),
              Text(text, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}

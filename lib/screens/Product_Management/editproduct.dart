import 'dart:io';
import 'package:ecommerce/controller/BrandController.dart';
import 'package:ecommerce/controller/CategoryController.dart';
import 'package:ecommerce/models/Brand.dart';
import 'package:ecommerce/models/Category.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _isOutOfStock = false;
  final _formKey = GlobalKey<FormState>();
  final categoryController = CategoryController();
  List<Category> _categories = [];
  final brandController = BrandController();
  List<Brand> _brands = [];
  Category? _selectedCategory;
  Brand? _selectedBrand;
  XFile? _selectedImage;
  String? _productName;
  String? _productDescription;
  int? _productPrice;
  int? _productQuantity;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchBrands();
    // Initialize form fields with existing product data
    _productName = widget.product.name;
    _productDescription = widget.product.description;
    _productPrice = widget.product.price;
    _productQuantity = widget.product.quantity;
    // Set the selected category and brand based on the existing product's category and brand


  }

  Future<void> fetchCategories() async {
    await categoryController.fetchCategories();
    setState(() {
      _categories = categoryController.categories;
            _selectedCategory = _categories.firstWhere(
      (category) => category.id == widget.product.categoryId,
    );
    });
  }

  Future<void> fetchBrands() async {
    await brandController.fetchBrands();

    setState(() {
      _brands = brandController.brands;

        _selectedBrand = _brands.firstWhere(
      (brand) => brand.id == widget.product.brandId,
    );
    });
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _updateProduct() async {
    final fileName = Uuid().v4(); // Generate a unique file name for the image
    final imagePath = 'product_images/$fileName.jpg';
    // Save the updated data from the form fields
    _formKey.currentState?.save();
    try {
      if (_selectedImage != null) {
        // Upload the image to Firebase Storage and get the download URL
        final imageUrl = await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .putFile(File(_selectedImage!.path))
            .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
        // Create a new Product object with updated values
        Product updatedProduct = Product(
          id: widget.product.id,
          name: _productName!,
          description: _productDescription!,
          imageUrl: imageUrl,
          brandId: _selectedBrand?.id ?? widget.product.brandId,
          categoryId: _selectedCategory?.id ?? widget.product.categoryId,
          couponId: widget.product.couponId,
          status: widget.product.status,
          price: _productPrice!,
          quantity: _productQuantity!,
          createdDate: widget.product.createdDate,
        );
        // Call the editProduct method from the Product class to update the product in Firestore
        await Product.editProduct(updatedProduct);
      } else {
        Product updatedProduct = Product(
          id: widget.product.id,
          name: _productName!,
          description: _productDescription!,
          imageUrl: widget.product.imageUrl,
          brandId: _selectedBrand?.id ?? widget.product.brandId,
          categoryId: _selectedCategory?.id ?? widget.product.categoryId,
          couponId: widget.product.couponId,
          status: widget.product.status,
          price: _productPrice!,
          quantity: _productQuantity!,
          createdDate: widget.product.createdDate,
        );
        // Call the editProduct method from the Product class to update the product in Firestore
        await Product.editProduct(updatedProduct);
      }
      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thành công'),
            content: Text('Cập nhật thông tin sản phẩm thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đã xảy ra lỗi trong quá trình cập nhật sản phẩm'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa thông tin sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: _selectedImage != null
                      ? Image.file(
                          File(_selectedImage!.path),
                        )
                      : widget.product.imageUrl.isNotEmpty
                          ? Image.network(widget.product.imageUrl)
                          : Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _productName,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productName = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _productDescription,
                decoration: InputDecoration(labelText: 'Miêu tả sản phẩm'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập miêu tả sản phẩm';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productDescription = value;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _productPrice?.toString(),
                      decoration: InputDecoration(labelText: 'Giá'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giá';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _productPrice = int.tryParse(value ?? '') ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _productQuantity?.toString(),
                      decoration: InputDecoration(labelText: 'Số lượng'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số lượng';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _productQuantity = int.tryParse(value ?? '') ?? 0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items: _categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (Category? value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (Category? value) {
                  if (value == null) {
                    return 'Vui lòng chọn category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Brand>(
                decoration: InputDecoration(labelText: 'Brand'),
                value: _selectedBrand,
                items: _brands.map((Brand brand) {
                  return DropdownMenuItem<Brand>(
                    value: brand,
                    child: Text(brand.name),
                  );
                }).toList(),
                onChanged: (Brand? value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
                validator: (Brand? value) {
                  if (value == null) {
                    return 'Vui lòng chọn brand';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle adding the product
                    _formKey.currentState!.save();
                    _updateProduct();
                  }
                },
                child: Text('Cập nhật sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

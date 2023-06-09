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

class AddProductScreen extends StatefulWidget {
  static const String routeName = "/add_product";
  const AddProductScreen({Key? key}) : super(key: key);
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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
  }

  Future<void> fetchCategories() async {
    await categoryController.fetchCategories();
    setState(() {
      _categories = categoryController.categories;
    });
  }

  Future<void> fetchBrands() async {
    await brandController.fetchBrands();
    setState(() {
      _brands = brandController.brands;
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

  Future<void> _uploadImageAndAddProduct() async {
    if (_selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Vui lòng chọn một hình ảnh'),
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
      return;
    }

    final fileName = Uuid().v4(); // Generate a unique file name for the image
    final imagePath = 'product_images/$fileName.jpg';

    try {
      // Upload the image to Firebase Storage
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      final firebase_storage.UploadTask uploadTask =
          storageRef.putFile(File(_selectedImage!.path));
      final firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() {});

      // Get the image URL from Firebase Storage
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Create a new product instance
      final newProduct = Product(
        id: '', // Firestore will generate the ID
        name: _productName ?? '',
        description: _productDescription ?? '',
        imageUrl: imageUrl,
        brandId: _selectedBrand!.id,
        categoryId: _selectedCategory!.id,
        couponId: '000',
        status: 1,
        price: _productPrice ?? 0,
        quantity: _productQuantity ?? 0,
        createdDate: DateTime.now(),
      );

      // Add the new product to Firestore
      await Product.addProduct(newProduct);

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thành công'),
            content: Text('Thêm sản phẩm thành công'),
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
    } catch (error) {
      // Handle any errors that occur during the upload process
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đã xảy ra lỗi trong quá trình tải lên ảnh'),
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
        title: Text('Thêm sản phẩm'),
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
                      : Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.grey[700],
                        ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
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
                    _uploadImageAndAddProduct();
                  }
                },
                child: Text('Thêm sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

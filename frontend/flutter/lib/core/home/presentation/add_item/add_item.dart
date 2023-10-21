import 'dart:io';
import 'package:agro_millets/core/home/application/home_manager.dart';
import 'package:agro_millets/core/home/presentation/widgets/loading_widget.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/utils/firebase_storage.dart';
import 'package:agro_millets/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddItemPage extends StatefulWidget {
  final HomeManager homeManager;
  const AddItemPage({Key? key, required this.homeManager}) : super(key: key);

  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
  late double height, width;

  String name = "", description = "",category="fruits",quantityType="kg";


  double price = 0.0, quantity=0.0;
  String imageUrl = "";
  bool pickedImage = false;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LoadingWidget(
      isLoading: isLoading,
      child: _getAddItemPage(context),
    );
    // return _getAddItemPage(context);
  }

  Scaffold _getAddItemPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Add Product",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _getFloatingActionButton(context),
      body: _getBody(),
    );
  }

  _getFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        isLoading.value = true;
        String itemId = const Uuid().v1();

        String url = await storageManager.uploadItemImage(itemId, File(imageUrl));
        // String url = "https://firebasestorage.googleapis.com/v0/b/kisan-7ffff.appspot.com/o/images%2Fitems%2Fgreen-grapes.jpeg?alt=media&token=4532f813-ebbf-40fc-b188-8fc99d45e938";

        await addItem(
          name: name,
          farmer: appState.value.user!.name,
          listedBy: appState.value.user!.id,
          description: description,
          category: category,
          images: [url],
          quantity: quantity,
          price: price, quantityType: quantityType,
        );
        isLoading.value = false;
        if (mounted) {
          Navigator.pop(context);
        }
      },
      label: Row(
        children: const [
          Text("Continue"),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ],
      ),
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        height: height,
        child: Column(
          children: [
            SizedBox(height: 0.02 * height),
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              reverseDuration: const Duration(seconds: 1),
              child: _getImageSelector(),
              layoutBuilder: (currentChild, previousChildren) =>
                  currentChild ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  _getImageSelector() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            height: 0.3 * height,
            width: double.infinity,
            child: pickedImage
                ? GestureDetector(
                    onTap: () {
                      pickAnImage();
                    },
                    child: Image.file(
                      File(imageUrl),
                      fit: BoxFit.contain,
                    ),
                  )
                : ActionButton(
                    onPressed: () async {
                      await pickAnImage();
                    },
                    text: ("Pick an Image"),
                  ),
          ),
        ),
        Container(
          height: 0.025 * height,
        ),
        _getTextField(
          "Name",
          ((e) => name = e),
          TextInputType.text,
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          value: category,
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: 'vegetables',
              child: Text('Vegetables'),
            ),
            DropdownMenuItem<String>(
              value: 'fruits',
              child: Text('Fruits'),
            ),
            DropdownMenuItem<String>(
              value: 'cereals',
              child: Text('Cereals'),
            ),
            DropdownMenuItem<String>(
              value: 'livestock',
              child: Text('Live stocks'),
            ),
            DropdownMenuItem<String>(
              value: 'oil',
              child: Text('Oil Seeds'),
            ),
            DropdownMenuItem<String>(
              value: 'pulses',
              child: Text('Pulses'),
            ),
            DropdownMenuItem<String>(
              value: 'cash',
              child: Text('Cash Crop'),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              category = newValue ?? '';
            });
          },
        ),
        _getTextField(
          "Description",
          ((e) => description = e),
          TextInputType.multiline,
        ),
        _getTextField(
          "Quantity",
          ((e) => quantity = double.parse(e)),
          TextInputType.number,
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Quantity Type',
            border: OutlineInputBorder(),
          ),
          value: quantityType,
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: 'kg',
              child: Text('K.G'),
            ),
            DropdownMenuItem<String>(
              value: 'litre',
              child: Text('Litre'),
            ),
            DropdownMenuItem<String>(
              value: 'count',
              child: Text('Count'),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              quantityType = newValue ?? '';
            });
          },
        ),_getTextField(
          "Price (Rs.)",
          ((e) => price = double.parse(e)),
          TextInputType.number,
        ),
      ],
    );
  }

  _getTextField(
    String hintText,
    Function onChange,
    TextInputType keyboardType,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            spreadRadius: 1.0,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: TextField(
        maxLines: null,
        keyboardType:  TextInputType.multiline,
        onChanged: (value) {
          onChange(value);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<bool> pickAnImage() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (file != null) {
      imageUrl = file.path;
      pickedImage = true;
      setState(() {});
      return true;
    }
    return false;
  }
}

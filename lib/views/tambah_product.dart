import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_online/services/product_services.dart';
import 'package:toko_online/widgets/alert.dart';
import 'package:toko_online/models/product_model.dart';

class TambahProductView extends StatefulWidget {
  final String title;
  final ProductModel? item;
  TambahProductView({required this.title, required this.item});

  @override
  State<TambahProductView> createState() => _TambahProductViewState();
}

class _TambahProductViewState extends State<TambahProductView> {
  // Instance service ditaruh di dalam State
  final ProductServices productServices = ProductServices();
  
  final formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController voteAverage = TextEditingController();
  final TextEditingController overView = TextEditingController();
  
  File? selectedImage;
  bool isLoading = false;

  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        selectedImage = File(img.path);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      title.text = widget.item!.nama_barang ?? "";
      voteAverage.text = widget.item!.harga?.toString() ?? "";
      overView.text = widget.item!.deskripsi ?? "";
    }
  }

  @override
  void dispose() {
    title.dispose();
    voteAverage.dispose();
    overView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: title,
                    decoration: InputDecoration(labelText: "Product Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'harus diisi';
                      }
                      return null;
                    }),
                TextFormField(
                    controller: voteAverage,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Price"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'harus diisi';
                      }
                      return null;
                    }),
                TextFormField(
                    controller: overView,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'harus diisi';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                TextButton.icon(
                    onPressed: getImage,
                    icon: Icon(Icons.image),
                    label: Text("Select Picture")),
                const SizedBox(height: 10),
                
                // Menampilkan status gambar
                if (selectedImage != null)
                  SizedBox(
                    height: 200,
                    child: Image.file(selectedImage!, fit: BoxFit.cover),
                  )
                else if (isLoading)
                  CircularProgressIndicator()
                else
                  const Center(child: Text("No Image Selected")),

                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var data = {
                            "nama_barang": title.text,
                            "harga": voteAverage.text,
                            "deskripsi": overView.text,
                          };

                          var result;
                          if (widget.item != null) {
                            // Update
                            result = await productServices.insertMovie(
                                data, selectedImage, widget.item!.id);
                          } else {
                            // Insert Baru
                            result = await productServices.insertMovie(
                                data, selectedImage, null);
                          }

                          if (result.status == true) {
                            AlertMessage().showAlert(context, result.message, true);
                            Navigator.pop(context, true); // Kembali dan beri sinyal refresh
                          } else {
                            AlertMessage().showAlert(context, result.message, false);
                          }
                        }
                      },
                      child: Text("Simpan")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
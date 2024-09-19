import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';
import 'package:savoria_test/modules/soal_dua/viewmodel/add_market_bloc.dart';
import 'package:savoria_test/modules/soal_dua/viewmodel/delete_market_bloc.dart';
import 'package:savoria_test/modules/soal_dua/viewmodel/detail_market_bloc.dart';
import 'package:savoria_test/modules/soal_dua/viewmodel/edit_market_bloc.dart';
import '../../../utils/snackbar_custom.dart';

class EditorMarketPage extends StatefulWidget {

  final String? marketKode;

  const EditorMarketPage({super.key, this.marketKode});

  @override
  EditorMarketPageState createState() => EditorMarketPageState();
}

class EditorMarketPageState extends State<EditorMarketPage> {

  // BLoC
  AddMarketBloc? addMarketBloc;
  EditMarketBloc? editMarketBloc;
  DeleteMarketBloc? deleteMarketBloc;
  DetailMarketBloc? detailMarketBloc;
  MarketModel? marketModel;

  // Text editing controller
  TextEditingController marketNameController = TextEditingController();
  TextEditingController marketAddressController = TextEditingController();

  // init variable
  Position? position;
  String marketName = "";
  String marketAddress = "";
  String latitude = "";
  String longitude = "";
  String createdAt = "";
  File? images;
  String fileName = "";

  @override
  void initState() {
    super.initState();
    addMarketBloc = AddMarketBloc();
    editMarketBloc = EditMarketBloc();
    deleteMarketBloc = DeleteMarketBloc();
    detailMarketBloc = DetailMarketBloc();
    getCurrentLocation();
    if (widget.marketKode != null) {
      detailMarketBloc!.getDetailMarket(widget.marketKode!);
    }
  }

  @override
  void dispose() {
    addMarketBloc!.close();
    editMarketBloc!.close();
    deleteMarketBloc!.close();
    detailMarketBloc!.close();
    marketNameController.clear();
    marketAddressController.clear();
    super.dispose();
  }

  // get latitude and longitude by current location
  Future<void> getCurrentLocation() async {
    bool enabledService;
    LocationPermission permission;

    enabledService = await Geolocator.isLocationServiceEnabled();
    if (!enabledService) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position? currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if (mounted) {
      setState(() {
        position = currentPosition;
        latitude = position!.latitude.toString();
        longitude = position!.longitude.toString();
      });
    }
  }

  // image picker from camera
  Future imagePickerFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (image == null) {
        return;
      }
      final tempImage = File(image.path);
      setState(() {
        images = tempImage;
        fileName = image.name;
      });
    } on PlatformException catch (e) {
      return e;
    }
  }

  // show image preview in dialog
  void showImagePreview() {
    if (images != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Image Preview'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InteractiveViewer(
                  child: Image.file(images!),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    imagePickerFromCamera();
                  },
                  child: const Text("Change Photo"),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    // date format
    final currentDateTime = DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);

    return MultiBlocProvider(
      providers: [
        // list provider
        BlocProvider(create: (context) => addMarketBloc!),
        BlocProvider(create: (context) => editMarketBloc!),
        BlocProvider(create: (context) => deleteMarketBloc!),
        BlocProvider(create: (context) => detailMarketBloc!),
      ],
      child: MultiBlocListener(
        listeners: [
          // list listener
          BlocListener<AddMarketBloc, AddMarketInitState>(
              listener: (context, state) {
                if (state is AddMarketSuccessState) {
                  showCustomSuccess(context, "Berhasil disimpan");
                } else if (state is AddMarketFailedState) {
                  showCustomFailed(context, "Gagal disimpan");
                }
              }
          ),
          BlocListener<EditMarketBloc, EditMarketInitState>(
              listener: (context, state) {
                if (state is EditMarketSuccessState) {
                  showCustomSuccess(context, "Berhasil diupdate");
                } else if (state is EditMarketFailedState) {
                  showCustomFailed(context, "Gagal diupdate");
                }
              }
          ),
          BlocListener<DeleteMarketBloc, DeleteMarketInitState>(
              listener: (context, state) {
                if (state is DeleteMarketSuccessState) {
                  showCustomSuccess(context, "Berhasil dihapus");
                } else if (state is DeleteMarketFailedState) {
                  showCustomFailed(context, "Gagal dihapus");
                }
              }
          ),
          BlocListener<DetailMarketBloc, DetailMarketInitState>(
              listener: (context, state) {
                if (state is DetailMarketSuccessState) {
                  marketModel = state.data;
                  // set existing data
                  if (marketModel != null) {
                    marketNameController.text = marketModel!.marketName;
                    marketAddressController.text = marketModel!.marketAddress;
                    fileName = marketModel!.photo;
                    if (marketModel!.photoPath.isNotEmpty) {
                      images = File(marketModel!.photoPath);
                    }
                    createdAt = marketModel!.createdDate;
                  }
                }
              }
          ),
        ],
        child: Scaffold(
            backgroundColor: const Color(0XFFE9E9EB),
            appBar: AppBar(
                title: const Text("New Market")
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text("Add New Market", style: TextStyle(fontWeight: FontWeight.bold)),

                            const SizedBox(height: 20),

                            TextFormField(
                              controller: marketNameController,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hoverColor: Colors.blue,
                                focusColor: Colors.blue,
                                fillColor: Colors.transparent,
                                hintText: "Name Market",
                                labelText: "Name Market",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              // validator: widget.validator,
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                              controller: marketAddressController,
                              textInputAction: TextInputAction.next,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hoverColor: Colors.blue,
                                focusColor: Colors.blue,
                                fillColor: Colors.transparent,
                                hintText: "Market Address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              // validator: widget.validator,
                            ),

                            const SizedBox(height: 20),

                            images == null ?
                            SizedBox(
                              width: double.infinity,
                              height: 100,
                              child: GestureDetector(
                                  onTap: () async {
                                    imagePickerFromCamera();
                                  },
                                  child: const Icon(Icons.camera_alt, size: 60, color: Color(0XFF00C4D6),)),
                            ) : Center(child: GestureDetector(
                                onTap: (){
                                  showImagePreview();
                                },
                                child: Image.file(images!, width: 100, height: 150))),

                            const SizedBox(height: 20),

                            if (widget.marketKode != null) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor: WidgetStateColor.resolveWith(
                                                  (states) => const Color(0xffD6AF00)),
                                          minimumSize: WidgetStateProperty.all(Size(
                                              MediaQuery.of(context).size.width, 50))),
                                      onPressed: () {
                                        editMarketBloc!.add(EditMarketEvent(
                                            marketKode: widget.marketKode!,
                                            marketName: marketNameController.text,
                                            marketAddress: marketAddressController.text,
                                            latitudeLongitude: "$latitude, $longitude",
                                            photo: fileName,
                                            photoPath: images?.path ?? "",
                                            createdDate: createdAt,
                                            updatedDate: formattedDateTime)
                                        );
                                      },
                                      child: const Text("Update",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(const Color(0xffD60004)),
                                        minimumSize: WidgetStateProperty.all(
                                          Size(MediaQuery.of(context).size.width, 50),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Konfirmasi Hapus Data'),
                                              content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteMarketBloc!.add(DeleteMarketEvent(marketKode: widget.marketKode!));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Ya'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ] else ...[
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateColor.resolveWith(
                                            (states) => const Color(0xff00C4D6)),
                                    minimumSize: WidgetStateProperty.all(Size(
                                        MediaQuery.of(context).size.width, 50))),
                                onPressed: () {
                                  addMarketBloc!.add(AddMarketEvent(
                                      marketName: marketNameController.text,
                                      marketAddress: marketAddressController.text,
                                      latitudeLongitude: "$latitude, $longitude",
                                      photo: fileName,
                                      photoPath: images?.path ?? "",
                                      createdDate: formattedDateTime,
                                      updatedDate: "")
                                  );
                                },
                                child: const Text("Save Market",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }
}

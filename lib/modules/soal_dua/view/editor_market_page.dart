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
import 'package:savoria_test/utils/textbutton_custom.dart';
import 'package:savoria_test/utils/textfield_custom.dart';
import '../../../utils/snackbar_custom.dart';
import '../../../widget/card_market.dart';
import '../../../widget/shimmer_widget.dart';
import '../viewmodel/list_market_bloc.dart';

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
  ListMarketBloc? listMarketBloc;

  List<MarketModel> listData = [];
  MarketModel? marketModel;

  // Text editing controller
  TextEditingController marketNameController = TextEditingController();
  TextEditingController marketAddressController = TextEditingController();

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // init variable
  Position? position;
  String marketName = "";
  String marketAddress = "";
  String latitude = "";
  String longitude = "";
  String createdAt = "";
  File? images;
  String fileName = "";
  String? currentMarketKode;

  @override
  void initState() {
    super.initState();
    addMarketBloc = AddMarketBloc();
    editMarketBloc = EditMarketBloc();
    deleteMarketBloc = DeleteMarketBloc();
    detailMarketBloc = DetailMarketBloc();
    listMarketBloc = ListMarketBloc();

    getCurrentLocation();
    currentMarketKode = widget.marketKode;
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
    listMarketBloc!.close();
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
        BlocProvider(create: (context) => listMarketBloc!..getListMarket()),
      ],
      child: MultiBlocListener(
        listeners: [
          // list listener
          BlocListener<AddMarketBloc, AddMarketInitState>(
              listener: (context, state) {
                if (state is AddMarketSuccessState) {
                  showCustomSuccess(context, "Berhasil disimpan");
                  Navigator.of(context).pop();
                } else if (state is AddMarketFailedState) {
                  showCustomFailed(context, "Gagal disimpan");
                }
              }
          ),
          BlocListener<EditMarketBloc, EditMarketInitState>(
              listener: (context, state) {
                if (state is EditMarketSuccessState) {
                  showCustomSuccess(context, "Berhasil diupdate");
                  Navigator.of(context).pop();
                } else if (state is EditMarketFailedState) {
                  showCustomFailed(context, "Gagal diupdate");
                }
              }
          ),
          BlocListener<DeleteMarketBloc, DeleteMarketInitState>(
              listener: (context, state) {
                if (state is DeleteMarketSuccessState) {
                  showCustomSuccess(context, "Berhasil dihapus");
                  Navigator.of(context).pop();
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
          resizeToAvoidBottomInset: false,
            backgroundColor: const Color(0XFFE9E9EB),
            appBar: AppBar(
                title: const Text("New Market")
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: formKey,
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

                              TextfieldCustom(
                                  controller: marketNameController,
                                  hintText: "Name Market",
                                  maxLine: 1,
                                  textInputAction: TextInputAction.next
                              ),

                              const SizedBox(height: 10),

                              TextfieldCustom(
                                  controller: marketAddressController,
                                  hintText: "Market Address",
                                  maxLine: 4,
                                  textInputAction: TextInputAction.newline
                              ),

                              const SizedBox(height: 20),

                              // jika path null (default) tampilkan icon camera
                              // ambil gambar baru
                              images == null ?
                              SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: GestureDetector(
                                    onTap: () async {
                                      imagePickerFromCamera();
                                    },
                                    child: const Icon(Icons.camera_alt, size: 60, color: Color(0XFF00C4D6),)),
                              )
                                  :
                              // jika path tidak null tampilkan preview image
                              Center(child: GestureDetector(
                                  onTap: (){
                                    showImagePreview();
                                  },
                                  child: Image.file(images!, width: 100, height: 150))),

                              const SizedBox(height: 20),

                              // jika marketkode tidak sama dengan null maka edit data
                              if (currentMarketKode != null) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextbuttonCustom(color: 0xffD6AF00, text: "Update", onPress: (){
                                        if(formKey.currentState!.validate()) {
                                          editMarketBloc!.add(EditMarketEvent(
                                            marketKode: currentMarketKode!,
                                            marketName: marketNameController.text,
                                            marketAddress: marketAddressController.text,
                                            latitudeLongitude: "$latitude, $longitude",
                                            photo: fileName,
                                            photoPath: images?.path ?? "",
                                            createdDate: createdAt,
                                            updatedDate: formattedDateTime)
                                          );
                                        }
                                      }),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: TextbuttonCustom(color: 0xffD60004, text: "Delete", onPress: (){
                                        showDialog(
                                          useRootNavigator: false,
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
                                                    deleteMarketBloc!.add(DeleteMarketEvent(marketKode: currentMarketKode!));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Ya'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                    )
                                  ],
                                )
                              ]
                              // jika marketkode sama dengan null maka tamba data baru
                              else ...[
                                TextbuttonCustom(color: 0xff00C4D6, text: "Save Market", onPress: (){
                                  if(formKey.currentState!.validate()) {
                                    if(images == null){
                                      showCustomWarning(context, "Gambar harus diisi");
                                    }else {
                                      addMarketBloc!.add(AddMarketEvent(
                                          marketName: marketNameController.text,
                                          marketAddress: marketAddressController.text,
                                          latitudeLongitude: "$latitude, $longitude",
                                          photo: fileName,
                                          photoPath: images?.path ?? "",
                                          createdDate: formattedDateTime,
                                          updatedDate: "")
                                      );
                                    }
                                  }
                                })
                              ]
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("List Market", style: TextStyle(fontWeight: FontWeight.bold)),
                          
                                const SizedBox(height: 20),
                          
                                BlocBuilder<ListMarketBloc, ListMarketInitState>(
                                  buildWhen: (context, state) => state is ListMarketLoadingState || state is ListMarketSuccessState || state is ListMarketEmptyState,
                                  builder: (context,state){
                                    if(state is ListMarketLoadingState){
                                      return const Expanded(child: ShimmerWidget());
                                    }
                                    else if(state is ListMarketEmptyState){
                                      return Center(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.info_rounded, color: Colors.black.withOpacity(0.5),),
                                          const SizedBox(height: 5),
                                          const Text("Tidak ada data"),
                                        ],
                                      ));
                                    }else if(state is ListMarketSuccessState){
                                      listData = state.listData;
                                      return Expanded(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  marketNameController.text = listData[index].marketName;
                                                  marketAddressController.text = listData[index].marketAddress;
                                                  fileName = listData[index].photo;
                                                  if (listData[index].photoPath.isNotEmpty) {
                                                    images = File(listData[index].photoPath);
                                                  }
                                                  createdAt = listData[index].createdDate;
                                                  currentMarketKode = listData[index].marketKode;
                                                });
                                              },
                                              child: CardMarket(marketModel: listData[index]),
                                            );
                                          },
                                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                                          itemCount: listData.length,
                                        ),
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )
        ),
    );
  }
}
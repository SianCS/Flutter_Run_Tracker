// ignore_for_file: sort_child_properties_last
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_run_trcker_app/models/run.dart';
import 'package:flutter_run_trcker_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class AddRunUi extends StatefulWidget {
  const AddRunUi({super.key});

  @override
  State<AddRunUi> createState() => _AddRunUiState();
}

class _AddRunUiState extends State<AddRunUi> {
  // -------- คำสั่งส่วนของการเปิดกล้อง+แกลอรี่ -------------------------------
  Uint8List? imageByte; //เก็บรูปที่จะใช้แสดงบน UI
  XFile? xFile; //เก็บรูปที่จะใช้อัปโหลดไปที่ Supabase

  // เมธอดเปิดกล้อง
  Future<void> openCameraAndTakePicture() async {
    //คำสั่งเปิดกล้องเพื่อถ่ายรูป
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    //เอารูปที่ถ่ายไปกำหนดให้กับตัวแปรด้านบนที่สร้างไว้ แต่ต้องตรวจสอบก่อนว่าเขาถ่ายไหม
    if (pickImage != null) {
      final bytes = await pickImage.readAsBytes();
      setState(() {
        imageByte = bytes;
        xFile = pickImage;
      });
    }
  }

  // เมธอดเปิดแกลอรี่
  Future<void> openGalleryAndSelectPicture() async {
    //คำสั่งเปิดแกลอรี่เพื่อเลือกรูป
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    //เอารูปที่เลือกไปกำหนดให้กับตัวแปรด้านบนที่สร้างไว้ แต่ต้องตรวจสอบก่อนว่าเขาเลือกไหม
    if (pickImage != null) {
      final bytes = await pickImage.readAsBytes();
      setState(() {
        imageByte = bytes;
        xFile = pickImage;
      });
    }
  }
  // --------------------------------------------------------------------

  // -------- ตัวควบคุม TextField ----------------------------------------
  TextEditingController runWhereCtrl = TextEditingController();
  TextEditingController runPersonCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนของ appBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 18, 84),
        title: Text(
          'Run Tracker (เพิ่ม)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      // ส่วนของ body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 65,
            left: 40,
            right: 40,
            bottom: 50,
          ),
          child: Center(
            child: Column(
              children: [
                //ใช้ Ternary Operator ____ ? _____ : _____
                xFile == null
                    ? InkWell(
                        onTap: () {
                          //เปิดกล้อง+แกลอรี่
                          openCameraAndTakePicture();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: MediaQuery.of(context).size.width * 0.45,
                          color: Colors.grey,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          //เปิดกล้อง+แกลอรี่
                          openCameraAndTakePicture();
                        },
                        child: Image.memory(
                          imageByte!,
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.width * 0.45,
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(
                  height: 45,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วิ่งที่ไหน',
                  ),
                ),
                TextField(
                  controller: runWhereCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    hintText: 'เช่น สวนสาธารณะ, .....',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วิ่งกับใคร',
                  ),
                ),
                TextField(
                  controller: runPersonCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    hintText: 'เช่น คุณเพื่อน, ครอบครัว, .....',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ระยะทาง (kg)',
                  ),
                ),
                TextField(
                  controller: runDistanceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    hintText: 'เช่น 1, 5, .....',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate UI
                    if (runWhereCtrl.text.isEmpty || runPersonCtrl.text.isEmpty || runDistanceCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('กรุณาป้อนข้อมูลให้ครบ...'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      return; //*** อย่าลืมใส่ return นะ
                    }

                    // upload ไฟล์ไป Bucket และบันทึกข้อมูลลง Table
                    // เริ่มจากอัปโหลดก่อน
                    // ตรวจสอบก่อนว่าเขาได้ถ่ายหรือเลือกรูปไหม
                    // สร้างตัวแปรเพื่อเก็บที่อยู่รูปกรณีมีการอัปโหลด
                    String imageUrl = '';
                    if (xFile != null) {
                      //แปลว่าได้ถ่ายหรือเลือก ก็จะทำการอัปโหลดไป Bucket
                      //แต่เมื่ออัปโหลดไปแล้วต้องได้ที่อยู่ของไฟล์เพื่อเอาไปบันทึกลง Table
                      imageUrl = await SupabaseService().uploadFileToSupabase(xFile!);
                    }

                    // อัปโหลดเสร็จ ต่อไปจะบันทึกลง Table
                    // โดยจะต้องแพ็กข้อมูลก่อนผ่าน Constructor ของ Run โมเดล
                    Run run = Run(
                      runWhere: runWhereCtrl.text,
                      runPerson: runPersonCtrl.text,
                      runDistance: int.parse(runDistanceCtrl.text),
                      runImageUrl: imageUrl,
                    );
                    // ส่งข้อมูลที่แพ็กไว้ไปบันทึกลง Table
                    await SupabaseService().insertDataToTableRun(run);

                    // บันทึกเสร็จเรียบร้อยแล้ว แสดงข้อความแจ้งนิ๊ดหนึ่ง ณ ที่นี้ใช้ SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('บันทึกข้อมูลเสร็จสิ้น'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // แสดงข้อความแจ้งเตือนแล้ว ต้องกลับไปหน้าหลัก
                    Navigator.pop(context);
                  },
                  child: Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 36, 145, 3),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

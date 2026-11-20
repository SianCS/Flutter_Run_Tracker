import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_run_trcker_app/models/run.dart';
import 'package:flutter_run_trcker_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDeleteUi extends StatefulWidget {
  // สร้างตัวแปรเพื่อรับข้อมูลการวิ่งที่ส่งมาจากหน้าจอ ShowAllRunUi
  Run? runDateShowUD;
  // เอาตัวแปรมารับค่าจาก constructor ของ class UpdateDeleteUi
  UpdateDeleteUi({super.key, this.runDateShowUD});

  @override
  State<UpdateDeleteUi> createState() => _UpdateDeleteUiState();
}

class _UpdateDeleteUiState extends State<UpdateDeleteUi> {
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

  // -------- ตัวควบคุม TextField ----------------------------------------
  TextEditingController runWhereCtrl = TextEditingController();
  TextEditingController runPersonCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    runWhereCtrl.text = widget.runDateShowUD?.runWhere ?? '';
    runPersonCtrl.text = widget.runDateShowUD?.runPerson ?? '';
    runDistanceCtrl.text = widget.runDateShowUD?.runDistance?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Run Tracker - Update/Delete Run",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.08,
            right: MediaQuery.of(context).size.width * 0.08,
            top: MediaQuery.of(context).size.height * 0.04,
          ),
          child: Center(
            child: Column(
              children: [
                // จัดการแสดงรูปภาพที่เลือกหรือถ่าย
                xFile != null
                    ? InkWell(
                        onTap: () {
                          //เปิดกล้อง+แกลอรี่
                          openCameraAndTakePicture();
                        },
                        child: Image.memory(
                          imageByte!,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.runDateShowUD?.runImageUrl != ""
                        ? InkWell(
                            onTap: () {
                              //เปิดกล้อง+แกลอรี่
                              openCameraAndTakePicture();
                            },
                            child: Image.network(
                              widget.runDateShowUD!.runImageUrl!,
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.3,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              //เปิดกล้อง+แกลอรี่
                              openCameraAndTakePicture();
                            },
                            child: Image.asset(
                              "assets/images/logo.png",
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                // Image.asset(
                //   "assets/images/logo.png",
                //   width: MediaQuery.of(context).size.width * 0.3,
                //   height: MediaQuery.of(context).size.height * 0.2,
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "วิ่งที่ไหน ?",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  controller: runWhereCtrl,
                  decoration: InputDecoration(
                    hintText: "สถานที่วิ่ง ....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "วิ่งกับใคร ?",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  controller: runPersonCtrl,
                  decoration: InputDecoration(
                    hintText: "เพื่อน แฟน ครอบครัว ....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ระยะทางที่วิ่ง (km)",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  controller: runDistanceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "กี่กิโลเมตร ....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Handle save action here
                    // update ข้อมูลลง Table Run ของ Supabase
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
                      //ก่อนอัปโหลดรูปให้ตรวจสอบก่อนว่ามีรูปเดิมอยู่ไหม ถ้ามีให้ลบรูปเดิมออกจาก Bucket ก่อน
                      if (widget.runDateShowUD!.runImageUrl != "") {
                        await SupabaseService().deleteFromBucketRun(
                          widget.runDateShowUD!.runImageUrl!.split('/').last,
                        );
                      }
                      //แต่เมื่ออัปโหลดไปแล้วต้องได้ที่อยู่ของไฟล์เพื่อเอาไปบันทึกลง Table
                      imageUrl = await SupabaseService().uploadFileToSupabase(xFile!);
                    } else {
                      //แปลว่าไม่ได้ถ่ายหรือเลือก ก็จะใช้ที่อยู่รูปเดิม
                      imageUrl = widget.runDateShowUD!.runImageUrl!;
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
                    await SupabaseService().updateDataToTableRun(run, widget.runDateShowUD!.runid!);

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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    minimumSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
                  ),
                  child: Text(
                    "บันทึก",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // ลบข้อมูลจากฐานข้อมูลและ Supabase Storage
                    // ถ้า runDateShowUD มีค่าและ runImageUrl ไม่ว่าง ให้ลบไฟล์รูปภาพออกจาก Supabase Storage ด้วย
                    if (widget.runDateShowUD!.runImageUrl != "") {
                      await SupabaseService().deleteFromBucketRun(
                        widget.runDateShowUD!.runImageUrl!.split('/').last,
                      );
                    }
                    // ลบข้อมูลจากฐานข้อมูล Supabase
                    await SupabaseService().deleteDataFromTableRun(
                      widget.runDateShowUD!.runid.toString(),
                    );

                    // แสดงข้อความยืนยันการลบข้อมูล snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context); // กลับไปยังหน้าจอ ShowAllRunUi หลังจากลบข้อมูลเรียบร้อยแล้ว
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, minimumSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06)),
                  child: Text(
                    "ลบข้อมูล",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
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

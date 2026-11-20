import 'package:flutter/material.dart';
import 'package:flutter_run_trcker_app/models/run.dart';
import 'package:flutter_run_trcker_app/services/supabase_service.dart';
import 'package:flutter_run_trcker_app/views/add_run_ui.dart';
import 'package:flutter_run_trcker_app/views/update_delete_ui.dart';

class ShowAllRunUi extends StatefulWidget {
  const ShowAllRunUi({super.key});

  @override
  State<ShowAllRunUi> createState() => _ShowAllRunUiState();
}

class _ShowAllRunUiState extends State<ShowAllRunUi> {
  // สร้างตัวแปร เก็ย ข้อมูลการวิ่งที่ดึงมาจาก supabase
  List<Run>? runs;

  // สร้าง method สำหรับดึงข้อมูลการวิ่งทั้งหมดจาก Supabase
  Future<void> fetchAllRuns() async {
    final data = await SupabaseService().getAllDataFromTableRun();

    setState(() {
      runs = data;
    });
  }

  @override
  void initState() {
    fetchAllRuns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Run Tracker",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRunUi(),
            ),
          );
          // เมื่อกลับมาจากหน้าจอ AddRunUi ให้ดึงข้อมูลการวิ่งทั้งหมดอีกครั้ง
          fetchAllRuns();
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Text(
              "วิ่งกันเถอะ",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // ส่วนของแสดงข้อมูล "วิ่งกันเถอะ"
            Expanded(
              child: ListView.separated(
                itemCount: runs?.length ?? 0,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () async {
                        //เมื่อกดที่ ListTile ให้ไปยังหน้าจอ AddRunUi และส่งข้อมูล Run ที่เลือกไปด้วย
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateDeleteUi(
                              runDateShowUD: runs![index],
                            ),
                          ),
                        );
                        // เมื่อกลับมาจากหน้าจอ AddRunUi ให้ดึงข้อมูลการวิ่งทั้งหมดอีกครั้ง
                        fetchAllRuns();
                      },
                      tileColor: index % 2 == 0 ? const Color.fromARGB(255, 171, 226, 249) : const Color.fromARGB(255, 133, 212, 249),
                      title: Text("วิ่งที่ไหน: ${runs![index].runWhere}"),
                      subtitle: Text("ระยะทาง: ${runs![index].runDistance} กม."),
                      trailing: Icon(
                        Icons.info,
                        color: Colors.orangeAccent,
                      ),
                      leading: runs![index].runImageUrl == ""
                          ? Image.asset(
                              "assets/images/logo.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              runs![index].runImageUrl!,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

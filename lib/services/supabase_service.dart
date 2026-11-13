import 'package:flutter_run_trcker_app/models/run.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //** สร้าง instance ของ SupabaseClient เพื่อใช้ในการเชื่อมต่อกับ Supabase Database และ Storage
  final supabase = Supabase.instance.client;

  //1.upload file to supabase storage
  Future<String> uploadFileToSupabase(XFile xfile) async {
    final newFileName =
        '${DateTime.now().millisecondsSinceEpoch}_${xfile.name}';

    await supabase.storage.from('run_bk').uploadBinary(
          newFileName,
          await xfile.readAsBytes(),
          fileOptions: FileOptions(contentType: xfile.mimeType),
        );

    return supabase.storage.from('run_bk').getPublicUrl(newFileName);
  }

  //2.add a new table to supabase database
  Future<void> insertDataToTableRun(Run run) async {
    await supabase.from('run_tb').insert(run.toJson());
  }

  //3.get data from supabase database
  Future<List<Run>> getAllDataFromTableRun() async {
    final response = await supabase.from('run_tb').select('*');
    return response.map((e) => Run.fromJson(e)).toList();
  }

  //4.delete data in supabase database
  Future<void> deleteFromBucketRun(String fileName) async {
    await supabase.storage.from('run_bk').remove([fileName]);
  }

//5. เมธอดแก้ไขข้อมูลใน Table:run_tb ----------------------------------
  Future<void> updateDataToTableRun(Run run, String id) async {
    await supabase.from('run_tb').update(run.toJson()).eq('id', id);
  }

  //6. เมธอดลบข้อมูลออกจาก Table:run_tb --------------------------------
  Future<void> deleteDataFromTableRun(String id) async {
    await supabase.from('run_tb').delete().eq('id', id);
  }
}

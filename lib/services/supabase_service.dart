// ไฟล์นี้เป็นไฟล์ Supabase Service ที่ใช้ในการเชื่อมต่อและจัดการข้อมูลกับ Supabase Database และ Storage
import 'dart:io';

import 'package:flutter_run_trcker_app/models/run.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //** สร้าง instance ของ SupabaseClient เพื่อใช้ในการเชื่อมต่อกับ Supabase Database และ Storage
  final supabase = Supabase.instance.client;

  //1.upload file to supabase storage
  Future<String?> uploadImageToSupabase(File imagefile) async {
    final newFileName =
        "${DateTime.now().millisecondsSinceEpoch}_${imagefile.path.split('/').last}";
    await supabase.storage.from('run_bk').upload(newFileName, imagefile);
    return supabase.storage.from('run_bk').getPublicUrl(newFileName);
  }

  //2.add a new table to supabase database
  Future<void> insertRunData(Run run) async {
    await supabase.from('run_tb').insert(run.toJson());
  }

  //3.get data from supabase database

  //4.update data in supabase database

  //5.delete data from supabase database
}

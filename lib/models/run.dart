class Run {
  String? runid;
  String? runWhere;
  String? runPerson;
  int? runDistance;
  String? runImageUrl;

  // Constructor
  Run({
    this.runid,
    this.runWhere,
    this.runPerson,
    this.runDistance,
    this.runImageUrl,
  });

  // แปลง Supabase ข้อมูลจาก JSON เป็น Object เพื่อใช้ใน Flutter
  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      runid: json['runid'] as String?,
      runWhere: json['runWhere'] as String?,
      runPerson: json['runPerson'] as String?,
      runDistance: json['runDistance'] as int?,
      runImageUrl: json['runImageUrl'] as String?,
    );
  }

  // แปลงข้อมูลจาก Object เป็น JSON เพื่อส่งไปยัง API
  Map<String, dynamic> toJson() {
    return {
      'runid': runid,
      'runWhere': runWhere,
      'runPerson': runPerson,
      'runDistance': runDistance,
      'runImageUrl': runImageUrl,
    };
  }
}

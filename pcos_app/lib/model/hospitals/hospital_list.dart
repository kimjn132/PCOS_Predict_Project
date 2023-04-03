// hospital list를 firebase에서 불러와서 마이페이지 방문한 병원 리스트에 출력하기 위해 담는 곳
class HospitalList {
  final String name;
  final String phone;
  final String address;

  HospitalList({required this.name, required this.phone, required this.address});

  factory HospitalList.fromMap(Map<String, dynamic> map) {
    return HospitalList(
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
    );
  }
}

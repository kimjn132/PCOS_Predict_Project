import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late TextEditingController tecEmail;
  late TextEditingController tecContent;
  late bool _isChecked;

  String dropdownValue = '질문 유형을 선택해 주세요.';
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    tecEmail = TextEditingController();
    tecContent = TextEditingController();
    _isChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800], // 앱바 색상 변경
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBA5A8), // 앱바 색상 변경
          foregroundColor: Colors.white, // 앱바 텍스트 색상 변경
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '문의 및 건의',
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    '휴일을 제외한 평일에는 하루 이내에 답변드리겠습니다.\n혹시 하루가 지나도 답변이 오지 않으면, 스팸 메일함을 확인해 주세요.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: tecEmail,
                    decoration: InputDecoration(
                      hintText: '이메일을 입력해 주세요.',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedType,
                              items: const [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    '질문 유형을 선택해 주세요.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: '이용 문의',
                                  child: Text('이용 문의'),
                                ),
                                DropdownMenuItem(
                                  value: '오류 신고',
                                  child: Text('오류 신고'),
                                ),
                                DropdownMenuItem(
                                  value: '서비스 제안',
                                  child: Text('서비스 제안'),
                                ),
                                DropdownMenuItem(
                                  value: '기타',
                                  child: Text('기타'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value;
                                });
                              },
                              hint: const Text(
                                '질문 유형을 선택해 주세요.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              disabledHint: const Text(
                                '질문 유형을 선택해 주세요.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: tecContent,
                    minLines: 8,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: '내용을 입력해 주세요.',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: const Color(0xFFFBA5A8),
                            title: const Text(
                              '이메일 정보 제공 동의',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: const Text(
                              '보내주신 질문에 답변드리기 위해 이메일 정보 제공에 동의해 주시기 바랍니다.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!tecEmail.text.isEmail) {
                          _showSnackBar('이메일');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBA5A8),
                      ),
                      child: const Text(
                        '보내기',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$text를 확인해주세요!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

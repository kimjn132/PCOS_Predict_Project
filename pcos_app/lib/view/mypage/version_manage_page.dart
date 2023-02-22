import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class VersionManagementPage extends StatefulWidget {
  const VersionManagementPage({Key? key}) : super(key: key);

  @override
  State<VersionManagementPage> createState() => _VersionManagementPageState();
}

class _VersionManagementPageState extends State<VersionManagementPage> {
  late final FirebaseRemoteConfig _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = FirebaseRemoteConfig.instance;
    _fetchRemoteConfig();
  }

  Future<void> _fetchRemoteConfig() async {
    await _remoteConfig.fetchAndActivate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const currentVersion = '1.0.0'; // 현재 버전
    final latestVersion =
        _remoteConfig.getString('latest_version'); // 원격 구성 값에서 최신 버전 가져오기

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '버전 관리',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              '버전 정보',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '현재 버전',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  currentVersion,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '최신 버전',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  latestVersion,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (currentVersion == latestVersion)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green[50],
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '지금 현재 최신버전을 사용중입니다!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    '업데이트 하기',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

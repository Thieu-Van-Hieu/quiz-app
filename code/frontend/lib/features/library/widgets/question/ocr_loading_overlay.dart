import 'package:flutter/material.dart';

class OcrLoadingOverlay extends StatelessWidget {
  const OcrLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Đang chờ quét vùng màn hình...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Vui lòng chọn vùng chứa câu hỏi",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

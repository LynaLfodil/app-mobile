import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carecaps2/common/color_extention.dart';
import 'package:carecaps2/services/firestore_service.dart' as fs;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class RecordsView extends StatefulWidget {
  const RecordsView({super.key});

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  String selectedCategory = "All";
  final _dateFmt = DateFormat('MMM d, yyyy');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String getDirectGoogleDriveLink(String url) {
    final regex = RegExp(r'^https:\/\/drive\.google\.com\/file\/d\/(.+?)\/');
    final match = regex.firstMatch(url);
    if (match != null) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return url;
  }

  String convertGoogleDriveLink(String url) {
    final regex = RegExp(r'drive\.google\.com\/file\/d\/(.+?)\/');
    final match = regex.firstMatch(url);
    if (match != null) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return url;
  }

  Future<void> _launchFileUrl(
    String fileUrl, {
    bool openExternally = true,
  }) async {
    try {
      String finalUrl = fileUrl;

      if (fileUrl.startsWith('gs://')) {
        final ref = FirebaseStorage.instance.refFromURL(fileUrl);
        finalUrl = await ref.getDownloadURL();
      } else if (fileUrl.contains('drive.google.com')) {
        finalUrl = getDirectGoogleDriveLink(fileUrl);
      }

      final uri = Uri.parse(finalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: openExternally
              ? LaunchMode.externalApplication
              : LaunchMode.platformDefault,
        );
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening document: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medical records",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF23414E),
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromARGB(197, 190, 207, 209),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Tcolor.primary2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["All", "Prescr", "Lab", "X-ray", "Visits"]
                      .map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Tcolor.primary2.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Tcolor.primary
                                  : Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<fs.MedicalRecord>>(
                stream: fs.FirestoreService().streamRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final all = snapshot.data ?? [];
                  final filtered = all.where((r) {
                    final matchesCategory = selectedCategory == "All" ||
                        r.category == selectedCategory;
                    final matchesSearch =
                        r.title.toLowerCase().contains(_searchQuery);
                    return matchesCategory && matchesSearch;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No records found"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final r = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(35, 88, 154, 178),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  r.icon,
                                  size: 28,
                                  color: const Color(0xFF23414E),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF23414E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            _dateFmt.format(r.date),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              r.location,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      Uri uri;
                                      if (r.fileUrl.startsWith('gs://')) {
                                        final ref = FirebaseStorage.instance
                                            .refFromURL(r.fileUrl);
                                        final downloadUrl =
                                            await ref.getDownloadURL();
                                        uri = Uri.parse(downloadUrl);
                                      } else {
                                        uri = Uri.parse(r.fileUrl.trim());
                                      }

                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(
                                          uri,
                                          mode:
                                              LaunchMode.externalApplication,
                                        );
                                      } else {
                                        throw 'Could not launch $uri';
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error opening document: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.visibility),
                                  label: const Text("View"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Tcolor.primary2,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      if (Platform.isAndroid) {
                                        var status =
                                            await Permission.storage.request();
                                        if (!status.isGranted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Storage permission is required.'),
                                            ),
                                          );
                                          return;
                                        }
                                      }

                                      String fileUrl = r.fileUrl.trim();
                                      if (fileUrl.startsWith('gs://')) {
                                        final ref = FirebaseStorage.instance
                                            .refFromURL(fileUrl);
                                        fileUrl = await ref.getDownloadURL();
                                      }
                                      if (fileUrl
                                          .contains('drive.google.com')) {
                                        fileUrl =
                                            convertGoogleDriveLink(fileUrl);
                                      }

                                      Directory? downloadsDir;
                                      if (Platform.isAndroid) {
                                        downloadsDir = Directory(
                                            '/storage/emulated/0/Download');
                                      } else {
                                        downloadsDir =
                                            await getApplicationDocumentsDirectory();
                                      }

                                      final savePath =
                                          '${downloadsDir.path}/${r.title.replaceAll(" ", "_")}.pdf';

                                      final dio = Dio();
                                      await dio.download(fileUrl, savePath);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'File downloaded to: $savePath'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Download failed: $e'),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.download),
                                  label: const Text("Download"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF23414E),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

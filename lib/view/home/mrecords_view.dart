import 'package:carecaps2/common/color_extention.dart';
import 'package:flutter/material.dart';

class RecordsView extends StatefulWidget {
  const RecordsView({super.key});

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  String selectedCategory = "All";

  final List<Map<String, dynamic>> records = [
    {
      "title": "Blood test results",
      "category": "Lab",
      "icon": Icons.monitor_heart,
      "date": "Mar 23, 2025",
      "location": "City health clinic"
    },
    {
      "title": "Paracetamol 500mg",
      "category": "Prescr",
      "icon": Icons.description,
      "date": "Mar 23, 2025",
      "location": "City health clinic"
    },
    {
      "title": "Dr ridha visit",
      "category": "Visits",
      "icon": Icons.monitor_heart,
      "date": "Mar 23, 2025",
      "location": "City health clinic"
    },
    {
      "title": "Left knee X-ray",
      "category": "X-ray",
      "icon": Icons.medical_services,
      "date": "Mar 23, 2025",
      "location": "City health clinic"
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered = selectedCategory == "All"
        ? records
        : records.where((r) => r["category"] == selectedCategory).toList();

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
            const SizedBox(height: 20),

            /// Search Bar Only
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromARGB(197, 190, 207, 209),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Filter Bar Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Tcolor.primary2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["All", "Prescr", "Lab", "X-ray", "Visits"]
                      .map((category) {
                    final bool isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Tcolor.primary2.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Tcolor.primary : Colors.white,
                              fontWeight: FontWeight.w500,
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
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  var item = filtered[index];
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
                            Icon(item['icon'],
                                size: 28, color: const Color(0xFF23414E)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF23414E),
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        item['date'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.location_on_outlined,
                                          size: 14,
                                          color: Color.fromARGB(
                                              255, 123, 123, 123)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          item['location'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 123, 123, 123),
                                            fontFamily: 'Poppins',
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
                              onPressed: () {},
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
                              onPressed: () {},
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

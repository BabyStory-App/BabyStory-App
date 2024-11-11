import 'package:babystory/models/baby.dart';
import 'package:babystory/models/milk.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/diary/milk_diary_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MilkDiaryListScreen extends StatefulWidget {
  final int diaryId;
  final Baby baby;

  const MilkDiaryListScreen(
      {Key? key, required this.diaryId, required this.baby})
      : super(key: key);

  @override
  State<MilkDiaryListScreen> createState() => _MilkDiaryListScreenState();
}

class _MilkDiaryListScreenState extends State<MilkDiaryListScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<Milk>> fetchDataFuture;

  // Controllers for the modal inputs
  int _selectedMilkType = 0; // Default to breast milk
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    fetchDataFuture = fetchData();
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<List<Milk>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/milk/${widget.diaryId}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      return json != null
          ? (json['milks'] as List).map((e) => Milk.fromJson(e)).toList()
          : [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  // Function to open the modal for adding a new milk entry
  void _openMilkCreateModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // For the keyboard to push up the modal
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        // Added StatefulBuilder here
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom, // Adjust for the keyboard
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Wrap content
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '수유 추가',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(height: 24, thickness: 1),
                      // Milk Type Selection
                      Text(
                        '수유 종류',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              value: 0,
                              groupValue: _selectedMilkType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMilkType = value!;
                                });
                              },
                              title: Text('모유'),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              value: 1,
                              groupValue: _selectedMilkType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMilkType = value!;
                                });
                              },
                              title: Text('분유'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Amount Input
                      Text(
                        '수유 양 (ml)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '양을 입력하세요',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.opacity),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Add Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('추가'),
                          onPressed: () {
                            _createNewMilk();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String toRequestDateTimeFormat(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

// Function to create a new milk entry
  void _createNewMilk() async {
    int? amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 양을 입력하세요.')),
      );
      return;
    }

    print("Request data: ${{
      'diary_id': widget.diaryId,
      'milk': _selectedMilkType,
      'amount': amount,
      'mtime': toRequestDateTimeFormat(DateTime.now()),
    }}");

    // Close the modal
    Navigator.of(context).pop();

    // Send the new milk entry to the server
    try {
      var response = await httpUtils.post(
        url: '/milk/create',
        headers: {'Authorization': 'Bearer ${parent.jwt}'},
        body: {
          'diary_id': widget.diaryId,
          'milk': _selectedMilkType,
          'amount': amount,
          'mtime': toRequestDateTimeFormat(DateTime.now()),
        },
      );

      if (response != null && response['success'] == 200) {
        // Refresh the list
        setState(() {
          fetchDataFuture = fetchData();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('수유 정보가 추가되었습니다.')),
          );
        }
      } else {
        throw Exception('Failed to add milk entry');
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수유 정보 추가에 실패했습니다.')),
      );
    }

    // Clear the input fields
    _amountController.clear();
    _selectedMilkType = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleClosedAppBar(
        title: "수유일지",
        rightIcon: Icons.add,
        rightIconColor: Colors.blue,
        rightIconAction: _openMilkCreateModal,
      ),
      body: FutureBuilder<List<Milk>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return requestWriteMilk(context);
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (BuildContext ctx, int idx) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) =>
                    MilkDiaryItem(milk: data[index]),
              ),
            );
          } else {
            return requestWriteMilk(context);
          }
        },
      ),
    );
  }
}

Widget requestWriteMilk(BuildContext context) {
  return const Center(
    child: Text(
      "수유일지를 추가해주세요.",
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45),
    ),
  );
}

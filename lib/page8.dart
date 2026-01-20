
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// هذه هي الصفحة المستقلة التي يمكنك استدعاؤها من أي مكان
class page8 extends StatefulWidget {
  const page8({super.key});

  @override
  State<page8> createState() => _IbbDirectoryPageState();
}

class _IbbDirectoryPageState extends State<page8> {
  List _places = [];
  bool _isLoading = false;
  String _activeCategory = 'restaurant';

  // تعريف التصنيفات والبيانات المطلوبة لكل تصنيف
  final List<Map<String, String>> _categories = [
    {'id': 'restaurant', 'name': 'مطاعم', 'icon': 'restaurant'},
    {'id': 'hospital', 'name': 'مستشفيات', 'icon': 'local_hospital'},
    {'id': 'tourism', 'name': 'سياحة', 'icon': 'landscape'},
    {'id': 'hotel', 'name': 'فنادق', 'icon': 'hotel'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchIbbData(_activeCategory);
  }

  // دالة جلب البيانات من Overpass API
  Future<void> _fetchIbbData(String category) async {
    setState(() {
      _isLoading = true;
      _activeCategory = category;
      _places = []; // تفريغ القائمة القديمة أثناء التحميل
    });

    // إحداثيات محافظة إب التقريبية (تغطي المدينة والمناطق المحيطة)
    const String bbox = "13.80,43.90,14.10,44.30";

    // تحديد نوع المفتاح بناءً على التصنيف
    String key = (category == 'tourism' || category == 'hotel') ? 'tourism' : 'amenity';

    // بناء الاستعلام بلغة Overpass QL
    String query = '[out:json];node["$key"="$category"]($bbox);out;';

    final url = Uri.parse('https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _places = data['elements'];
          _isLoading = false;
        });
      } else {
        throw Exception('فشل التحميل');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("عذراً، حدث خطأ في جلب البيانات: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(style: TextStyle(color:Colors.white,),'دليل محافظة إب الرقمي'),
          backgroundColor: Colors.blue,
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildCategoryBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                  : _buildPlacesList(),
            ),
          ],
        ),
      ),
    );
  }

  // شريط التصنيفات العلوي
  Widget _buildCategoryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _categories.map((cat) {
          bool isSelected = _activeCategory == cat['id'];
          return GestureDetector(
            onTap: () => _fetchIbbData(cat['id']!),
            child: Column(
              children: [
                Icon(
                  _getIconData(cat['icon']!),
                  color: isSelected ? Colors.white : Colors.white60,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  cat['name']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top:4),
                    height: 2,
                    width: 20,
                    color: Colors.white,
                  )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // قائمة الأماكن
  Widget _buildPlacesList() {
    if (_places.isEmpty) {
      return const Center(child: Text("لم يتم العثور على نتائج في هذا التصنيف"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final tags = _places[index]['tags'] ?? {};
        final name = tags['name'] ?? "مكان غير مسمى";
        final phone = tags['phone'] ?? tags['contact:phone'] ?? "غير متوفر";
        final website = tags['website'] ?? "غير متوفر";

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.location_on, color: Colors.blue),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(phone),
                  ],
                ),
                if (website != "غير متوفر")
                  Row(
                    children: [
                      const Icon(Icons.language, size: 14, color: Colors.blue),
                      const SizedBox(width: 5),
                      Expanded(child: Text(website, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blue))),
                    ],
                  ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant': return Icons.restaurant;
      case 'local_hospital': return Icons.local_hospital;
      case 'landscape': return Icons.landscape;
      case 'hotel': return Icons.hotel;
      default: return Icons.place;
    }
  }
}
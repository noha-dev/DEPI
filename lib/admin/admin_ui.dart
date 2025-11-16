import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:team_project/admin/controller/admin_provider.dart';

class AdminUi extends StatelessWidget {
  AdminUi({super.key});
  final List<String> tabs = ['Ongoing', 'Complete', 'Review'];
  final List<Map<String, String>> orders = [
    {
      'image': 'assets/images/product1.png',
      'name': 'Product 1',
      'description': 'description',
      'price': '\$29.99',
    },
    {
      'image': 'assets/images/product2.png',
      'name': 'Product 2',
      'description': 'description',
      'price': '\$49.99',
    },
    {
      'image': 'assets/images/product3.png',
      'name': 'Product 3',
      'description': 'description',
      'price': '\$19.99',
    },
    {
      'image': 'assets/images/product4.png',
      'name': 'Product 4',
      'description': 'Brief description of product 4',
      'price': '\$99.99',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back_ios,size: 30,),
                Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Satoshi',
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/ic_fluent_alert_32_regular.svg',
                  height: 30,
                  width: 29,
                ),
              ],
            ),
            SizedBox(height: 24),
            // tabs
            Container(
              height: 48,
              width: 335,
              decoration: BoxDecoration(
                color: Color(0xFFEBEFFF),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(tabs.length * 2 - 1, (index) {
                    if (index.isOdd) {
                      return Container(
                        width: 1,
                        height: 15,
                        color: Color(0xFFE0E0E5),
                      );
                    } else {
                      index = index ~/ 2;

                      final isSelected = index == tabProvider.selectedIndex;
                      return GestureDetector(
                        onTap: () {
                          tabProvider.selectTab(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFFFFFFF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontFamily: 'SF Pro ',
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
            SizedBox(height: 24),
            // list of orders
            Expanded(
              child:orders.isEmpty
                  ? Center(
                    
                      child: 
                      Column(
                        mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('Vector.png',height: 45.33,width: 37.33,),
                          SizedBox(height: 25),
                      Text(
                        'No Ongoing Orders!',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'You don’t have any ongoing orders at this time.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              
              : ListView.builder(
                
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final hasReview = tabProvider.hasOrderReview(index);
                  final rating = tabProvider.getRating(index);

                  Widget actionwidget = SizedBox();
                  if (tabProvider.selectedIndex == 0) {
                    actionwidget = Text(
                      'Track Order',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,

                        color: Color(0xFF452ce8),
                      ),
                    );
                  } else if (tabProvider.selectedIndex == 1) {
                    actionwidget = Text(
                      'Delivered',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,

                        color: Color(0xFF0e8345),
                      ),
                    );
                  } else if (tabProvider.selectedIndex == 2) {
                    actionwidget = GestureDetector(
                      onTap: () {
                        if (tabProvider.hasOrderReview(index)) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Your Review"),
                              content: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    Icons.star,
                                    color: i < (rating ?? 0)
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          showReviewBottomSheet(context, index);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tabProvider.hasOrderReview(index)
                              ? Colors.grey[200]
                              : Color(0xFFDAE2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tabProvider.hasOrderReview(index)
                              ? 'See Review'
                              : 'Review',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,

                            color: tabProvider.hasOrderReview(index)
                                ? Color(0xFF68656E)
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(bottom: 0),
                    padding: EdgeInsets.all(16),
                    width: 335,
                    height: 150,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE0E0E5), width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListItem(
                            image: order['image'] ?? '',
                            name: order['name'] ?? '',
                            description: order['description'] ?? '',
                            price: order['price'] ?? '',
                            actionWidget: actionwidget,
                          ),
                        ),
                      ],
                    ),
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

class ListItem extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String price;
  final Widget actionWidget;

  const ListItem({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(image, fit: BoxFit.cover),
        ),

        SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Satoshi',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Satoshi ',
                    color: Color(0xFF68656E),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Satoshi',
                    color: Color(0xFF323135),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionWidget,
      ],
    );
  }
}

void showReviewBottomSheet(BuildContext context, int orderId) {
  final tabProvider = Provider.of<TabProvider>(context, listen: false);
  int rating = tabProvider.getRating(orderId) ?? 0;
  File? selectedImage;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leave a Review",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16),
                  Container(width: 335, height: 1, color: Color(0xFFE0E0E5)),
                  SizedBox(height: 16),
                  Text(
                    'How was your order?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Please give your rating and also your review.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SF Pro',
                      color: Color(0xFF68656E),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Stars
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          size: 32,
                          color: index < rating
                              ? Color(0xFFFFA928)
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write your review...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE0E0E5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          setState(() {
                            selectedImage = File(image.path);
                          });
                        }
                      },
                      child: Container(
                        width: 123,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: selectedImage == null
                            ? Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_fluent_image_48_regular.svg',
                                      color: Color(0xFFF452CE8),
                                      height: 20.5,
                                      width: 20.5,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Add Photo",
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF323135),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 335,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF452CE8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        tabProvider.setRating(orderId, rating);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Satoshi',
                          color: Color(0xFFFBFBFC),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

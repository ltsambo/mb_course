import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/services/global_methods.dart';
import 'package:mb_course/widgets/course_card.dart';
import 'package:mb_course/widgets/default_text.dart';

import '../../models/course.dart';


class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {        
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: DefaultTextWg(text: "Order Details", fontSize: 24, fontColor: whiteColor),         
        centerTitle: false,        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildCourseCard(),
            for (var product in order['items'])
              CourseCard(course: Course.fromJson(product['course'])),  
            // CourseCard(course: product),   
            const SizedBox(height: 24),
            // _buildShopInfo(),
            // const SizedBox(height: 16),
            // _buildDeliveryInfo(),
            // const SizedBox(height: 24),
            _buildOrderSummary(order['order_uuid'], order['order_status'], order['order_date'], order['total_amount']),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(String order_id, status, order_date, total_amount) {
    String status = order['order_status'] ?? 'Unknown';
    Color statusColor;

    if (status == 'Pending' || status == 'pending_upload') {
      statusColor = Colors.red;
    } else if (status == 'pending_accept') {
      statusColor = Colors.orange;
    } else if (status == 'Accepted') {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('Order Status', status, color: statusColor),
        _buildSummaryRow('Order ID', order_id),
        _buildSummaryRow('Order Date', GlobalMethods.formatDate(order_date)),
        // _buildSummaryRow('Payment Method', 'Cash on Delivery'),
        _buildSummaryRow('Total Amount', total_amount.toString()),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          // child: TextButton(
          //   onPressed: () {},
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: const [
          //       Icon(Icons.download, color: Colors.red),
          //       SizedBox(width: 4),
          //       Text('Download Invoice', style: TextStyle(color: Colors.red)),
          //     ],
          //   ),
          // ),
        )
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultTextWg(text: title, fontSize: 14, fontColor: Colors.grey, fontWeight: FontWeight.normal,),
          DefaultTextWg(text: value, fontSize: 14, fontColor: color,),                    
        ],
      ),
    );
  }

  Widget _buildCourseCard() {
    print('items ${order['items']}');
    return Expanded(
      child: ListView.builder(
        itemCount: order['items'].length,
        itemBuilder: (context, index) {
          // final course = courses[index];
          return CourseCard(course: order['items'][index],);
        },
      ),
    );
  }
  
  Widget _buildShopInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.store, color: Colors.black),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DhakaMart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text('5.0', style: TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('HOME', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Jahidul Islam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('+880 1768 572 658', style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text('Sekhertek, 52/A, Adabor, Mohammadpur-1207', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }  
}

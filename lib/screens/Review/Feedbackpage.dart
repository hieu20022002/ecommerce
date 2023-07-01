import 'package:ecommerce/models/Review.dart';
import 'package:ecommerce/screens/Review/AddNewReview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  final String userId;
  final String productId;

  const FeedbackPage({Key? key, required this.userId, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text('Feedback', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Review>>(
        future: Review.getReviewsByUserIdAndProductId(userId, productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final reviews = snapshot.data ?? [];
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(review.title ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          children: List.generate(
                            review.rating ?? 0,
                            (index) => Icon(Icons.star, color: Colors.yellow[600]),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(review.body ?? ''),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[600],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewPage(
                userId: userId,
                productId: productId,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

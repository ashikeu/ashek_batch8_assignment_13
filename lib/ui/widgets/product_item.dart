import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/models/product.dart';
import 'package:crud_app/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: 
      // Image.network(
      //   product.image ?? '',
      //   width: 30, // Set the width of the leading image
      //   height: 30, // Set the height of the leading image
      // ),
      CachedNetworkImage(
          imageUrl: product.image??'',
          placeholder: (context, url) => const CircularProgressIndicator(), 
          errorWidget: (context, url, error) => const Icon(Icons.error,color: Colors.red,), 
          fit: BoxFit.cover, 
        ),
      title: Text(product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${product.quantity ?? 'Unknown'}'),
          Text('Price: ${product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${product.totalPrice ?? 'Unknown'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () {
                 _showDeleteConfirmationDialog(context);
                 
              },
              icon: const Icon(Icons.delete)),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: product,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteItem(product.id!); // Proceed with the deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to send the DELETE request to the server
  Future<void> deleteItem(String id) async {
    final String url = 'https://your-api.com/items/$id';  // Replace with your API URL

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully!');
        // You can show a Snackbar or dialog to inform the user
        // Or navigate back to the previous screen, etc.
      } else {
        print('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

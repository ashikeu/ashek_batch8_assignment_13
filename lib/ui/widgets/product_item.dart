import 'package:ashek_batch8_assignment_13/models/product.dart';
import 'package:ashek_batch8_assignment_13/ui/screens/update_product_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
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
        imageUrl: widget.product.image ?? '',
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.red,
        ),
        fit: BoxFit.cover,
      ),
      title: Text(widget.product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${widget.product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${widget.product.quantity ?? 'Unknown'}'),
          Text('Price: ${widget.product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${widget.product.totalPrice ?? 'Unknown'}'),
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
                arguments: widget.product,
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
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteItem(widget.product.id!); // Proceed with the deletion
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
    final String url =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/${id}'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Failed to delete item. Status code: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

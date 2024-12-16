import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_spot_model.dart';

class FavoriteStarWidget extends StatefulWidget {
  final FavoriteSpot? place;

  const FavoriteStarWidget({Key? key, required this.place}) : super(key: key);

  @override
  _FavoriteStarWidgetState createState() => _FavoriteStarWidgetState();
}

class _FavoriteStarWidgetState extends State<FavoriteStarWidget> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  /// Checks if the place is already a favorite in Firestore
  Future<void> _checkIfFavorite() async {
    if (widget.place == null) return;

    final String uniqueId = '${widget.place!.latitude}_${widget.place!.longitude}';
    final docSnapshot = await FirebaseFirestore.instance.collection('favorites').doc(uniqueId).get();

    setState(() {
      isFavorite = docSnapshot.exists;
    });
  }

  /// Toggles the favorite state and updates Firestore
  Future<void> _toggleFavorite() async {
    if (widget.place == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No place selected')),
      );
      return;
    }

    final String uniqueId = '${widget.place!.latitude}_${widget.place!.longitude}';

    if (isFavorite) {
      // Remove favorite
      await FirebaseFirestore.instance.collection('favorites').doc(uniqueId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites: ${widget.place!.name}')),
      );
    } else {
      // Save to favorites
      await FirebaseFirestore.instance.collection('favorites').doc(uniqueId).set({
        'name': widget.place!.name,
        'address': widget.place!.address,
        'latitude': widget.place!.latitude,
        'longitude': widget.place!.longitude,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites: ${widget.place!.name}')),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.yellow : Colors.grey,
        size: 28,
      ),
    );
  }
}

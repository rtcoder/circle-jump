import 'package:flutter/material.dart';

Positioned distanceText(String distance) {
  return Positioned(
    top: 20,
    right: 20,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Distance: $distance',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
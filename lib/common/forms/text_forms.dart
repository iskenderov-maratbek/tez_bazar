import 'package:flutter/material.dart';

text16normal(String text) => Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );

text18Bold(String text) => Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

text20bold(String text) => Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
    );

text24bold(String text) => Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
    );

text32bold(String text) => Text(
      text,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
    );

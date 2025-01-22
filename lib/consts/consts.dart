import 'package:flutter/material.dart';
import 'package:mb_course/route/screen_export.dart';

const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;

const Color primaryColor = Color(0xFF4A6057);

const Color titleColor = Color(0xFF4A6057);
const Color backgroundColor = Color(0xFFF8EFE4);

const managementItems = [
  {
    "icon": Icons.group,
    "label": "USER",
    "color": Colors.orange,
    "route": UserListScreen(),
  },
  {
    "icon": Icons.auto_graph_outlined,
    "label": "ROLE",
    "color": Colors.green,
    "route": '',
  },
  {
    "icon": Icons.video_file_outlined,
    "label": "COURSE",
    "color": Colors.brown,
    "route": '',
  },
  {
    "icon": Icons.play_lesson_rounded,
    "label": "COURSE ITEM",
    "color": Colors.blue,
    "route": '',
  },
  {
    "icon": Icons.view_carousel_outlined,
    "label": "CAROUSEL",
    "color": Colors.blue,
    "route": '',
  },
  {
    "icon": Icons.image,
    "label": "GALLERY",
    "color": Colors.blue,
    "route": '',
  },
  // {
  //   "icon": Icons.videocam,
  //   "label": "VIDEO TEST",
  //   "color": Colors.blue,
  // },
];
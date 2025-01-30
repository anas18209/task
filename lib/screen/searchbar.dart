import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:taskapp/providers/task/tasks_provider.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: _isSearching ? MediaQuery.of(context).size.width * 0.85 : 180,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: TextField(
        controller: _searchController,
        onTap: () {
          if (_searchController.text.isNotEmpty) {
            setState(() => _isSearching = true);
          } else {
            setState(() => _isSearching = false);
          }
        },
        onChanged: (value) {
          if (_searchController.text.isNotEmpty) {
            setState(() => _isSearching = true);
            ref.read(taskProvider.notifier).searchTasks(value);
          } else {
            setState(() => _isSearching = false);
            ref.read(taskProvider.notifier).searchTasks(value);
          }
        },
        decoration: InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          suffixIcon:
              _isSearching
                  ? IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _isSearching = false;
                      });
                    },
                  )
                  : null,
          contentPadding: EdgeInsets.symmetric(vertical: 1.h),
        ),
      ),
    );
  }
}

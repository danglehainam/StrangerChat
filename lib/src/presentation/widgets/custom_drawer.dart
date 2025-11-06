import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget{
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:[
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              )
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () => {
              Navigator.pop(context),
              context.push('/login')
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
          ),
        ],
      ),
    );
  }

}

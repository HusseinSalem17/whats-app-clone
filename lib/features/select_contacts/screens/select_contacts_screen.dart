import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/core/widgets/error.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_ui/widgets/contacts_list.dart';

import '../../../core/widgets/loader.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = 'select-contact';
  const SelectContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Contact'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ),
            )
          ],
        ),
        body: ref.watch(getContactsProvider).when(
            data: (ContactsList) => ListView.builder(
                  itemCount: ContactsList.length,
                  itemBuilder: (context, index) {
                    final contact = ContactsList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: MemoryImage(
                                  contact.photo!,
                                ),
                                radius: 30,
                              ),
                      ),
                    );
                  },
                ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader()));
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/core/enums/message_enum.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/message.dart';

import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
          name: user.name,
          profilePic: user.profilePic,
          contactId: chatContact.contactId,
          timeSent: chatContact.timeSent,
          lastMessage: chatContact.lastMessage,
        ));
      }
      return contacts;
    });
  }

  void _saveDataToContactSubcollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    //users -> reciever userId  -> chats -> current user id -> set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(
          auth.currentUser!.uid,
        )
        .set(
          recieverChatContact.toMap(),
        );
    //users -> current userId  -> chats -> receiver user id -> set data
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(
          recieverUserId,
        )
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required String reciecverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String recieverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: reciecverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    //user -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(
          auth.currentUser!.uid,
        )
        .collection('chats')
        .doc(
          reciecverUserId,
        )
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    //user -> reciever id -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(
          reciecverUserId,
        )
        .collection('chats')
        .doc(
          auth.currentUser!.uid,
        )
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    //user -> sender id -> reciever id -> messages -> message id -> store message
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      //users -> reciever userId  -> chats -> current user id -> set data

      _saveDataToContactSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        reciecverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

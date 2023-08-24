// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/models/call.dart';

import '../repository/call_repository.dart';

final callControllerProvider = Provider(
  (ref) {
    final CallRepository = ref.read(callRepositoryProvider);
    return CallController(
      callRepository: CallRepository,
      auth: FirebaseAuth.instance,
      ref: ref,
    );
  },
);

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(
    BuildContext context,
    String recieverName,
    String recieverUid,
    String recieverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(senderCallData, context, recieverCallData);
      } else {
        callRepository.makeCall(senderCallData, context, recieverCallData);
      }
    });
  }

  void endCall(
    String callerId,
    String recieverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, recieverId, context);
  }
}

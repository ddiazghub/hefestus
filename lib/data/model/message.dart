import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:hefestus/data/model/annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hefestus/helpers.dart';

part 'message.g.dart';

@FirestoreSerializable
class Message {
  Message(this.text, this.user, {this.key = '', DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  @DateTimeField
  final DateTime createdAt;
  final String key;
  final String text;
  final String user;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@Collection<Message>('messages')
final MessageRef = MessageCollectionReference();

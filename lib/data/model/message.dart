import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:hefestus/data/model/annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hefestus/helpers.dart';

part 'message.g.dart';

@FirestoreSerializable
class Message {
  Message(
    this.text,
    this.sender, {
    this.key = '',
    DateTime? createdAt,
    this.receiver,
  }) : createdAt = createdAt ?? DateTime.now();

  @DateTimeField
  final DateTime createdAt;

  @Id()
  final String key;
  final String text;
  final String sender;
  final String? receiver;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@Collection<Message>('messages')
final MessageRef = MessageCollectionReference();

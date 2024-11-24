import 'package:sirek/model/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventDatabase {
  //Database -> event
  final database = Supabase.instance.client.from('event');

  //Create
  Future createdEvent(Event newEvent) async {
    await database.insert(newEvent.toMap());
  }

  //Read
  final stream = Supabase.instance.client.from('event').stream(
    primaryKey: ['eventId'],
  ).map((data) => data.map((eventMap) => Event.fromMap(eventMap)).toList());

  //Update
  Future updateEvent(Event oldEvent, String newContent) async {
    await database.update({'content': newContent}).eq('eventId', oldEvent.eventId!);
  }

  //Delete
  Future deleteEvent(Event event) async{
    await database.delete().eq('eventId', event.eventId!);
  }
}
import 'dart:io';
import 'package:sirek/models/event_model.dart';

class EventController {
  final EventRepository _eventRepository = EventRepository();

  // Fetch all events
  Future<List<EventModel>> getAllEvents() async {
    return await _eventRepository.fetchAllEvents();
  }

  // Upload File
  Future<String> uploadFile(File file, String folder) async {
    return await _eventRepository.uploadFile(file, folder);
  }

  // Create a new event with files
  Future<void> createEventWithFiles(
      EventModel event) async {
    await _eventRepository.createEvent(event);
  }

  // Update an event with files
  Future<void> updateEventWithFiles(
      String id, EventModel event, File? imageFile, File? bookletFile) async {
    await _eventRepository.updateEventWithFiles(
        id, event, imageFile, bookletFile);
  }

  // Delete an event with its associated files
  Future<void> deleteEventWithFiles(String id) async {
    await _eventRepository.deleteEventWithFiles(id);
  }
}

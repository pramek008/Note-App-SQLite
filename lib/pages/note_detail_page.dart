import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp_sqflite/db/notes_database.dart';
import 'package:noteapp_sqflite/models/note.dart';
import 'package:noteapp_sqflite/pages/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget editButton() => IconButton(
          onPressed: () async {
            if (isLoading) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditNotePage(
                  note: note,
                ),
              ),
            );
          },
          icon: const Icon(Icons.edit_note_rounded),
        );

    Widget deleteButton() => IconButton(
          onPressed: () async {
            await NotesDatabase.instance.delete(widget.noteId);
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.delete),
        );

    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(
                12,
              ),
              child: ListView(
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().add_Hm().format(note.createdAt),
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    note.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

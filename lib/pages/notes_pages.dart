import 'package:flutter/material.dart';
import 'package:noteapp_sqflite/db/notes_database.dart';
import 'package:noteapp_sqflite/models/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:noteapp_sqflite/pages/edit_note_page.dart';
import 'package:noteapp_sqflite/pages/note_detail_page.dart';
import 'package:noteapp_sqflite/widgets/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    this.notes = await NotesDatabase.instance.raedAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text('No notes yet')
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );

          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8),
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      itemCount: notes.length,
      crossAxisCount: 4,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => NoteDetailPage(
                        noteId: note.id!,
                      )),
            );

            refreshNotes();
          },
          child: NoteCardWidget(
            note: note,
            index: index,
          ),
        );
      });
}

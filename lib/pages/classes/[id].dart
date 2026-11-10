import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/quiz_builder.dart';
import '../../components/ui.dart';
import '../../dartvel_client/dartvel_client.dart';

/// One class: its notes (the learning aid), quizzes and scores. The teacher
/// also sees the join code, who is in it, and the forms to post and set.
@DVPage(
  title: 'Class – Learn Acer',
  description: 'A Learn Acer class: the teacher’s notes and links, quizzes, and the scores each person may see.',
)
Widget _classPage(BuildContext context) => ClassScreen(id: context.dvParams['id'] ?? '');

class ClassScreen extends StatefulWidget {
  const ClassScreen({required this.id});

  final String id;

  @override
  State<ClassScreen> createState() => ClassScreenState();
}

class ClassScreenState extends State<ClassScreen> {
  Map<String, Object?>? _class;
  String? _problem;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final Map<String, Object?> found = await classView(classId: widget.id);
      if (mounted) setState(() => _class = found);
    } on Object catch (error) {
      if (mounted) setState(() => _problem = problemText(error));
    }
  }

  List<Map<String, Object?>> _list(String key) => <Map<String, Object?>>[
        for (final Object? item in (_class?[key] as List? ?? const <Object?>[])) if (item is Map) item.cast<String, Object?>(),
      ];

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    if (_problem != null) {
      return PageColumn(children: <Widget>[
        const PageTitle('This class could not be opened'),
        Notice(_problem!),
        RouteLink('Back to your classes', to: DVRoutes.classes, tooltip: 'All the classes you are in'),
      ]);
    }
    if (_class == null) return const PageColumn(children: <Widget>[LinearProgressIndicator()]);
    final bool teacher = _class!['role'] == 'teacher';
    final List<Map<String, Object?>> notes = _list('notes');
    final List<Map<String, Object?>> quizzes = _list('quizzes');
    final List<Map<String, Object?>> scores = _list('scores');
    final List<Map<String, Object?>> people = _list('people');
    return PageColumn(
      children: <Widget>[
        RouteLink('← Your classes', to: DVRoutes.classes, tooltip: 'All the classes you are in', size: 15),
        const SizedBox(height: Space.md),
        PageTitle('${_class!['name']}', lead: '${_class!['subject']} with ${_class!['teacher']}.'),
        if (teacher) _CodeCard(code: '${_class!['code']}', classId: widget.id),
        const SectionTitle('Notes and resources'),
        if (teacher) _NoteForm(classId: widget.id, onPosted: _load),
        if (notes.isEmpty) Text(teacher ? 'Nothing posted yet. Your first note appears here for everyone in the class.' : 'Your teacher has not posted anything yet.', style: textStyle(context, color: palette.muted)),
        for (final Map<String, Object?> note in notes) _NoteCard(note),
        const SectionTitle('Quizzes'),
        if (teacher) QuizBuilder(classId: widget.id, onCreated: _load),
        if (quizzes.isEmpty) Text(teacher ? 'Set a quiz above; students take it here and you see their scores.' : 'No quizzes yet.', style: textStyle(context, color: palette.muted)),
        for (final Map<String, Object?> quiz in quizzes)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: Panel(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${quiz['title']}', style: textStyle(context, weight: FontWeight.w600)),
                        Text('${quiz['questions']} questions', style: textStyle(context, size: 14, color: palette.muted)),
                      ],
                    ),
                  ),
                  RouteLink(_class!['role'] == 'parent' ? 'Try it' : (teacher ? 'Preview' : 'Take quiz'), to: DVRoutes.quiz(id: '${quiz['id']}'), tooltip: 'Open ${quiz['title']}'),
                ],
              ),
            ),
          ),
        SectionTitle(teacher ? 'Scores' : (_class!['role'] == 'parent' ? 'Your child’s scores' : 'Your scores')),
        if (scores.isEmpty) Text('No scores yet.', style: textStyle(context, color: palette.muted)),
        for (final Map<String, Object?> score in scores)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Text(
              '${teacher || _class!['role'] == 'parent' ? '${score['name']}: ' : ''}${score['quiz']}, ${score['correct']}/${score['total']} (${score['grade']}) on ${shortDate('${score['takenAt']}')}',
              style: textStyle(context),
            ),
          ),
        if (teacher) ...<Widget>[
          SectionTitle('People (${people.length})'),
          for (final Map<String, Object?> person in people)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Text(
                '${person['name']} · ${person['role']}${person['child'] == null ? '' : ' of ${person['child']}'}',
                style: textStyle(context),
              ),
            ),
        ],
      ],
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.code, required this.classId});

  final String code;
  final String classId;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.xl),
      decoration: BoxDecoration(color: palette.accentSoft, borderRadius: BorderRadius.circular(12)),
      child: Wrap(
        spacing: Space.xl,
        runSpacing: Space.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Class code', style: textStyle(context, size: 14, weight: FontWeight.w600, color: palette.muted)),
              Text(code, style: displayStyle(context, size: 40).copyWith(letterSpacing: 6)),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text('Read it out or write it on the board. Students and parents type it on the Classes page to join.', style: textStyle(context, size: 15, color: palette.muted)),
          ),
          QuietButton('Copy code', tooltip: 'Copy the class code to send it', onPressed: () async {
            await Clipboard.setData(ClipboardData(text: code));
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied $code')));
          }),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard(this.note);

  final Map<String, Object?> note;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final String link = '${note['link'] ?? ''}';
    final String body = '${note['body'] ?? ''}';
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Semantics(headingLevel: 3, child: Text('${note['title']}', style: displayStyle(context, size: 19))),
            const SizedBox(height: Space.xs),
            Text('${note['author']} · ${shortDate('${note['postedAt']}')}', style: textStyle(context, size: 14, color: palette.muted)),
            if (body.isNotEmpty) ...<Widget>[const SizedBox(height: Space.md), Text(body, style: textStyle(context))],
            if (link.isNotEmpty)
              Tooltip(
                message: 'Opens in a new tab',
                excludeFromSemantics: true,
                child: DVNavLink.external(
                  link,
                  semanticLabel: 'Open the link: $link',
                  padding: const EdgeInsets.only(top: Space.md),
                  child: Text(link, style: textStyle(context, size: 15, weight: FontWeight.w600, color: palette.accent).copyWith(decoration: TextDecoration.underline)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoteForm extends StatefulWidget {
  const _NoteForm({required this.classId, required this.onPosted});

  final String classId;
  final VoidCallback onPosted;

  @override
  State<_NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<_NoteForm> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final TextEditingController _link = TextEditingController();
  bool _open = false;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      await postNote(classId: widget.classId, title: _title.text, noteText: _body.text, link: _link.text);
      _title.clear();
      _body.clear();
      _link.clear();
      if (mounted) setState(() => _open = false);
      widget.onPosted();
    } on Object catch (error) {
      if (mounted) setState(() => _problem = problemText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Space.md),
        child: QuietButton('+ Post a note or link', tooltip: 'Share notes, a reading or a video with the class', onPressed: () => setState(() => _open = true)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LabelledField(label: 'Title', controller: _title, hint: 'Week 3: Photosynthesis', textCapitalization: TextCapitalization.sentences),
            LabelledField(label: 'Note', controller: _body, maxLines: 6, hint: 'What to read, what to remember, what to bring', textCapitalization: TextCapitalization.sentences),
            LabelledField(label: 'Link (optional)', controller: _link, hint: 'https://…', keyboardType: TextInputType.url),
            Wrap(
              spacing: Space.md,
              children: <Widget>[
                PrimaryButton('Post to class', tooltip: 'Everyone in the class sees it', busy: _busy, onPressed: _post),
                QuietButton('Cancel', tooltip: 'Close without posting', onPressed: () => setState(() => _open = false)),
              ],
            ),
            if (_problem != null) Notice(_problem!),
          ],
        ),
      ),
    );
  }
}

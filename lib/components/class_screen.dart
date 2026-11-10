import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'quiz_builder.dart';
import 'ui.dart';
import '../dartvel_client/dartvel_client.dart';

/// One class: its notes (the learning aid), quizzes and scores. The teacher
/// also sees the join code, who is in it, and the forms to post and set.

List<Map<String, Object?>> listOf(Map<String, Object?> data, String key) => <Map<String, Object?>>[
      for (final Object? item in (data[key] as List? ?? const <Object?>[])) if (item is Map) item.cast<String, Object?>(),
    ];

@DVFunctionalWidget()
Widget _classScreen(BuildContext context, {required String id}) {
  final DVSignal<bool> started = context.signal(false);
  final DVSignal<Map<String, Object?>?> data = context.signal<Map<String, Object?>?>(null);
  final DVSignal<String> problem = context.signal('');
  Future<void> load() async {
    try {
      data.value = await classView(classId: id);
    } on Object catch (error) {
      problem.value = problemText(error);
    }
  }

  onFirstFrame(context, started, load);
  if (problem.value.isNotEmpty) {
    return PageColumn(children: <Widget>[
      const PageTitle(title: 'This class could not be opened'),
      Notice(text: problem.value),
      RouteLink(label: 'Back to your classes', to: DVRoutes.classes, tooltip: 'All the classes you are in'),
    ]);
  }
  final Map<String, Object?>? view = data.value;
  if (view == null) return const PageColumn(children: <Widget>[LoadingLine()]);
  final String role = '${view['role']}';
  final bool teacher = role == 'teacher';
  final List<Map<String, Object?>> notes = listOf(view, 'notes');
  final List<Map<String, Object?>> quizzes = listOf(view, 'quizzes');
  final List<Map<String, Object?>> scores = listOf(view, 'scores');
  final List<Map<String, Object?>> people = listOf(view, 'people');
  return PageColumn(
    children: <Widget>[
      RouteLink(label: '← Your classes', to: DVRoutes.classes, tooltip: 'All the classes you are in', size: 15),
      PageTitle(title: '${view['name']}', lead: '${view['subject']} with ${view['teacher']}.'),
      if (teacher) CodeCard(code: '${view['code']}'),
      const SectionTitle(title: 'Notes and resources'),
      if (teacher) NoteForm(classId: id, onPosted: load),
      if (notes.isEmpty) BodyText(text: teacher ? 'Nothing posted yet. Your first note appears here for everyone in the class.' : 'Your teacher has not posted anything yet.', muted: true),
      DVBox.list(<Widget>[
        for (final Map<String, Object?> note in notes)
          NoteCard(title: '${note['title']}', body: '${note['body'] ?? ''}', link: '${note['link'] ?? ''}', byline: '${note['author']} · ${shortDate('${note['postedAt']}')}'),
      ], spacing: Space.md),
      const SectionTitle(title: 'Quizzes'),
      if (teacher) QuizBuilder(classId: id, onCreated: load),
      if (quizzes.isEmpty) BodyText(text: teacher ? 'Set a quiz above; students take it here and you see their scores.' : 'No quizzes yet.', muted: true),
      DVBox.list(<Widget>[
        for (final Map<String, Object?> quiz in quizzes)
          DVBox.row(<Widget>[
            DVBox.list(<Widget>[
              BodyText(text: '${quiz['title']}', bold: true),
              BodyText(text: quiz['questions'] == 1 ? '1 question' : '${quiz['questions']} questions', size: 14, muted: true),
            ], spacing: 0),
            RouteLink(label: role == 'parent' ? 'Try it' : (teacher ? 'Preview' : 'Take quiz'), to: DVRoutes.quiz(id: '${quiz['id']}'), tooltip: 'Open ${quiz['title']}'),
          ], align: DVAlign.spaceBetween, modifier: DVModifier().backgroundColor(Palette.of(context).surface).rounded(12).border(Border.all(color: Palette.of(context).rule)).paddingSymmetric(horizontal: Space.lg, vertical: Space.sm)),
      ], spacing: Space.sm),
      SectionTitle(title: teacher ? 'Scores' : (role == 'parent' ? 'Your child’s scores' : 'Your scores')),
      if (scores.isEmpty) const BodyText(text: 'No scores yet.', muted: true),
      for (final Map<String, Object?> score in scores)
        BodyText(text: '${teacher || role == 'parent' ? '${score['name']}: ' : ''}${score['quiz']}, ${score['correct']}/${score['total']} (${score['grade']}) on ${shortDate('${score['takenAt']}')}'),
      if (teacher) ...<Widget>[
        SectionTitle(title: 'People (${people.length})'),
        for (final Map<String, Object?> person in people) BodyText(text: '${person['name']} · ${person['role']}${person['child'] == null ? '' : ' of ${person['child']}'}'),
      ],
    ],
  );
}

@DVFunctionalWidget()
Widget _codeCard(BuildContext context, {required String code}) {
  final Palette palette = Palette.of(context);
  final DVSignal<bool> copied = context.signal(false);
  return DVBox.wrapLine(<Widget>[
    DVBox.list(<Widget>[
      const BodyText(text: 'Class code', size: 14, muted: true, bold: true),
      DVText(code).modifier(DVModifier().fontFamily(displayFont).fontSize(40).letterSpacing(6).color(palette.ink).semanticLabel('Class code ${code.split('').join(' ')}')),
    ], spacing: 0),
    DVBox(const BodyText(text: 'Read it out or write it on the board. Students and parents type it on the Classes page to join.', size: 15, muted: true), const DVModifier().maxWidth(380)),
    QuietButton(
      label: copied.value ? 'Copied' : 'Copy code',
      tooltip: 'Copy the class code to send it',
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: code));
        copied.value = true;
      },
    ),
  ], spacing: Space.xl, crossAlign: DVCrossAlign.center, modifier: DVModifier().backgroundColor(palette.accentSoft).rounded(12).padding(Space.xl));
}

@DVFunctionalWidget()
Widget _noteCard(BuildContext context, {required String title, required String body, required String link, required String byline}) => Panel(
      spacing: Space.xs,
      children: <Widget>[
        SectionTitle(title: title, level: 3, size: 19),
        BodyText(text: byline, size: 14, muted: true),
        if (body.isNotEmpty) DVBox(BodyText(text: body), const DVModifier().paddingOnly(top: Space.sm)),
        if (link.isNotEmpty) OutLink(label: link, url: link, tooltip: 'Opens in a new tab'),
      ],
    );

@DVFunctionalWidget()
Widget _noteForm(BuildContext context, {required String classId, required VoidCallback onPosted}) {
  final DVSignal<bool> open = context.signal(false);
  final DVSignal<String> title = context.signal('');
  final DVSignal<String> body = context.signal('');
  final DVSignal<String> link = context.signal('');
  final DVSignal<bool> busy = context.signal(false);
  final DVSignal<String> problem = context.signal('');

  Future<void> post() async {
    busy.value = true;
    problem.value = '';
    try {
      await postNote(classId: classId, title: title.read(), noteText: body.read(), link: link.read());
      title.value = '';
      body.value = '';
      link.value = '';
      open.value = false;
      onPosted();
    } on Object catch (error) {
      problem.value = problemText(error);
    } finally {
      busy.value = false;
    }
  }

  if (!open.value) {
    return DVBox.row(<Widget>[QuietButton(label: '+ Post a note or link', tooltip: 'Share notes, a reading or a video with the class', onTap: () => open.value = true)], spacing: 0);
  }
  return Panel(
    children: <Widget>[
      Field(label: 'Title', value: title.value, hint: 'Week 3: Photosynthesis', onChanged: (String typed) => title.value = typed),
      Field(label: 'Note', value: body.value, hint: 'What to read, what to remember, what to bring', multiline: true, onChanged: (String typed) => body.value = typed),
      Field(label: 'Link (optional)', value: link.value, hint: 'https://…', onChanged: (String typed) => link.value = typed),
      DVBox.wrapLine(<Widget>[
        PrimaryButton(label: 'Post to class', tooltip: 'Everyone in the class sees it', busy: busy.value, onTap: post),
        QuietButton(label: 'Cancel', tooltip: 'Close without posting', onTap: () => open.value = false),
      ], spacing: Space.md, crossAlign: DVCrossAlign.center),
      if (problem.value.isNotEmpty) Notice(text: problem.value),
    ],
  );
}

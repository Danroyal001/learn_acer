import 'package:flutter/widgets.dart';

import 'ui.dart';
import '../dartvel_client/dartvel_client.dart';
import '../services/classroom_rules.dart';

/// Your classes, and the two ways into a new one: start it or join it.

String roleLabel(String role) => switch (role) {
      'teacher' => 'You teach this class',
      'parent' => 'You follow your child here',
      _ => 'You are a student',
    };

@DVFunctionalWidget()
Widget _classesScreen(BuildContext context) {
  final DVSignal<bool> started = context.signal(false);
  final DVSignal<List<Map<String, Object?>>?> classes = context.signal<List<Map<String, Object?>>?>(null);
  final DVSignal<String> problem = context.signal('');
  onFirstFrame(context, started, () async {
    try {
      classes.value = await myClasses();
    } on Object catch (error) {
      problem.value = problemText(error);
    }
  });
  final bool wide = MediaQuery.sizeOf(context).width >= 900;
  final List<Map<String, Object?>>? mine = classes.value;
  return PageColumn(
    maxWidth: 1040,
    children: <Widget>[
      const PageTitle(title: 'Your classes', lead: 'Join a class with the code your teacher gives you, or start one if you teach.'),
      if (problem.value.isNotEmpty) Notice(text: problem.value),
      if (mine == null && problem.value.isEmpty) const LoadingLine(),
      if (mine != null && mine.isEmpty) const BodyText(text: 'You are not in a class yet.', muted: true),
      if (mine != null && mine.isNotEmpty)
        DVBox.list(<Widget>[
          for (final Map<String, Object?> item in mine)
            ClassRow(id: '${item['id']}', name: '${item['name']}', subject: '${item['subject']}', teacher: '${item['teacher']}', role: '${item['role']}', code: '${item['code'] ?? ''}'),
        ], spacing: Space.md),
      DVBox.grid(const <Widget>[JoinForm(), StartForm()], columns: wide ? 2 : 1, spacing: Space.xl, modifier: const DVModifier().paddingOnly(top: Space.x2)),
    ],
  );
}

@DVFunctionalWidget()
Widget _classRow(BuildContext context, {required String id, required String name, required String subject, required String teacher, required String role, required String code}) {
  final Palette palette = Palette.of(context);
  return DVNavLink(
    to: DVRoutes.classesId(id: id),
    preview: DVLinkPreview.none,
    semanticLabel: '$name, $subject. ${roleLabel(role)}',
    child: DVBox.row(<Widget>[
      DVBox.list(<Widget>[
        SectionTitle(title: name, level: 3, size: 20),
        BodyText(text: '$subject · $teacher · ${roleLabel(role)}', size: 15, muted: true),
      ], spacing: 0),
      if (code.isNotEmpty) DVText(code).modifier(DVModifier().fontFamily(textFont).fontSize(18).fontWeight(FontWeight.w700).letterSpacing(2).color(palette.accent).semanticLabel('Class code $code')),
    ], align: DVAlign.spaceBetween, modifier: DVModifier().backgroundColor(palette.surface).rounded(12).border(Border.all(color: palette.rule)).padding(Space.lg).tooltip('Open $name')),
  );
}

@DVFunctionalWidget()
Widget _joinForm(BuildContext context) {
  final DVSignal<String> code = context.signal('');
  final DVSignal<String> childEmail = context.signal('');
  final DVSignal<String> role = context.signal('student');
  final DVSignal<bool> busy = context.signal(false);
  final DVSignal<String> problem = context.signal('');

  Future<void> join() async {
    final String? tidy = normaliseClassCode(code.read());
    if (tidy == null) {
      problem.value = 'A class code is 6 letters and numbers, like K7M3QP.';
      return;
    }
    busy.value = true;
    problem.value = '';
    try {
      final Map<String, Object?> joined = await joinClass(code: tidy, role: role.read(), childEmail: childEmail.read().trim());
      if (context.mounted) context.navigateToPage(DVRoutes.classesId(id: '${joined['id']}'));
    } on Object catch (error) {
      problem.value = problemText(error);
    } finally {
      busy.value = false;
    }
  }

  return Panel(
    children: <Widget>[
      const SectionTitle(title: 'Join a class', level: 2),
      Field(label: 'Class code', value: code.value, hint: 'K7M3QP', onChanged: (String typed) => code.value = typed, onSubmitted: join),
      const BodyText(text: 'I am joining as', size: 15, bold: true),
      ChoiceRow(
        options: const <(String, String, String)>[
          ('student', 'A student', 'Read notes, take quizzes, see your own scores'),
          ('parent', 'A parent', 'Read notes and see your child’s scores'),
        ],
        selected: role.value,
        onChanged: (String chosen) => role.value = chosen,
      ),
      if (role.value == 'parent') Field(label: 'Your child’s email', value: childEmail.value, hint: 'The email they sign in with', onChanged: (String typed) => childEmail.value = typed),
      DVBox.row(<Widget>[PrimaryButton(label: 'Join class', tooltip: 'Join the class with this code', busy: busy.value, onTap: join)], spacing: 0),
      if (problem.value.isNotEmpty) Notice(text: problem.value),
    ],
  );
}

@DVFunctionalWidget()
Widget _startForm(BuildContext context) {
  final DVSignal<String> name = context.signal('');
  final DVSignal<String> subject = context.signal('');
  final DVSignal<bool> busy = context.signal(false);
  final DVSignal<String> problem = context.signal('');

  Future<void> start() async {
    final String? wrong = classProblem(name: name.read(), subject: subject.read());
    if (wrong != null) {
      problem.value = wrong;
      return;
    }
    busy.value = true;
    problem.value = '';
    try {
      final Map<String, Object?> made = await createClass(name: name.read().trim(), subject: subject.read().trim());
      if (context.mounted) context.navigateToPage(DVRoutes.classesId(id: '${made['id']}'));
    } on Object catch (error) {
      problem.value = problemText(error);
    } finally {
      busy.value = false;
    }
  }

  final List<String> suggestions = subject.value.trim().length < 2
      ? const <String>[]
      : schoolSubjects.where((String each) => each.toLowerCase().contains(subject.value.trim().toLowerCase()) && each != subject.value).take(4).toList();
  return Panel(
    children: <Widget>[
      const SectionTitle(title: 'Start a class', level: 2),
      const BodyText(text: 'For teachers and tutors. You get a code to read out or share.', size: 15, muted: true),
      Field(label: 'Class name', value: name.value, hint: 'JSS2 Gold', onChanged: (String typed) => name.value = typed),
      Field(label: 'Subject', value: subject.value, hint: 'Mathematics', onChanged: (String typed) => subject.value = typed, onSubmitted: start),
      if (suggestions.isNotEmpty)
        DVBox.wrapLine(<Widget>[
          for (final String each in suggestions) QuietButton(label: each, tooltip: 'Use $each as the subject', onTap: () => subject.value = each),
        ], spacing: Space.xs),
      DVBox.row(<Widget>[QuietButton(label: busy.value ? 'Starting…' : 'Start class', tooltip: 'Create the class and get its join code', onTap: busy.value ? () {} : start)], spacing: 0),
      if (problem.value.isNotEmpty) Notice(text: problem.value),
    ],
  );
}

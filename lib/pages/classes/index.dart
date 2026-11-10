import 'package:flutter/material.dart';

import '../../components/ui.dart';
import '../../dartvel_client/dartvel_client.dart';
import '../../services/classroom_rules.dart';

/// Your classes, and the two ways into a new one: start it or join it.
@DVPage(
  title: 'Your classes – Learn Acer',
  description: 'Start a class as a teacher and share its code, or join one as a student or parent.',
)
Widget _classesPage(BuildContext context) => const ClassesScreen();

class ClassesScreen extends StatefulWidget {
  const ClassesScreen();

  @override
  State<ClassesScreen> createState() => ClassesScreenState();
}

class ClassesScreenState extends State<ClassesScreen> {
  List<Map<String, Object?>>? _classes;
  String? _loadProblem;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<Map<String, Object?>> found = await myClasses();
      if (mounted) setState(() => _classes = found);
    } on Object catch (error) {
      if (mounted) setState(() => _loadProblem = problemText(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= 900;
    final List<Widget> forms = <Widget>[const _JoinForm(), const _StartForm()];
    return PageColumn(
      maxWidth: 1040,
      children: <Widget>[
        const PageTitle('Your classes', lead: 'Join a class with the code your teacher gives you, or start one if you teach.'),
        if (_loadProblem != null) Notice(_loadProblem!),
        if (_classes == null && _loadProblem == null) const LinearProgressIndicator(),
        if (_classes != null && _classes!.isNotEmpty) ...<Widget>[
          for (final Map<String, Object?> item in _classes!) _ClassRow(item),
          const SizedBox(height: Space.x2),
        ],
        if (_classes != null && _classes!.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.xl),
            child: Text('You are not in a class yet.', style: textStyle(context, color: Palette.of(context).muted)),
          ),
        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Expanded(child: forms[0]), const SizedBox(width: Space.xl), Expanded(child: forms[1])])
        else ...<Widget>[forms[0], const SizedBox(height: Space.xl), forms[1]],
      ],
    );
  }
}

String _roleLabel(String role) => switch (role) {
      'teacher' => 'You teach this class',
      'parent' => 'You follow your child here',
      _ => 'You are a student',
    };

class _ClassRow extends StatelessWidget {
  const _ClassRow(this.item);

  final Map<String, Object?> item;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final String code = '${item['code'] ?? ''}';
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Tooltip(
        message: 'Open ${item['name']}',
        excludeFromSemantics: true,
        child: DVNavLink(
          to: DVRoutes.classesId(id: '${item['id']}'),
          preview: DVLinkPreview.none,
          semanticLabel: '${item['name']}, ${item['subject']}. ${_roleLabel('${item['role']}')}',
          child: Panel(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${item['name']}', style: displayStyle(context, size: 20)),
                      const SizedBox(height: Space.xs),
                      Text('${item['subject']} · ${item['teacher']} · ${_roleLabel('${item['role']}')}', style: textStyle(context, size: 15, color: palette.muted)),
                    ],
                  ),
                ),
                if (code.isNotEmpty) Text(code, style: textStyle(context, size: 18, weight: FontWeight.w700, color: palette.accent).copyWith(letterSpacing: 2)),
                const SizedBox(width: Space.sm),
                Icon(Icons.chevron_right, color: palette.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JoinForm extends StatefulWidget {
  const _JoinForm();

  @override
  State<_JoinForm> createState() => _JoinFormState();
}

class _JoinFormState extends State<_JoinForm> {
  final TextEditingController _code = TextEditingController();
  final TextEditingController _childEmail = TextEditingController();
  String _role = 'student';
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _code.dispose();
    _childEmail.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final String? code = normaliseClassCode(_code.text);
    if (code == null) {
      setState(() => _problem = 'A class code is 6 letters and numbers, like K7M3QP.');
      return;
    }
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final Map<String, Object?> joined = await joinClass(code: code, role: _role, childEmail: _childEmail.text.trim());
      if (mounted) context.navigateToPage(DVRoutes.classesId(id: '${joined['id']}'));
    } on Object catch (error) {
      if (mounted) setState(() => _problem = problemText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionTitle('Join a class'),
            LabelledField(label: 'Class code', controller: _code, hint: 'K7M3QP', textCapitalization: TextCapitalization.characters, onSubmitted: (_) => _join()),
            Text('I am joining as', style: textStyle(context, size: 15, weight: FontWeight.w600)),
            const SizedBox(height: Space.sm),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'student', label: Text('A student'), tooltip: 'Read notes, take quizzes, see your own scores'),
                ButtonSegment<String>(value: 'parent', label: Text('A parent'), tooltip: 'Read notes and see your child’s scores'),
              ],
              selected: <String>{_role},
              showSelectedIcon: false,
              onSelectionChanged: (Set<String> chosen) => setState(() => _role = chosen.first),
            ),
            const SizedBox(height: Space.lg),
            if (_role == 'parent')
              LabelledField(label: 'Your child’s email', controller: _childEmail, hint: 'The email they sign in with', keyboardType: TextInputType.emailAddress),
            PrimaryButton('Join class', tooltip: 'Join the class with this code', busy: _busy, onPressed: _join),
            if (_problem != null) Notice(_problem!),
          ],
        ),
      );
}

class _StartForm extends StatefulWidget {
  const _StartForm();

  @override
  State<_StartForm> createState() => _StartFormState();
}

class _StartFormState extends State<_StartForm> {
  final TextEditingController _name = TextEditingController();
  String _subject = schoolSubjects.first;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final String? problem = classProblem(name: _name.text, subject: _subject);
    if (problem != null) {
      setState(() => _problem = problem);
      return;
    }
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final Map<String, Object?> made = await createClass(name: _name.text.trim(), subject: _subject);
      if (mounted) context.navigateToPage(DVRoutes.classesId(id: '${made['id']}'));
    } on Object catch (error) {
      if (mounted) setState(() => _problem = problemText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionTitle('Start a class'),
            Text('For teachers and tutors. You get a code to read out or share.', style: textStyle(context, size: 15, color: Palette.of(context).muted)),
            const SizedBox(height: Space.lg),
            LabelledField(label: 'Class name', controller: _name, hint: 'JSS2 Gold', textCapitalization: TextCapitalization.words),
            DropdownButtonFormField<String>(
              initialValue: _subject,
              decoration: const InputDecoration(labelText: 'Subject', floatingLabelBehavior: FloatingLabelBehavior.always),
              items: <DropdownMenuItem<String>>[for (final String subject in schoolSubjects) DropdownMenuItem<String>(value: subject, child: Text(subject))],
              onChanged: (String? chosen) => setState(() => _subject = chosen ?? _subject),
            ),
            const SizedBox(height: Space.lg),
            QuietButton('Start class', tooltip: 'Create the class and get its join code', onPressed: _busy ? null : _start),
            if (_problem != null) Notice(_problem!),
          ],
        ),
      );
}

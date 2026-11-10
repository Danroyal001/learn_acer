# Learn Acer

Learn with ease, at school or at home. Built with [Dartvel](https://dartvel.dev).

- **Classes.** A teacher starts a class and gets a six-character code with no look-alike letters
  (no 0/O or 1/I/L). Students join as students; parents join with their child's email and see only
  that child's scores.
- **Learning aid.** The teacher posts notes and links to the class.
- **Quizzes.** The teacher sets multiple-choice quizzes. Students get the questions without the answers;
  the server marks each attempt and keeps the score, with a WAEC grade (A1 to F9) and a review of the
  right answers.
- **Exam practice.** Element symbols, times tables and mental maths, ten questions at a time, generated
  so every answer is right by construction.
- **Periodic table.** All 118 elements on the 18-column table (a searchable list on phones), each with
  its own page: mass, configuration, shells, melting and boiling points, density, discovery.
- **Calculator.** Scientific, with the usual order of operations, degrees or radians, and plain-English
  errors ("You cannot divide by zero").

Light mode is an exercise book (paper, ink blue, a red margin line); dark mode is a chalkboard.

## Run and build

```sh
dartvel dev
dartvel test
dartvel build web-server   # one binary; set DARTVEL_DATA_DIR outside the release folder
dartvel build android
```

Element data: [Bowserinator/Periodic-Table-JSON](https://github.com/Bowserinator/Periodic-Table-JSON), from
Wikipedia, CC BY-SA 3.0; regenerate `lib/content/elements.g.dart` with `node tool/generate_elements.mjs <json>`.
Fonts: Young Serif and Work Sans, SIL Open Font License.

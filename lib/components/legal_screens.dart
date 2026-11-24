// What Learn Acer keeps and the terms of using it, written from what the app really stores.
import 'package:flutter/widgets.dart';

import '../dartvel_client/dartvel_client.dart';
import 'ui.dart';


@DVFunctionalWidget()
Widget _privacyScreen(BuildContext context) => const PageColumn(
      maxWidth: 760,
      children: <Widget>[
        PageTitle(title: 'Privacy', lead: 'Last updated 24 November 2026. Learn Acer is run by SigmaDev Digital (business name BN 8969161, Nigeria). We keep what classes and quizzes need to work, and nothing else.'),
        SectionTitle(title: 'Without an account'),
        BodyText(text: 'The periodic table, the calculator and exam practice need no account. Practice scores are not saved. Like every website, our server sees your IP address when your browser asks for a page.'),
        SectionTitle(title: 'Your account'),
        BodyText(text: 'Your email address, the name you give, and a one-way hash of your password, never the password itself. For each device you sign in on: what the device reported itself as, when you signed in and when it was last used. A cookie keeps you signed in.'),
        SectionTitle(title: 'Classes'),
        BodyText(text: 'For a class: its name, subject, join code and the teacher who started it. For everyone in it: their name, email address and whether they joined as teacher, student or parent. A parent also gives the email address their child signs in with. The notes and links the teacher posts are kept with the class and shown to its members.'),
        SectionTitle(title: 'Quizzes and scores'),
        BodyText(text: 'The questions the teacher sets, and for each quiz attempt: who took it, the option chosen for each question, the score and when. The teacher sees every score in the class. A parent sees only that child’s scores, and students see their own.'),
        SectionTitle(title: 'No advertising or tracking'),
        BodyText(text: 'There are no adverts, no tracking analytics, no payments and no AI. Nothing is sold or shared for marketing, and nothing you type is sent to another company.'),
        SectionTitle(title: 'Where it is kept'),
        BodyText(text: 'On our own server in the European Union.'),
        SectionTitle(title: 'Your choices'),
        BodyText(text: 'To have your account, memberships and scores deleted, or to get a copy of everything we hold about you, email info@sigmadev.digital from the address you signed up with. We answer within 30 days. A teacher can ask us to delete a whole class the same way.'),
        SectionTitle(title: 'Children'),
        BodyText(text: 'Students are often children. We ask only for what a class needs, show a child’s scores only to their teacher and to a parent who knows the child’s email address, and never use them for anything else.'),
        SectionTitle(title: 'The law'),
        BodyText(text: 'We handle personal data under the Nigeria Data Protection Act 2023. Questions or complaints: info@sigmadev.digital.'),
      ],
    );

@DVFunctionalWidget()
Widget _termsScreen(BuildContext context) => const PageColumn(
      maxWidth: 760,
      children: <Widget>[
        PageTitle(title: 'Terms of use', lead: 'Last updated 24 November 2026. Learn Acer is run by SigmaDev Digital (business name BN 8969161, Nigeria). By using it you agree to these terms.'),
        SectionTitle(title: 'Learning aid'),
        BodyText(text: 'Practice questions, grades and element data are there to help you learn. Check anything that matters, such as an exam answer, against your textbook or your teacher. Element data comes from Wikipedia under CC BY-SA 3.0.'),
        SectionTitle(title: 'Accounts and classes'),
        BodyText(text: 'Keep your password to yourself. Share a class code only with the people the class is for. If you are under 18, ask a parent, guardian or teacher before you sign up.'),
        SectionTitle(title: 'What you post'),
        BodyText(text: 'Teachers are responsible for the notes, links and quizzes they post. Do not post anything unlawful, hurtful or that you have no right to share. We may remove it.'),
        SectionTitle(title: 'Fair use'),
        BodyText(text: 'Do not try to break, overload or get around the security of the service, or see scores that are not yours.'),
        SectionTitle(title: 'Price'),
        BodyText(text: 'Learn Acer is free. If we ever add a paid plan, its price and terms will be shown before you pay anything.'),
        SectionTitle(title: 'The service as it is'),
        BodyText(text: 'We work to keep Learn Acer running and correct, but provide it as it is, without a promise that it will always be available or free of mistakes. To the extent the law allows, we are not liable for loss from relying on it.'),
        SectionTitle(title: 'Changes and the law'),
        BodyText(text: 'If these terms change, the date above changes with them. They are governed by the laws of Nigeria and do not limit rights the law where you live gives you. Questions: info@sigmadev.digital.'),
      ],
    );

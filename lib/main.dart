import "dart:async";
// import "dart:math" as math;
// import "dart:isolate";
// import 'package:flutter/cupertino.dart';
import './custom_scrollbar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  GlobalState.init();
  return runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEARN ACER',
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: GlobalState.preferredTheme == "light"
            ? Color(0xFFECEDEF)
            : GlobalState.preferredTheme == "dark"
                ? Colors.grey[700]
                : Color(0xFFECEDEF),
        primaryColor: Colors.green[900],
        primaryColorLight: Colors.green[900],
        primaryColorDark: Colors.black,
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cursorColor: Colors.green[900],
        appBarTheme: AppBarTheme(
          color: Colors.green[900],
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Colors.grey[700],
          primaryColor: Colors.black,
          primaryColorLight: Colors.green[900],
          primaryColorDark: Colors.black,
          primaryIconTheme: IconThemeData(
            color: Colors.white,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cursorColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.black,
            brightness: Brightness.light,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          )),
      initialRoute: "/home",
      onGenerateRoute: FluroRouter.router.generator,
    );
  }
}

class FluroRouter {
  static Router router = Router();

  static Handler _homePageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());

  static Handler _classesPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ClassesPage());

  static Handler _periodicTablePageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          PeriodicTablePage());

  static Handler _calculatorPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          CalculatorPage());

  static Handler _learningAidPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LearningAidPage());

  static Handler _prepareForJAMBPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          PrepareForJAMBPage());

  static Handler _elementPreviewPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ElementPreviewPage(
            elem: GlobalState.elements[num.parse(params["symbol"][0])],
          ));

  static void setupRouter() {
    router.define('home',
        handler: _homePageHandler, transitionType: TransitionType.inFromBottom);

    router.define('periodic-table',
        handler: _periodicTablePageHandler,
        transitionType: TransitionType.inFromBottom);

    router.define('calculator',
        handler: _calculatorPageHandler,
        transitionType: TransitionType.inFromBottom);

    router.define('classes',
        handler: _classesPageHandler,
        transitionType: TransitionType.inFromBottom);

    router.define('learning-aid',
        handler: _learningAidPageHandler,
        transitionType: TransitionType.inFromBottom);

    router.define('prepare-for-exams',
        handler: _prepareForJAMBPageHandler,
        transitionType: TransitionType.inFromBottom);

    router.define('elements/:symbol',
        handler: _elementPreviewPageHandler,
        transitionType: TransitionType.inFromBottom);
  }
}

//data class for storing global variables and constatnt
class GlobalState {
  static Map<String, dynamic> store = <String, dynamic>{};

  static void init() {
    FluroRouter.setupRouter();
    print("INITIALIZATION COMPLETE");
  }

  static List<String> elemKeys = <String>[
    "Name",
    "Symbol",
    "Atomic Number",
    "Atomic Weight",
    "Atomic Mass",
    "Density",
    "Number of Electrons",
    "Number of Protons",
    "Number of Neutrons",
    "Latin Name",
    "Year Discovered",
    "CAS Number",
    "Discovered by",
    "Electron Shell",
    "Melting Point",
    "Boiling Point",
    "Phase / State",
    "Valency",
    "Period",
    "Group",
    "Block",
    "Electron Configuration",
    "ion Charge",
    "Oxidation States",
    "Atomic Radius",
    "Covalent Radius",
    "Electronegativity",
    "Electron Affinity",
    "Electrical Conductivity",
    "Is a Conductor",
    "Volume Magnetic Susceptibility",
    "Mass Magnetic Susceptibility",
    "Superconducting Point",
    "Crystal Structure",
    "Grid Parameters",
    "Attitude C/A",
    "Sun Contains",
    "Earth Contains",
    "Human Body Contains",
  ];

  static List<Map<String, String>> homePageItems = [
    {
      "title": "Join/Start a Class",
      "url": "classes",
      "image": "hand-books.jfif",
      "description":
          "Start a class if you are a Teacher, join one if you are a Student"
    },
    {
      "title": "Learning Aid",
      "url": "learning-aid",
      "image": "help-your-kids-learn.jpg",
      "description":
          "Get useful books, charts and Tutorial videos to boost your intelligence.",
    },
    {
      "title": "Prepare for Exams",
      "url": "prepare-for-exams",
      "description":
          "An extensive collection of resources to help you prepare for Exams."
    },
    {
      "title": "Periodic Table",
      "url": "periodic-table",
      "image": "periodic-table-wikipedia.png",
      "description": "A comprehensive periodic table."
    },
    {
      "title": "Calculator",
      "url": "calculator",
      "image": "calculator.jfif",
      "description": "A calculator could come in handy most times."
    }
  ];

  static List<Map<String, String>> elements = [
    {
      "Name": "Hydrogen",
      "Atomic Number": "1",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "H",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "1",
      "Number of Protons": "1",
      "Number of Neutrons":
          "Varies depending on the Isotope (1 for Light Hydrogen, 2 for Deuterium, 3 for Tritium)",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {
      "Name": "Helium",
      "Atomic Number": "2",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "He",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Lithium",
      "Atomic Number": "3",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Li",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Beryllium",
      "Atomic Number": "4",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Be",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {
      "Name": "Boron",
      "Atomic Number": "5",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "B",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Carbon",
      "Atomic Number": "6",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "C",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Nitrogen",
      "Atomic Number": "7",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "N",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Oxygen",
      "Atomic Number": "8",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "O",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Flourine",
      "Atomic Number": "9",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "F",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Neon",
      "Atomic Number": "10",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ne",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Sodium",
      "Atomic Number": "11",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Na",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Magnesium",
      "Atomic Number": "12",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Mg",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {
      "Name": "Aluminum",
      "Atomic Number": "13",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Al",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Silicon",
      "Atomic Number": "14",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Si",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Phosphorus",
      "Atomic Number": "15",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "P",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Sulfur",
      "Atomic Number": "16",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "S",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Chlorine",
      "Atomic Number": "17",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Cl",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Argon",
      "Atomic Number": "18",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ar",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Potassium",
      "Atomic Number": "19",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "K",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Calcium",
      "Atomic Number": "20",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ca",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Scandium",
      "Atomic Number": "21",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Sc",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Titanium",
      "Atomic Number": "22",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ti",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Vanadium",
      "Atomic Number": "23",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "V",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Chromium",
      "Atomic Number": "24",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Cr",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Manganese",
      "Atomic Number": "25",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Mn",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Iron",
      "Atomic Number": "26",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Fe",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Cobalt",
      "Atomic Number": "27",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Co",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Nickel",
      "Atomic Number": "28",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ni",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Copper",
      "Atomic Number": "29",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Cu",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Zinc",
      "Atomic Number": "30",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Zn",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Gallium",
      "Atomic Number": "31",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ga",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Germanium",
      "Atomic Number": "32",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ge",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Arsenic",
      "Atomic Number": "33",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "As",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Seleninum",
      "Atomic Number": "34",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Se",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Bromine",
      "Atomic Number": "35",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Br",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Krypton",
      "Atomic Number": "36",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Kr",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Rubydium",
      "Atomic Number": "37",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Rb",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Strontium",
      "Atomic Number": "38",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Sr",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Yttrium",
      "Atomic Number": "39",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Y",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "39",
      "Number of Protons": "39",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Zirconium",
      "Atomic Number": "40",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Zr",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Niobium",
      "Atomic Number": "41",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Nb",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Molybdenium",
      "Atomic Number": "42",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Mo",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Technetium",
      "Atomic Number": "43",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Tc",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Ruthernium",
      "Atomic Number": "44",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ru",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "45",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Rh",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "",
      "Number of Protons": "",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Palladium",
      "Atomic Number": "46",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Pd",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "45",
      "Number of Protons": "45",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Silver",
      "Atomic Number": "47",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ag",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "46",
      "Number of Protons": "46",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "48",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Cd",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "47",
      "Number of Protons": "47",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Tin",
      "Atomic Number": "49",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Sn",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "49",
      "Number of Protons": "49",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "---",
      "Atomic Number": "50",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Se",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "50",
      "Number of Protons": "50",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "51",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Sb",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "51",
      "Number of Protons": "51",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Tellurium",
      "Atomic Number": "52",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Te",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "52",
      "Number of Protons": "52",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Ioddine",
      "Atomic Number": "53",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "I",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "53",
      "Number of Protons": "53",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Xenon",
      "Atomic Number": "54",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Xe",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "54",
      "Number of Protons": "54",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "55",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Cs",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "55",
      "Number of Protons": "55",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "56",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ba",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "56",
      "Number of Protons": "56",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "57",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "La",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "57",
      "Number of Protons": "57",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "72",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Hf",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "72",
      "Number of Protons": "72",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "--",
      "Atomic Number": "73",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "Ta",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "73",
      "Number of Protons": "73",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
    {
      "Name": "Tungsten",
      "Atomic Number": "77",
      "Atomic Weight": "",
      "Atomic Mass": "",
      "Symbol": "W",
      "Density": "",
      "Latin Name": "",
      "Year Discovered": "",
      "CAS Number": "",
      "Discovered by": "",
      "Electron Shell": "",
      "Number of Electrons": "74",
      "Number of Protons": "74",
      "Number of Neutrons": "",
      "Melting Point": "",
      "Boiling Point": "",
      "Phase / State": "",
      "Valency": "",
      "Period": "",
      "Group": "",
      "Block": "",
      "Electron Configuration": "",
      "ion Charge": "",
      "Oxidation States": "",
      "Atomic Radius": "",
      "Covalent Radius": "",
      "Electronegativity": "",
      "Electron Affinity": "",
      "Electrical Conductivity": "",
      "Is a Conductor": "",
      "Volume Magnetic Susceptibility": "",
      "Mass Magnetic Susceptibility": "",
      "Superconducting Point": "",
      "Crystal Structure": "",
      "Grid Parameters": "",
      "Attitude C/A": "",
      "Sun Contains": "",
      "Earth Contains": "",
      "Human Body Contains": "",
    },
  ];

  static bool isLoggedIn = false;

  static final GlobalKey<ScaffoldState> homePageScaffoldKey =
      GlobalKey<ScaffoldState>();

  static void openHomePageDrawer() {
    homePageScaffoldKey.currentState.openDrawer();
  }

  static String setTheme(String themePreference) {
    preferredTheme = themePreference;
    return preferredTheme;
  }

  static List<Map<String, dynamic>> menuItems = <Map<String, dynamic>>[
    {
      "label": "Primary",
      "icon": Icon(Icons.home),
      "active-icon": Icon(Icons.home),
      "url": "/home",
    },
    {
      "label": "My Files",
      "icon": Icon(Icons.insert_drive_file),
      "active-icon": Icon(Icons.insert_drive_file),
      "url": "/my-files",
    },
    {
      "label": "My Inbox",
      "icon": Icon(Icons.mail_outline),
      "active-icon": Icon(Icons.mail),
      "url": "/inbox",
    },
    {
      "label": "Bookmarks",
      "icon": Icon(Icons.bookmark_border),
      "active-icon": Icon(Icons.bookmark),
      "url": "/my-bookmarks",
    },
  ];

  static String preferredTheme = "system";
}

class MobileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 16,
        child: ListView(children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: GlobalState.preferredTheme == "dark"
                  ? Theme.of(context).primaryColorDark
                  : GlobalState.preferredTheme == "light"
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor,
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Hi There...",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Divider(
                  height: 5,
                ),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    return false;
                  },
                  child: Text(
                    "LOGIN/SIGN UP",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    locale: Locale("en", "NG"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
          ),
          ...List.generate(GlobalState.menuItems.length, (int _index) {
            return ListTile(
                leading: GlobalState.menuItems[_index]['active-icon'],
                title: Text("${GlobalState.menuItems[_index]['label']}"),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("${GlobalState.menuItems[_index]['url']}");
                });
          }),
        ]));
  }
}

class PeriodicTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 8 + ((MediaQuery.of(context).size.height / 10) * 18),
          height: 8 + ((MediaQuery.of(context).size.height / 10) * 11),
          child: GridView.builder(
            primary: true,
            padding: EdgeInsets.all(2.0),
            scrollDirection: Axis.vertical,
            itemCount: GlobalState.elements.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 18,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemBuilder: (BuildContext _context, int _index) {
              Map<String, String> _elem = GlobalState.elements[_index];
              return GestureDetector(
                onTap: () {
                  String _target = (_index != null && _elem["Name"] != null)
                      ? "elements/$_index"
                      : "/periodic-table";
                  Navigator.of(context).pushNamed(_target);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 9,
                  width: MediaQuery.of(context).size.height / 9,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: _elem['Name'] != null
                            ? Colors.green
                            : Colors.transparent,
                      ),
                      left: BorderSide(
                        width: 1.0,
                        color: _elem['Name'] != null
                            ? Colors.green
                            : Colors.transparent,
                      ),
                      right: BorderSide(
                        width: 1.0,
                        color: _elem['Name'] != null
                            ? Colors.green
                            : Colors.transparent,
                      ),
                      bottom: BorderSide(
                        width: 1.0,
                        color: _elem['Name'] != null
                            ? Colors.green
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(
                              _elem['Atomic Number'] != null
                                  ? "${_elem['Atomic Number']}"
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                // color: Colors.white,
                                fontSize: 25 *
                                    ((MediaQuery.of(context).size.height / 11) /
                                        100),
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Text(
                                _elem['Symbol'] != null
                                    ? "${_elem['Symbol']}"
                                    : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                  fontSize: 35 *
                                      ((MediaQuery.of(context).size.height /
                                              11) /
                                          100),
                                )),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Text(
                                _elem['Name'] != null ? "${_elem['Name']}" : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  // color: Colors.white,
                                  fontSize: 25 *
                                      ((MediaQuery.of(context).size.height /
                                              11) /
                                          100),
                                ))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalState.homePageScaffoldKey,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.share),
        label: Text("SHARE"),
        onPressed: () {},
      ),
      drawer: MediaQuery.of(context).size.width <= 700 ? MobileMenu() : null,
      body: Row(children: <Widget>[
        if (MediaQuery.of(context).size.width > 700) NavRail(),
        Expanded(
          child: Scrollbar(
              controller: ScrollController(),
              isAlwaysShown: true,
              child: HomePageContent()),
        ),
      ]),
    );
  }
}

class PeriodicTablePage extends StatelessWidget {
  @override
  Widget build(context) {
    // ScrollController _ctrl = ScrollController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).popAndPushNamed("/home"),
        ),
        title: Text("PERIODIC TABLE"),
      ),
      body: SafeArea(
        child: Center(
          child: PeriodicTable(),
        ),
      ),
    );
  }
}

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed("/home"),
          tooltip: "Back",
        ),
        title: Text("CALCULATOR"),
      ),
      body: Center(
        child: CalculatorUI(),
      ),
    );
  }
}

class LearningAidPage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).popAndPushNamed("/home"),
        ),
        title: Text("LEARNING AID"),
      ),
      body: SafeArea(
        child: Center(),
      ),
    );
  }
}

class ClassesPage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        // bottom: (),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).popAndPushNamed("/home"),
        ),
        title: Text("CLASSES"),
      ),
      body: SafeArea(
        child: Center(
          // scrollDirection: Axis.vertical,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width >= 500
                        ? 450
                        : MediaQuery.of(context).size.width,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      cursorColor: Colors.green[900],
                      maxLines: 1,
                      showCursor: true,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.start,
                      enableSuggestions: true,
                      autocorrect: true,
                      onTap: () => null,
                      onChanged: (String val) {},
                      onEditingComplete: () {},
                      onSubmitted: (String val) {},
                      readOnly: false,
                      decoration: const InputDecoration(
                        isDense: false,
                        labelText: "Search:",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabled: true,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 5,
                  thickness: 5,
                  color: Colors.transparent,
                ),
                Expanded(
                  child: Container(
                    child: Scrollbar(
                      controller: ScrollController(),
                      isAlwaysShown: true,
                      child: CustomScrollbar.rrect(
                        child: GridView.builder(
                        itemCount: 5,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2.0,
                            crossAxisCount: MediaQuery.of(context).size.width <=
                                    500
                                ? 1
                                : (MediaQuery.of(context).size.width <= 1000 &&
                                        MediaQuery.of(context).size.width > 500)
                                    ? 2
                                    : 3,
                            crossAxisSpacing: 0.5,
                            mainAxisSpacing: 0.5),
                        itemBuilder: (BuildContext context, int _ind) {
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Card(
                                  shadowColor: Theme.of(context).primaryColor,
                                  elevation: 16,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/hand-books.jfif")))),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(),
                                      ),
                                    ]),
                                  )),
                            ),
                          );
                        },
                      ),
                      ),
                    ),
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}

class PrepareForJAMBPage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).popAndPushNamed("/home"),
        ),
        title: Text("PREPARE FOR EXAMS"),
      ),
      body: SafeArea(
        child: Center(),
      ),
    );
  }
}

class CalculatorUI extends StatefulWidget {
  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  // static String stringValue = "";

  // static double value = num.parse(stringValue);

  static TextEditingController _ctrl = TextEditingController();

  static num evalString(String val) {
    return num.parse(val);
  }

  @override
  void initState() {
    super.initState();
    _ctrl.text = "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Theme.of(context).primaryColor,
        elevation: 18,
        child: Container(
            width: MediaQuery.of(context).size.width <= 500
                ? MediaQuery.of(context).size.width
                : 500,
            // height: MediaQuery.of(context).size.height <= 500
            //     ? MediaQuery.of(context).size.height
            //     : 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    child: TextField(
                      controller: _ctrl,
                      // keyboardType: TextInputType.number,
                      autofocus: true,
                      showCursor: false,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.end,
                      enableSuggestions: false,
                      autocorrect: false,
                      onTap: () => false,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: "Input:",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabled: true,
                        prefix: Icon(Icons.input),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2.5,
                      mainAxisSpacing: 2.5,
                      childAspectRatio: 1.9,
                      children: <Widget>[
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text =
                                    "${evalString(_ctrl.text) * evalString(_ctrl.text) * evalString(_ctrl.text)}";
                              });
                            },
                            child: Center(
                              child: Text(
                                "X^3",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text =
                                    "${evalString(_ctrl.text) * evalString(_ctrl.text)}";
                              });
                            },
                            child: Center(
                              child: Text(
                                "X^2",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "(";
                              });
                            },
                            child: Center(
                              child: Text(
                                "(",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += ")";
                              });
                            },
                            child: Center(
                              child: Text(
                                ")",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                _ctrl.text = "";
                              });
                            },
                            child: Center(
                              child: Text(
                                "CA",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "sqrt(";
                              });
                            },
                            child: Center(
                              child: Text(
                                "sqrt",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {},
                            child: Center(
                              child: Text(
                                "+/-",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text =
                                    "${_ctrl.text.split('').sublist(0, _ctrl.text.length - 1).reduce((a, b) => a + b)}";
                              });
                            },
                            child: Center(
                              child: Icon(Icons.backspace),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "9";
                              });
                            },
                            child: Center(
                              child: Text(
                                "9",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "8";
                              });
                            },
                            child: Center(
                              child: Text(
                                "8",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "7";
                              });
                            },
                            child: Center(
                              child: Text(
                                "7",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "/";
                              });
                            },
                            child: Center(
                              child: Text(
                                "/",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "6";
                              });
                            },
                            child: Center(
                              child: Text(
                                "6",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "5";
                              });
                            },
                            child: Center(
                              child: Text(
                                "5",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "4";
                              });
                            },
                            child: Center(
                              child: Text(
                                "4",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "-";
                              });
                            },
                            child: Center(
                              child: Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "3";
                              });
                            },
                            child: Center(
                              child: Text(
                                "3",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "2";
                              });
                            },
                            child: Center(
                              child: Text(
                                "2",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "1";
                              });
                            },
                            child: Center(
                              child: Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "+";
                                evalString("2+5");
                              });
                            },
                            child: Center(
                              child: Text(
                                "+",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += ".";
                              });
                            },
                            child: Center(
                              child: Text(
                                ".",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "0";
                              });
                            },
                            child: Center(
                              child: Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                _ctrl.text += "*";
                              });
                            },
                            child: Center(
                              child: Text(
                                "*",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                        MaterialButton(
                            color: Colors.green[900],
                            onPressed: () {
                              setState(() {
                                // _ctrl.text = "${evalString(_ctrl.text)}";
                                // Isolate.spawnUri(uri, args, message)
                              });
                            },
                            child: Center(
                              child: Text(
                                "=",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}

class ElementPreviewPage extends StatelessWidget {
  final Map<String, String> elem;

  const ElementPreviewPage({@required this.elem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  tooltip: "Back",
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed("/periodic-table")),
              expandedHeight: MediaQuery.of(context).size.height / 2,
              pinned: true,
              elevation: 50,
              backgroundColor: GlobalState.preferredTheme == "dark"
                  ? Theme.of(context).primaryColorDark
                  : GlobalState.preferredTheme == "light"
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("${elem['Name']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      backgroundColor: GlobalState.preferredTheme == "dark"
                          ? Theme.of(context).primaryColorDark
                          : GlobalState.preferredTheme == "light"
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    )),
                background: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/atomic-prototype.jfif")))),
                  ],
                )),
              )),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                  GlobalState.elemKeys.length,
                  (_ind) => Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Card(
                          elevation: 8,
                          child: Container(
                            width: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width
                                : 500,
                            height: 50,
                            child: ListTile(
                                title: Text(
                                    "${GlobalState.elemKeys[_ind]} : ${elem[GlobalState.elemKeys[_ind]]}")),
                          ),
                        )),
                      )),
            ),
          ),
        ]));
  }
}

class ElementImagePreviewPage extends StatelessWidget {
  final String name;

  ElementImagePreviewPage({@required this.name});

  @override
  Widget build(BuildContext context) => Container();
}

class NavRail extends StatefulWidget {
  final Key key;
  NavRail({this.key}) : super(key: key);

  @override
  _NavRailState createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static int _selIndex = 0;
  static bool _isExtended = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        NavigationRail(
          unselectedIconTheme: IconThemeData(
            color: Colors.white,
          ),
          minWidth: 50,
          onDestinationSelected: (int destination) {
            setState(() {
              _selIndex = destination;
            });
          },
          backgroundColor: GlobalState.preferredTheme == "light"
              ? Theme.of(context).primaryColorLight
              : GlobalState.preferredTheme == "dark"
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).primaryColor,
          selectedIndex: _selIndex,
          extended: _isExtended,
          leading: Column(children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage("assets/Icon-512.png"),
            ),
            Divider(),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Logout",
              onPressed: () {},
            ),
            Divider(),
            Divider(),
          ]),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(),
                Divider(),
                IconButton(
                    tooltip: "Expand/Collapse This Menu",
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        _isExtended = !_isExtended;
                      });
                    })
              ]),
          destinations:
              List.generate(GlobalState.menuItems.length, (int _index) {
            Map<String, dynamic> item = GlobalState.menuItems[_index];
            return NavigationRailDestination(
              icon: item["icon"],
              selectedIcon: item["active-icon"],
              label: Text("${item["label"]}"),
            );
          }),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Colors.white,
        ),
      ],
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            leading: MediaQuery.of(context).size.width <= 700
                ? IconButton(
                    onPressed: GlobalState.openHomePageDrawer,
                    tooltip: "Menu",
                    icon: Icon(Icons.menu),
                  )
                : Container(),
            expandedHeight: MediaQuery.of(context).size.height / 2,
            pinned: true,
            elevation: 50,
            backgroundColor: GlobalState.preferredTheme == "dark"
                ? Theme.of(context).primaryColorDark
                : GlobalState.preferredTheme == "light"
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('LEARN ACER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    backgroundColor: GlobalState.preferredTheme == "dark"
                        ? Theme.of(context).primaryColorDark
                        : GlobalState.preferredTheme == "light"
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  )),
              background: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/Icon-512.png")))),
                ],
              )),
              // Image.network(
              //   'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
              //   fit: BoxFit.cover,
            )),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Center(
                  child: Text(
                    "Learning Continues",
                    textAlign: TextAlign.center,
                    locale: Locale("en", "NG"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.0 /*0.7*/,
              crossAxisCount: MediaQuery.of(context).size.width <= 500
                  ? 1
                  : (MediaQuery.of(context).size.width <= 1000 &&
                          MediaQuery.of(context).size.width > 500)
                      ? 2
                      : 3,
              crossAxisSpacing: 0.5,
              mainAxisSpacing: 0.5),
          delegate: SliverChildListDelegate(
              List.generate(GlobalState.homePageItems.length, (_i) {
            Map<String, String> _item = GlobalState.homePageItems[_i];
            String _title = _item["title"];
            String _url = _item["url"];
            String _description = _item["description"];
            String _image = _item["image"];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/$_url");
              },
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Card(
                    shadowColor: GlobalState.preferredTheme == "dark"
                        ? Theme.of(context).primaryColorDark
                        : GlobalState.preferredTheme == "light"
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColor,
                    elevation: 30.0,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.5),
                          border: Border(
                            top: BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                            left: BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                            right: BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                            bottom: BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text("$_title",
                                  textAlign: TextAlign.center,
                                  locale: Locale("en", "NG"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/$_image"),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    "$_description",
                                    textAlign: TextAlign.center,
                                    locale: Locale("en", "NG"),
                                  )),
                            ),
                          ),
                        ]))),
              ),
            );
          })),
        ),
      ],
    );
  }
}

// Movies: 👇👇
//
// fast cash
// murder in prime suites
// enigme
// 8 : southafrican
// miracle : nollywood
// Jagaban
// Black November
// Onye Ukwe

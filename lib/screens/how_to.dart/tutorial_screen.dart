import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:library_app/screens/how_to.dart/sheet_image_animation.dart';
import 'package:library_app/screens/link_library/link_library.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;

  final List<Widget> _pages = const [
    TutorialStartPage(),
    TutorialPage(
      title: "Required Tab",
      description:
          'Please include a tab containing all scores in your sheet. This tab should have the default name "Sheet1"',
      image: "assets/img/tab_screenshot.png",
    ),
    RequiredColumnsPage(),
    CatalogNumPage(),
    TutorialPage(
      title: "Status",
      description:
          "You can track the status of each score by inputting a value in the status column.\n\nStatuses may include:\n\nIn Library\nChecked out\nMissing\nIncomplete\nIn Binders\nDigital Only",
    ),
    OtherCategoriesPage(),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      _finishTutorial();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  void _finishTutorial() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LinkLibraryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final currentPageWidget = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.black45,
      body: Container(
        padding: EdgeInsets.all(24),
        alignment: Alignment.center,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Material(
            elevation: 20,
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _finishTutorial,
                      child: const Text('Skip'),
                    ),
                  ),
                  currentPageWidget,
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: _prevPage,
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 64), // for alignment
                      // The dot indicators now go between Back and Next
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  _currentPage == index
                                      ? Colors.red[900]
                                      : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Finish' : 'Next',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialStartPage extends StatelessWidget {
  const TutorialStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Let's set up your library!",
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Here are some guidelines for making your Google Sheet library catalog compatible with this app.',
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 24),
        SizedBox(width: 150, child: Image.asset("assets/img/happy_dance.png")),
      ],
    );
  }
}

class RequiredColumnsPage extends StatelessWidget {
  const RequiredColumnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SheetImageAnimation(),
        SizedBox(height: 24),
        Text(
          'Required Columns',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Please ensure your Google Sheet includes the following column headers:',
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 24),
        Text(
          'Catalog Number\nTitle\nComposer\nArranger\nCategory\nSubcategories\nStatus\nLink\nChange Time\nNotes',
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}

class TutorialPage extends StatelessWidget {
  final String title;
  final String description;
  final String? image;

  const TutorialPage({
    super.key,
    required this.title,
    required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        if (image != null) ...[const SizedBox(height: 24), Image.asset(image!)],
      ],
    );
  }
}

class CatalogNumPage extends StatelessWidget {
  const CatalogNumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Catalog Number",
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "The catalog number for each score should be a letter identifier for the category, followed by up to four digits, with no space between.",
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: const Color.from(
                    alpha: .3,
                    red: 0.106,
                    green: 0.369,
                    blue: 0.125,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check, color: Colors.green[300], size: 32),
                    SizedBox(height: 8),
                    Text(
                      "C1000\nWW01\nsw1234",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(183, 28, 28, 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.close, color: Colors.red[300], size: 32),
                    SizedBox(height: 8),
                    Text(
                      "C 1000\nWW-1234\n54321",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OtherCategoriesPage extends StatelessWidget {
  const OtherCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Category",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              "This is the broad category for the piece of music. For example: concert band, big band, or woodwind quintet",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 16),
            Text(
              "Subcategory",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              "More specific categories to help categorize music. For example: march, pop, or anthem. Multiple subcategories should be seperated with a comma.",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 16),
            Text(
              "Change Time",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              "This ensures data consistency when multiple people are editing a library. This field can be left blank but should be updated when you edit a row in Google Sheets",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 16),
            Text(
              "Link",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              "The link to a digital copy in the Google Drive if one exists",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

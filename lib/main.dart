import 'package:flutter/material.dart';
//import 'package:flutter_persistent_tab/eCommerce.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Persistent Tab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PermanenTab(),
    );
  }
}

class PersistentTabs extends StatelessWidget {
  const PersistentTabs({
    @required this.screenWidgets,
    this.currentTabIndex = 0,
  });
  final int currentTabIndex;
  final List<Widget> screenWidgets;

  List<Widget> _buildOffstageWidgets() {
    return screenWidgets
        .map(
          (w) => Offstage(
            offstage: currentTabIndex != screenWidgets.indexOf(w),
            child: Navigator(
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (_) => w);
              },
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildOffstageWidgets(),
    );
  }
}

class PermanenTab extends StatefulWidget {
  @override
  _PermanenTabState createState() => _PermanenTabState();
}

class _PermanenTabState extends State<PermanenTab> {
  int currentTabIndex;

  @override
  void initState() {
    super.initState();
    currentTabIndex = 0;
  }

  void setCurrentIndex(int val) {
    setState(() {
      currentTabIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabs(
        currentTabIndex: currentTabIndex,
        screenWidgets: [Home(), Explore()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: setCurrentIndex,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Jelajah",
          ),
        ],
      ),
    );
  }
}

_pushTo(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Halaman Beranda"),
                    Icon(Icons.home),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.red,
                    ),
                  );
                },
                child: Text("Halaman Merah"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.green,
                    ),
                  );
                },
                child: Text("Halaman Hijau"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.blue,
                    ),
                  );
                },
                child: Text("Halaman Biru"),
              ),
              // SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     _pushTo(context, ECommerce());
              //   },
              //   child: Text("Halaman Belanja"),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class Explore extends StatelessWidget {
  const Explore({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Halaman Jelajah!"),
                  Icon(Icons.explore),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.red,
                    ),
                  );
                },
                child: Text("Halaman Merah"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.green,
                    ),
                  );
                },
                child: Text("Halaman Hijau"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pushTo(
                    context,
                    ColorScreen(
                      color: Colors.blue,
                    ),
                  );
                },
                child: Text("Halaman Biru"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ColorScreen extends StatelessWidget {
  const ColorScreen({this.color = Colors.red});
  final Color color;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24);

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "R: " + color.red.toString(),
              style: textStyle,
            ),
            Text(
              "G: " + color.green.toString(),
              style: textStyle,
            ),
            Text(
              "B: " + color.blue.toString(),
              style: textStyle,
            ),
            Text(
              "A: " + color.alpha.toString(),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

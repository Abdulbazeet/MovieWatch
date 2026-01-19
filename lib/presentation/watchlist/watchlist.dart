import 'package:flutter/material.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

late TabController _tabBarController;

class _WatchlistState extends State<Watchlist>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 3, vsync: this);
  }

  List<String> seenOptions = ['Movies', 'Tv Shows', 'K dramas'];

  String _pickedString = 'Movies';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Lists", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Text(
                  "Seenlist",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Favourites",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Watchlist",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            controller: _tabBarController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabBarController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,

                          children: List.generate(
                            seenOptions.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: FilterChip(
                                onSelected: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _pickedString = seenOptions[index];
                                    }
                                  });
                                },
                                color: _pickedString == seenOptions[index]
                                    ? WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.primary
                                            .withValues(alpha: .2),
                                      )
                                    : WidgetStatePropertyAll(
                                        Colors.grey.withValues(alpha: .2),
                                      ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),

                                  side: BorderSide(
                                    color: _pickedString == seenOptions[index]
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                  ),
                                ),

                                label: Text(
                                  seenOptions[index],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      
                    ],
                  ),
                ),
                Center(child: Text("Favourites")),
                Center(child: Text("Watchlist")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

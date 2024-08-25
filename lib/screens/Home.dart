import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String urlHome = "https://hurawatch2.to/home";
  String urlMovie = "https://hurawatch2.to/movie";
  String urlTv = "https://hurawatch2.to/tv";
  String urlTop = "https://hurawatch2.to/top-imdb";
  String urlFilter = "https://hurawatch2.to/filter";

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
      color: const Color.fromRGBO(0, 32, 58, 1), enabled: true);
  final List<ContentBlocker> contentBlockers = [];
  bool isLoading = true;
  int progress = 0;
  int currentIndex = 0;
  String? lastUrl;

  @override
  void initState() {
    super.initState();

    lastUrl = null;

    pullToRefreshController = PullToRefreshController(
      settings: pullToRefreshSettings,
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    final hurawatchUrlFilters = [
      ".*.whos.amung.us/.*",
      ".*.weepingcart.com/.*",
      ".*.l.sharethis.com/.*",
      ".*.count-server.sharethis.com/.*",
      ".*.mc.yandex.ru/.*",
      // ".*.be6721.rcr72.waw04.cdn112.com/.*",
      ".*.precedelaxative.com/.*",
    ];
    final youtubeUrlFilters = [
      ".*.static.doubleclick.net/.*",
      ".*.play.google.com/.*",
      ".*.googleads.g.doubleclick.net/.*",
      ".*.youtube.com/ptracking/.*",
      ".*.doubleclick.net.*",
      ".*.youtube.com/youtubei.*",
      ".*.youtube.com/pagead.*",
      ".*.youtube.com/api/stats/qoe.*",
      ".*.doubleclick.net.*",
    ];
    final adUrlFilters = [
      ".*.doubleclick.net/.*",
      ".*.ads.pubmatic.com/.*",
      ".*.googlesyndication.com/.*",
      ".*.google-analytics.com/.*",
      ".*.adservice.google.*/.*",
      ".*.adbrite.com/.*",
      ".*.exponential.com/.*",
      ".*.quantserve.com/.*",
      ".*.scorecardresearch.com/.*",
      ".*.zedo.com/.*",
      ".*.adsafeprotected.com/.*",
      ".*.teads.tv/.*",
      ".*.outbrain.com/.*",
      ...hurawatchUrlFilters,
      ...youtubeUrlFilters
    ];
    // for each Ad URL filter, add a Content Blocker to block its loading.
    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          )));
    }

    // apply the "display: none" style to some HTML elements
    contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector: ".banner, .banners, .ads, .ad, .advert")));
  }

  @override
  Widget build(BuildContext context) {
    String suggestionJS = '''
      var suggestion = document.querySelector('.suggesstion');
      suggestion.style.display = 'flex'
      suggestion.style.flexWrap = 'wrap';

      if (suggestion?.children.length > 0) {
        var s2 = suggestion.firstElementChild
        s2.style.display = 'flex'
        s2.style.flexDirection = 'row'
        s2.style.flexWrap = 'wrap';
        s2.style.gap = '0 60px'
        s2.style.width = '100%'

        var s1 = document.querySelectorAll('.suggesstion div a');
        s1.forEach((e) => {
            e.style.width = '100px'
        })

        var s3 = document.querySelectorAll('.suggesstion div img');
        s3.forEach((e) => {
            e.style.width = 'max-content'
            e.style.height = 'max-content'
        })

        var s4 = document.querySelectorAll('.suggesstion div div span');
        s4.forEach((e) => {
            e.style.maxWidth = '200px'
            e.style.width = 'max-content'
        })

        var sgn2 = suggestion.lastElementChild
        sgn2.lastElementChild.style.width = 'max-content'
      }
      
    ''';

    String videoFilterJS = '''
      var filter = document.getElementById('video-filter');
      var search = filter.firstElementChild;
      search.style.width = '100%';
      var btn = filter.lastElementChild;
      btn.style.width = '33.3333333333%'
    ''';
    String txtJS = '''
      document.querySelector('.mb-3').style.display = 'none'
    ''';

    void updateNav() async {
      WebUri? uri = await webViewController?.getUrl();
      String? currentUrl = uri.toString();

      if (lastUrl != currentUrl) {
        lastUrl = currentUrl;
        if (currentUrl == urlHome) {
          setState(() {
            currentIndex = 0;
          });
        } else if (currentUrl == urlMovie) {
          setState(() {
            currentIndex = 1;
          });
        } else if (currentUrl == urlTv) {
          setState(() {
            currentIndex = 2;
          });
        } else if (currentUrl == urlTop) {
          setState(() {
            currentIndex = 3;
          });
        }
      }

      if (currentUrl != urlHome) {
        webViewController?.evaluateJavascript(source: videoFilterJS);
      }

      if (currentUrl == urlHome) {
        webViewController?.evaluateJavascript(source: txtJS);
      }
    }

    updateNav();

    webViewController?.evaluateJavascript(source: '''
      document.querySelector('#primary-nav-toggle').style.display = 'none';
      document.querySelector('.logo').style.display = 'none';
      document.querySelector('#user-section').style.visibility = 'hidden';

      document.querySelector('header .container').style.marginTop = "20px";

      var genreList = document.querySelectorAll('.swiper-slide');
      var genre = genreList[1];
      genre.style.display = 'none'

      var top_search = document.querySelector('.search-inner form');
      top_search.style.width = '100%';
      top_search.style.opacity = 1;
      top_search.style.pointerEvents = 'auto';
      var fil = top_search?.lastElementChild;
      fil.style.display = 'none';
      var inp = top_search.querySelector('input')
      inp.placeholder = 'Search your movies and series...'

      var footer = document.getElementsByTagName('footer'); 
      footer[0].style.display = 'none';

      var sg = document.querySelector('.suggesstion')
      sg.style.marginTop = '-30px'
      sg.style.marginLeft = '1px'
      sg.style.width = '99%'

    ''');

    void nav(int index) {
      webViewController?.stopLoading();
      setState(() {
        currentIndex = index;
      });
      String url = index == 0
          ? urlHome
          : index == 1
              ? urlMovie
              : index == 2
                  ? urlTv
                  : index == 3
                      ? urlTop
                      : urlHome;
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: WebUri(url),
              cachePolicy: URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD));
    }

    return WillPopScope(
      onWillPop: () async {
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 31, 51),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color.fromRGBO(0, 22, 35, 1),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              onTap: (value) => nav(value),
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: const Color.fromARGB(255, 0, 57, 79),
              selectedItemColor: Colors.white,
              elevation: 20,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  label: "home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.movie_outlined,
                  ),
                  label: "movie",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.tv_outlined,
                  ),
                  label: "tv",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.trending_up_outlined,
                  ),
                  label: "top",
                ),
              ]),
          body: Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    pullToRefreshController: pullToRefreshController,
                    initialUrlRequest: URLRequest(url: WebUri(urlHome)),
                    initialSettings: InAppWebViewSettings(
                      contentBlockers: contentBlockers,
                      allowBackgroundAudioPlaying: true,
                      allowsPictureInPictureMediaPlayback: true,
                      useOnLoadResource: true,
                      cacheEnabled: true,
                      cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                      verticalScrollBarEnabled: false,
                      horizontalScrollBarEnabled: false,
                    ),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        isLoading = true;
                      });
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                      if (error.type ==
                          WebResourceErrorType.UNSUPPORTED_SCHEME) {
                        controller.goBack();
                      }
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        isLoading = false;
                      });
                      pullToRefreshController?.endRefreshing();
                    },
                    onUpdateVisitedHistory: (controller, url, isReload) {
                      setState(() {
                        isLoading = true;
                      });
                    },
                    onTitleChanged: (controller, title) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress;
                      });
                    },
                    onLoadResource: (controller, resource) {
                      webViewController?.evaluateJavascript(
                          source: suggestionJS);
                    },
                  ),
                  isLoading || progress < 80
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 27, 43, 0.823)),
                          child: Image.asset(
                            "lib/assets/images/loader.gif",
                            width: 100,
                            alignment: Alignment.center,
                          ),
                          // child: const CircularProgressIndicator(
                          //     color: Color.fromARGB(255, 240, 249, 255)),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ])),
    );
  }
}

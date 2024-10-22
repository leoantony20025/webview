import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String urlHome = "https://iosmirror.cc/";
  String urlMovie = "https://iosmirror.cc/movies";
  String urlTv = "https://iosmirror.cc/series";
  String urlVerify = "https://iosmirror.cc/verify";

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  CookieManager cookieManager = CookieManager.instance();
  late PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
      color: const Color.fromRGBO(0, 32, 58, 1), enabled: true);
  final List<ContentBlocker> contentBlockers = [];
  bool isLoading = true;
  int progress = 0;
  int currentIndex = 0;
  String? lastUrl;
  bool toggle = false;
  bool isModalOpen = false;
  int resourceLoad = 0;

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
      ".*.platform-cdn.sharethis.com/.*",
      ".*.lashahib.net/.*",
      ".*.histats.com/.*",
      ".*.prd.jwpltx.com/.*",
      ".*.icon_.*",
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
      ".*.xvide/.*",
      ".*.redtube.com/.*",
      ".*.azvid.com/.*",
      ".*.piratebay.com/.*",
      ".*.youpo/.*",
      ".*.exponential.com/.*",
      ".*.quantserve.com/.*",
      ".*.scorecardresearch.com/.*",
      ".*.zedo.com/.*",
      ".*.adsafeprotected.com/.*",
      ".*.teads.tv/.*",
      ".*.outbrain.com/.*",
      ".*.googletagmanager.com/.*",
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
            selector:
                ".banner, .banners, .afs_ads, .ad-placement, .ads, .ad, .advert")));
  }

  @override
  Widget build(BuildContext context) {
    String closeJS = '''
      var play = document.querySelectorAll('.top-search-play')
      play.forEach(e => e.style.border = '1.5px solid white')

      var modalDisplay = document.querySelector('.modal').style.display;
      var searchDisplay = document.querySelector('#search').style.display;
      console.log(modalDisplay);
      var isModalOpen = false;
      if (modalDisplay === 'block' || searchDisplay === 'block') {
        isModalOpen = true;
      } else {
        isModalOpen = false;
      }

      window.flutter_inappwebview.callHandler('modalHandler', isModalOpen);
    ''';

    String modalJS = '''
      document.querySelector('.modal').style.display = 'none';
      document.querySelector('#search').style.display = 'none';
      document.querySelector('#player').classList.add('hide');
      window.flutter_inappwebview.callHandler('modalHandler', false);
    ''';
    void updateNav() async {
      WebUri? uri = await webViewController?.getUrl();
      String? currentUrl = uri.toString();

      if (currentUrl == urlVerify) {
        await webViewController?.evaluateJavascript(source: '''

          // window.localStorage.setItem("_grecaptcha", "09APKjawcmHc9G5H_KB2njhMvBCTwFx5BhmHR0DsZ9qoNvirPFS2us7r8M71ld6fT9xY6FGpwmzb0eB7CB58QfAvNckcFDpAKfbXC7MQ");
          // document.cookie = "t_hash_t=ace3374245aeb7531bbb75274883e918%3A%3Ae2c95a078d776bd721147af644a95224%3A%3A1725870840%3A%3Ani; path=/";
          // document.cookie = "t_hash=ace3374245aeb7531bbb75274883e918%3A%3Ae2c95a078d776bd721147af644a95224%3A%3A1725870840%3A%3Ani; path=/";

          document.querySelector('.header').style.display = 'none';
          var h1 = document.querySelectorAll('.info2 h1')
          h1.forEach(e => {
            e.style.display = 'none';
          })
          document.querySelector('.desc').style.display = 'none';
          document.querySelector('#botverify input').style.display = 'none';
          document.querySelector('.info2 button').style.display = 'none';

        ''');
        // final expiresDate =
        //     DateTime.now().add(Duration(days: 100)).millisecondsSinceEpoch;
        // await cookieManager.setCookie(
        //   url: WebUri("https://iosmirror.cc"),
        //   name: "t_hash_t",
        //   value:
        //       "ace3374245aeb7531bbb75274883e918%3A%3Ae2c95a078d776bd721147af644a95224%3A%3A1725870840%3A%3Ani",
        //   domain: ".iosmirror.cc",
        //   path: "/",
        //   expiresDate: expiresDate,
        // );
        // await cookieManager.setCookie(
        //   url: WebUri("https://iosmirror.cc"),
        //   name: "t_hash",
        //   value:
        //       "ace3374245aeb7531bbb75274883e918%3A%3Ae2c95a078d776bd721147af644a95224%3A%3A1725870840%3A%3Ani",
        //   domain: ".iosmirror.cc",
        //   path: "/",
        //   expiresDate: expiresDate,
        // );

        // webViewController?.loadUrl(
        //     urlRequest: URLRequest(
        //         url: WebUri(urlHome),
        //         cachePolicy:
        //             URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD));
      }

      // if (lastUrl != currentUrl) {
      //   lastUrl = currentUrl;
      //   if (currentUrl == urlHome) {
      //     setState(() {
      //       currentIndex = 0;
      //     });
      //   } else if (currentUrl == urlMovie) {
      //     setState(() {
      //       currentIndex = 1;
      //     });
      //   } else if (currentUrl == urlTv) {
      //     setState(() {
      //       currentIndex = 2;
      //     });
      //   }
      // }

      if (lastUrl != currentUrl) {
        lastUrl = currentUrl;
        if (currentUrl == urlMovie) {
          setState(() {
            currentIndex = 0;
          });
        } else if (currentUrl == urlTv) {
          setState(() {
            currentIndex = 1;
          });
        }
      }

      if (currentUrl == urlHome) {
        webViewController?.evaluateJavascript(source: '''
          document.querySelector('.header').style.display = 'initial';
          document.querySelectorAll('.tray-container').item(0).style.display = 'none';
          document.querySelectorAll('.tray-container').item(5).style.display = 'none';
          document.querySelectorAll('.tray-container').item(12).style.display = 'none';

          // const element = document.querySelector('.nav-link .home'); 
          // element.classList.remove('home'); 
          // element.classList.add('home_filled'); 
        ''');
      }
    }

    updateNav();

    webViewController?.evaluateJavascript(source: '''
      window.addEventListener('focus', function() {
        window.blur();
      });
      document.querySelectorAll('.nav-container').item(0).style.visibility = 'visible';
      document.documentElement.style.setProperty('-webkit-tap-highlight-color', 'transparent');
      document.querySelector('.ott-list').style.display = 'none';
      document.querySelector('.note-msg').style.display = 'none';
      document.querySelector('.account').style.display = 'none';
      document.querySelector('#hhide').style.display = 'none';
      document.querySelector('.play-btn-s').style.display = 'none';
      document.querySelector('.model-btn-download').style.display = 'none';
      document.querySelector('.model-rating-box').style.display = 'none';
      document.querySelector('#search-input').style.boxShadow = 'none';
      document.querySelector('.footer').style.display = 'none';
      document.querySelector('.btn-close-moveable').style.display = 'none';
      document.querySelector('.btn-close2').style.padding = '15px';
      document.querySelector('.btn-search-close').style.padding = '15px';

      document.querySelector('.search').style.zIndex = '2';
      document.querySelector('.modal').style.zIndex = '3';
      document.querySelector('#player').style.zIndex = '3';
      // document.querySelector('.bottom-navigation-container').style.zIndex = '4';

      var btns = document.querySelectorAll('.info .ion-align-items-center .ion-tex-center')
      btns.item(0).style.display = 'none'
      btns.item(1).style.flex = 1
      btns.item(1).style.maxWidth = '100%'
      btns.item(1).style.marginLeft = '20px'

      document.querySelector('.nav-container').style.padding = '10px ';
      document.querySelector('.nav-logo a').onclick = '/home ';

      var logo = document.querySelector('.brand-logo')
      logo.src = "https://img.icons8.com/external-tal-revivo-color-tal-revivo/24/external-netflix-an-american-video-on-demand-service-logo-color-tal-revivo.png"
      logo.style.width = "30px"
      logo.style.height = "30px"

      // var nav = document.querySelector('.bottom-navigation-container div ul')
      // nav.style.justifyContent = 'space-evenly'
      // var navItems = nav.children
      // navItems.item(2).style.display = 'none'
      // navItems.item(4).style.display = 'none'

    ''');

    webViewController?.addJavaScriptHandler(
        handlerName: 'modalHandler',
        callback: (args) {
          bool isModalOpen = args[0]; // The value passed from JavaScript
          setState(() {
            this.isModalOpen = isModalOpen;
          });
        });

    void nav(int index) {
      webViewController?.stopLoading();
      setState(() {
        currentIndex = index;
      });
      // String url = index == 0
      //     ? urlHome
      //     : index == 1
      //         ? urlMovie
      //         : index == 2
      //             ? urlTv
      //             : urlHome;
      String url = index == 0
          ? urlMovie
          : index == 1
              ? urlTv
              : urlMovie;
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: WebUri(url),
              cachePolicy: URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD));
    }

    Future<void> setCookie() async {
      final expiresDate =
          DateTime.now().add(const Duration(days: 100)).millisecondsSinceEpoch;
      await cookieManager.setCookie(
        url: WebUri("https://iosmirror.cc"),
        name: "hd",
        value: "on",
        domain: ".iosmirror.cc",
        path: "/",
        expiresDate: expiresDate,
      );
    }

    setCookie();

    return WillPopScope(
      onWillPop: () async {
        if (isModalOpen) {
          webViewController?.evaluateJavascript(source: modalJS);
          setState(() {
            resourceLoad = 0;
          });
          return false;
        }
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 21, 21, 21),
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          currentIndex: currentIndex,
          onTap: (value) => nav(value),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color.fromRGBO(53, 53, 53, 1),
          selectedItemColor: Colors.white,
          elevation: 20,
          items: const [
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.movie_outlined,
            //   ),
            //   activeIcon: Icon(
            //     Icons.movie_rounded,
            //   ),
            //   label: "Home",
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.movie_outlined,
              ),
              activeIcon: Icon(
                Icons.movie_rounded,
              ),
              label: "Movies",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.smart_display_outlined,
              ),
              activeIcon: Icon(
                Icons.smart_display_rounded,
              ),
              label: "Series",
            ),
          ],
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  pullToRefreshController: pullToRefreshController,
                  initialUrlRequest: URLRequest(url: WebUri(urlMovie)),
                  keepAlive: InAppWebViewKeepAlive(),
                  initialSettings: InAppWebViewSettings(
                    contentBlockers: contentBlockers,
                    allowBackgroundAudioPlaying: true,
                    allowsPictureInPictureMediaPlayback: true,
                    useOnLoadResource: true,
                    cacheEnabled: true,
                    cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                    verticalScrollBarEnabled: false,
                    horizontalScrollBarEnabled: false,
                    iframeAllowFullscreen: false,
                    isTextInteractionEnabled: false,
                    javaScriptEnabled: true,
                    userAgent:
                        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 OPR/113.0.0.0",
                    thirdPartyCookiesEnabled: true,
                    sharedCookiesEnabled: true,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                    if (error.type == WebResourceErrorType.UNSUPPORTED_SCHEME) {
                      controller.goBack();
                    }
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      isLoading = false;
                      resourceLoad = 0;
                    });
                    pullToRefreshController?.endRefreshing();
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
                    if (resourceLoad < 5) {
                      webViewController?.evaluateJavascript(source: closeJS);
                    }
                  },
                ),
                isLoading || progress < 100
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.915)),
                        child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 220, 23, 23)),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ]),
      )),
    );
  }
}

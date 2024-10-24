import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String urlHome = "https://iosmirror.cc/home";
  String urlMovie = "https://iosmirror.cc/movies";
  String urlTv = "https://iosmirror.cc/series";

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  final List<ContentBlocker> contentBlockers = [];
  bool isLoading = true;
  int progress = 0;
  int currentIndex = 0;
  String? lastUrl = null;
  bool toggle = false;
  bool isModalOpen = false;
  int resourceLoad = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    // CookieManager cookieManager = CookieManager.instance();

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
        }
      }

      if (currentUrl == urlHome) {
        webViewController?.evaluateJavascript(source: '''
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
      // window.addEventListener('focus', function() {
      //   window.blur();
      // });

      var ad = document.querySelector('.open-support')
      if (ad != null) {
        console.log("adddddddddddddddddddd")
        document.querySelector('.header').style.display = 'none'
        document.querySelector('h1').style.color = 'white'
        document.querySelector('h1').style.width = '70vw'
        document.querySelector('h1').innerHTML = 'Unlimited movies, TV shows and more'
        document.querySelector('h3').style.display = 'none'
        document.querySelectorAll('p').forEach(e => e.style.display = 'none')
        document.querySelector('.ssss').style.display = 'none'
        document.querySelector('.info2 button').innerHTML = 'Start Now'
        document.querySelector('.info2 button').style.background = '#c11119'
        document.querySelector('.info2 button').style.fontWeight = '500'
        document.querySelector('.info2 button').style.fontSize = 'medium'
        document.querySelector('body button:last-of-type').style.display = 'none'
        document.querySelector('.spotlight').style.filter = 'blur(10px)'
        
        // document.querySelector('.info2').style.opacity = '0'
        // ad.click()
        // loaction.href = '/home'
      } else {
        document.querySelector('.app').style.maxWidth = '100%';
        document.querySelector('.header').style.maxWidth = '100%';
        document.documentElement.style.setProperty('-webkit-tap-highlight-color', 'transparent');
        // document.documentElement.style.setProperty('-webkit-scrollbar', 'transparent');
        document.querySelector('.ott-list').style.display = 'none';
        document.querySelector('.note-msg').style.display = 'none';
        document.querySelector('.account').style.display = 'none';
        document.querySelector('#hhide').style.display = 'none';
        document.querySelector('.play-btn-s').style.display = 'none';
        document.querySelector('.model-btn-download').style.display = 'none';
        document.querySelector('.model-rating-box').style.display = 'none';
        document.querySelector('.search').style.maxWidth = '100%';
        document.querySelector('.modal-dialog').style.maxWidth = '100%';
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
      }
      

    ''');

    if (isDesktop) {
      webViewController?.evaluateJavascript(source: '''
        document.querySelector('.nav-container').style.padding = '30px ';
        var playBtn = document.querySelector('.btn-play')
        playBtn.style.width = 'max-content ';
        playBtn.style.padding = '10px 40px ';
        playBtn.querySelector('.ion-color').style.width = '30px'
        var info = document.querySelector('.spotlight .info')
        info.style.textAlign = 'left'
        info.style.marginLeft = '30px'
        info.style.bottom = '30px'
        info.querySelector('ion-row').lastElementChild.style.display = 'none'
        document.querySelector('.gradient').style.background = 'linear-gradient(#fff0, #00000036, #000)'
        document.querySelector('.gradient').style.height = '100vh'
        document.querySelector('.spotlight').style.height = '100vh'
        document.querySelector('.spotlight').style.marginBottom = '30px'
        document.querySelectorAll('.tray-container .mobile-tray-title').forEach(e => e.style.paddingLeft = '30px')
        document.querySelectorAll('.tray-slide:first-child').forEach(e => e.style.marginLeft = '30px')
        
        var navContainer = document.querySelector('.nav-container');

        if (navContainer && navContainer.children.length <= 4) {
          const e1 = document.createElement('a');
          e1.href = "/";
          e1.addEventListener('click', () => location.href = '/')
          e1.textContent = 'Home';
          e1.style.marginLeft = '10px';
          e1.style.fontWeight = '550';

          const e2 = document.createElement('a');
          e2.href = "/movies";
          e1.addEventListener('click', () => location.href = '/movies')
          e2.textContent = 'Movies';
          e2.style.marginLeft = '10px';
          e2.style.fontWeight = '550';

          const e3 = document.createElement('a');
          e3.href = "/series";
          e1.addEventListener('click', () => location.href = '/series')
          e3.textContent = 'TV Shows';
          e3.style.marginLeft = '10px';
          e3.style.fontWeight = '550';
          navContainer.insertBefore(e1, navContainer.children[1]);
          navContainer.insertBefore(e2, navContainer.children[2]);
          navContainer.insertBefore(e3, navContainer.children[3]);
        } 

      ''');
    }

    webViewController?.addJavaScriptHandler(
        handlerName: 'modalHandler',
        callback: (args) {
          bool isModalOpen = args[0]; // The value passed from JavaScript
          setState(() {
            this.isModalOpen = isModalOpen;
          });
        });

    // print("MOODALLLLLLLLLLLLLLLLLL $isModalOpen");

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
                  : urlHome;
      webViewController?.loadUrl(
          urlRequest: URLRequest(
        url: WebUri(url),
      ));
    }

    // Future<void> setCookie() async {
    //   final expiresDate =
    //       DateTime.now().add(Duration(days: 100)).millisecondsSinceEpoch;
    //   bool ck = await cookieManager.setCookie(
    //     url: WebUri("https://iosmirror.cc"),
    //     name: "hd",
    //     value: "on",
    //     domain: ".iosmirror.cc",
    //     path: "/",
    //     expiresDate: expiresDate,
    //   );
    //   print("COOOOOOOOOOOOOOKIEEEEEEE $ck");
    // }

    // setCookie();

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
          // minimum: EdgeInsets.all(20),
          child: isDesktop
              ? Scaffold(
                  backgroundColor: Colors.black,
                  body: Column(children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: [
                          Focus(
                            // focusNode: _focusNode,
                            onFocusChange: (value) {},
                            onKeyEvent: (node, event) {
                              if (event is KeyDownEvent) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowUp) {
                                  // _focusNode.requestFocus();
                                  webViewController
                                      ?.evaluateJavascript(source: """
                                        var prevElem = document.activeElement.previousElementSibling;
                                        if (prevElem && prevElem.hasAttribute('tabindex')) {
                                          prevElem.focus();
                                        }
                                      """);
                                  return KeyEventResult.handled;
                                }
                                // Handle arrow down, left, right similarly
                              }
                              return KeyEventResult.ignored;
                            },
                            child: InAppWebView(
                              key: webViewKey,
                              initialUrlRequest:
                                  URLRequest(url: WebUri(urlHome)),
                              initialSettings: InAppWebViewSettings(
                                  contentBlockers: contentBlockers,
                                  clearCache: true,
                                  allowBackgroundAudioPlaying: true,
                                  allowsPictureInPictureMediaPlayback: true,
                                  useOnLoadResource: true,
                                  cacheEnabled: false,
                                  useOnDownloadStart: true,
                                  // cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                                  verticalScrollBarEnabled: false,
                                  horizontalScrollBarEnabled: false,
                                  iframeAllowFullscreen: false,
                                  isTextInteractionEnabled: false,
                                  hardwareAcceleration: true,
                                  javaScriptEnabled: true),
                              onWebViewCreated: (controller) {
                                webViewController = controller;
                              },
                              onReceivedServerTrustAuthRequest:
                                  (controller, challenge) async {
                                return ServerTrustAuthResponse(
                                    action:
                                        ServerTrustAuthResponseAction.PROCEED);
                              },
                              onLoadStart: (controller, url) {
                                setState(() {
                                  isLoading = true;
                                });
                              },
                              onReceivedError: (controller, request, error) {
                                if (error.type ==
                                    WebResourceErrorType.UNSUPPORTED_SCHEME) {
                                  controller.goBack();
                                }
                              },
                              onLoadStop: (controller, url) async {
                                setState(() {
                                  isLoading = false;
                                  resourceLoad = 0;
                                });
                                await controller.evaluateJavascript(source: """
                                  document.querySelectorAll('a, button, input, .btn-play, article').forEach(function(el) {
                                    if (!el.hasAttribute('tabindex')) {
                                      el.setAttribute('tabindex', '0');
                                    }
                                  });
                                """);
                                await controller.evaluateJavascript(source: """
                                  document.addEventListener('keydown', function(event) {
                                    switch (event.key) {
                                      case 'ArrowUp':
                                        event.preventDefault();
                                        let prevElem = document.activeElement.previousElementSibling;
                                        if (prevElem && prevElem.hasAttribute('tabindex')) {
                                          prevElem.focus();
                                        }
                                        break;
                                      case 'ArrowDown':
                                        event.preventDefault();
                                        let nextElem = document.activeElement.nextElementSibling;
                                        if (nextElem && nextElem.hasAttribute('tabindex')) {
                                          nextElem.focus();
                                        }
                                        break;
                                      case 'ArrowLeft':
                                        event.preventDefault();
                                        let prevElemLeft = document.activeElement.previousElementSibling;
                                        if (prevElemLeft && prevElemLeft.hasAttribute('tabindex')) {
                                          prevElemLeft.focus();
                                        }
                                        break;
                                      case 'ArrowRight':
                                        event.preventDefault();
                                        let nextElemRight = document.activeElement.nextElementSibling;
                                        if (nextElemRight && nextElemRight.hasAttribute('tabindex')) {
                                          nextElemRight.focus();
                                        }
                                        break;
                                    }
                                  });

                                """);
                              },
                              onTitleChanged: (controller, title) {
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              shouldOverrideUrlLoading:
                                  (controller, navigationAction) async {
                                final uri = navigationAction.request.url!;
                                print('hostttttTTTTTTTTTTT' + uri.host);
                                var whiteList = [
                                  "www.iosmirror.cc",
                                  "iosmirror.cc",
                                  "www.verify2.iosmirror.cc"
                                ];
                                if (whiteList.contains(uri.host)) {
                                  return NavigationActionPolicy.ALLOW;
                                }
                                return NavigationActionPolicy.CANCEL;
                              },
                              onProgressChanged: (controller, progress) {
                                if (progress == 100) {}
                                setState(() {
                                  this.progress = progress;
                                });
                              },
                              onLoadResource: (controller, resource) {
                                if (resourceLoad < 5) {
                                  webViewController?.evaluateJavascript(
                                      source: closeJS);
                                }
                              },
                            ),
                          ),
                          progress < 70
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
                )
              : Scaffold(
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
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.home_outlined,
                        ),
                        activeIcon: Icon(
                          Icons.home_filled,
                        ),
                        label: "Home",
                      ),
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
                            initialUrlRequest: URLRequest(url: WebUri(urlHome)),
                            initialSettings: InAppWebViewSettings(
                                contentBlockers: contentBlockers,
                                clearCache: true,
                                allowBackgroundAudioPlaying: true,
                                allowsPictureInPictureMediaPlayback: true,
                                useOnLoadResource: true,
                                cacheEnabled: false,
                                useOnDownloadStart: true,
                                // cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                                verticalScrollBarEnabled: false,
                                horizontalScrollBarEnabled: false,
                                iframeAllowFullscreen: false,
                                isTextInteractionEnabled: false,
                                hardwareAcceleration: true,
                                javaScriptEnabled: true),
                            onWebViewCreated: (controller) {
                              webViewController = controller;
                            },
                            shouldOverrideUrlLoading:
                                (controller, navigationAction) async {
                              final uri = navigationAction.request.url!;
                              print('hosttttttttttttt' + uri.host);
                              var whiteList = [
                                "iosmirror.cc",
                                "userverify.netmirror.app"
                              ];
                              if (whiteList.contains(uri.host)) {
                                return NavigationActionPolicy.ALLOW;
                              }
                              return NavigationActionPolicy.CANCEL;
                            },
                            onReceivedServerTrustAuthRequest:
                                (controller, challenge) async {
                              return ServerTrustAuthResponse(
                                  action:
                                      ServerTrustAuthResponseAction.PROCEED);
                            },
                            onLoadStart: (controller, url) {
                              setState(() {
                                isLoading = true;
                              });
                            },
                            onReceivedError: (controller, request, error) {
                              if (error.type ==
                                  WebResourceErrorType.UNSUPPORTED_SCHEME) {
                                controller.goBack();
                              }
                            },
                            onTitleChanged: (controller, title) {
                              setState(() {
                                isLoading = false;
                              });
                            },
                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {}
                              setState(() {
                                this.progress = progress;
                              });
                            },
                            onLoadResource: (controller, resource) {
                              if (resourceLoad < 5) {
                                webViewController?.evaluateJavascript(
                                    source: closeJS);
                              }
                            },
                          ),
                          progress < 100
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

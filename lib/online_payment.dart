library online_payment;

import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_payment/src/abstract/online_payment_sm_listener.dart';
import 'package:online_payment/src/config/constants/app_strings.dart';
import 'package:online_payment/src/model/enums/status_code.dart';
import 'package:online_payment/src/model/response/initiate_response.dart';
import 'package:online_payment/src/service/api_service.dart';
import 'package:online_payment/src/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'src/model/credentials.dart';
import 'src/model/initiate_data.dart';
import 'src/model/response/payment_details.dart';
import 'src/utils/log_print.dart';

export 'src/config/constants/app_service.dart';
export 'src/config/constants/app_strings.dart';
export 'src/model/credentials.dart';
export 'src/model/initiate_data.dart';
export 'src/model/response/initiate_response.dart';
export 'src/model/response/payment_details.dart';
export 'src/service/api_service.dart';
export 'src/service/handle_error.dart';
export 'src/service/http_service.dart';
export 'src/utils/log_print.dart';
export 'src/utils/utils.dart';

class OnlinePayment {
  /// credentials is required for any request [GET, POST]
  Credentials credentials;

  /// initial data required for initiate a transaction
  InitiateData initiateData;

  /// show app log
  bool showLog;

  /// initiate [OnlinePayment]
  OnlinePayment({
    required this.credentials,
    required this.initiateData,
    this.showLog = true,
  });

  /// get instance of [Utils]
  Utils get utils => Utils();

  /// get instance of [AppStrings]
  AppStrings get strings => AppStrings();

  /// get instance of [InitiateResponse]
  Future<InitiateResponse> get initiate async => await ApiService.initiate(
        credentials,
        initiateData,
      );

  /// get payment details
  Future<PaymentDetails> paymentDetails(String trxId) async =>
      await ApiService.getDetails(
        credentials,
        trxId,
      );
}

class OnlinePaymentSM extends StatefulWidget
    implements OnlinePaymentSMListener {
  final Credentials credentials;
  final InitiateData initiateData;

  @override
  final void Function() paymentSuccess;

  @override
  final void Function() paymentFailed;

  @override
  final void Function() paymentInComplete;

  const OnlinePaymentSM({
    Key? key,
    required this.credentials,
    required this.initiateData,
    required this.paymentSuccess,
    required this.paymentFailed,
    required this.paymentInComplete,
    // this.onLoadStart,
  }) : super(key: key);

  @override
  _OnlinePaymentSMState createState() => _OnlinePaymentSMState();
}

class _OnlinePaymentSMState extends State<OnlinePaymentSM> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  bool isInitPaymentSuccess = false;
  InitiateResponse? _initiateResponse;

  // final String webUrl = "https://google.com";
  // final String webUrl = "https://payment.smanager.xyz/@Zotnovmhs41dv";
  String webUrl = "https://google.com";

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Color(0xfff47f17),
      ),
      onRefresh: () async {
        isInitPaymentSuccess = false;
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Future<bool> willPop() async {
    if (urlController.text == (_initiateResponse?.data?.link ?? "")) {
      widget.paymentInComplete();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return isInitPaymentSuccess ? _afterResponseAction() : _initialize();
  }

  Widget _initialize() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: FutureBuilder(
          future: ApiService.initiate(
            widget.credentials,
            widget.initiateData,
          ),
          builder: (
            BuildContext context,
            AsyncSnapshot<InitiateResponse> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return _dataFetchedErrorMsg();
              }
              _initiateResponse = snapshot.data;
              return _afterResponseAction();
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _afterResponseAction() {
    return _initiateResponse == null ? _dataFetchedErrorMsg() : _startWebview();
  }

  Widget _dataFetchedErrorMsg() {
    return Center(child: Text("Data Fetched Error"));
  }

  Widget _startWebview() {
    if (_initiateResponse != null &&
        (_initiateResponse?.code ?? StatusCode.FAILED_TO_INITIATE) !=
            StatusCode.SUCCESS) {
      isInitPaymentSuccess = false;
      return Center(
        child: Text(
          "Failed to Initiate: ${_initiateResponse?.message}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
    String initUrl = _initiateResponse?.data?.link ?? "";
    isInitPaymentSuccess = true;
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              // contextMenu: contextMenu,
              initialUrlRequest: URLRequest(url: Uri.parse(initUrl)),
              // initialFile: "assets/index.html",
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                if (widget.initiateData.successUrl == url.toString()) {
                  widget.paymentSuccess();
                } else if (widget.initiateData.failedUrl == url.toString()) {
                  widget.paymentFailed();
                }

                LogPrint.info("PaymentScreen", "build", "URL $url");
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onReceivedServerTrustAuthRequest:
                  (InAppWebViewController controller,
                      URLAuthenticationChallenge challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunch(url)) {
                    // Launch the App
                    await launch(
                      url,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}

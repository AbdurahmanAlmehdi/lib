import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';

class MoamalatWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const MoamalatWebViewScreen({super.key, required this.paymentUrl});

  @override
  State<MoamalatWebViewScreen> createState() => _MoamalatWebViewScreenState();
}

class _MoamalatWebViewScreenState extends State<MoamalatWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  String currentUrl = '';
  bool _canRedirect = true;

  final List<String> successKeywords = ['payment-success', 'success'];

  @override
  void initState() {
    super.initState();
    currentUrl = widget.paymentUrl;
    isLoading = true;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36',
      )
      ..setBackgroundColor(AppColors.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              debugPrint('onPageStarted: $url');
              isLoading = false;
              currentUrl = url;
              _redirect(url);
            });
          },
          onPageFinished: (String url) {
            setState(() {
              debugPrint('onPageFinished: $url');
              isLoading = false;
              currentUrl = url;
              _redirect(url);
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('onNavigationRequest: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _redirect(String url) {
    if (!_canRedirect) return;

    final isSuccess = successKeywords.any((keyword) => url.contains(keyword));
    final isFailed = url.contains('payment-failed');

    if (isSuccess || isFailed) {
      _canRedirect = false;
      if (mounted) {
        context.pop(isSuccess);
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return Future.value(false);
    } else {
      debugPrint('app exited');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _exitApp(context);
        if (shouldExit && mounted) {
          context.pop(false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text(
            context.t.moamalat,
            style: AppTypography.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(context.t.cancel),
                  content: Text(context.t.cancelPaymentConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(context.t.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (mounted) {
                          context.pop(false);
                        }
                      },
                      child: Text(context.t.confirm),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: Text(
                'Test',
                style: AppTypography.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: AppColors.surface,
                      child: WebViewWidget(controller: controller),
                    ),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

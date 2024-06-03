import 'dart:developer';
import 'package:devproj/pages/shared_pages/welcome_screen.dart';
import 'package:devproj/pages/shared_pages/home_screen.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

class SplashScreenView extends StatefulWidget {
  final String? imageSrc;
  final Duration duration;
  final double logoSize;
  final Duration speed;
  final PageRouteTransition? pageRouteTransition;
  final EdgeInsets paddingText;
  final AnimatedText? text;
  final Color backgroundColor;
  final LinearGradient? linearGradient;
  final EdgeInsets paddingLoading;
  final bool displayLoading;

  const SplashScreenView({
    Key? key,
    required this.imageSrc,
    this.backgroundColor = Colors.white,
    this.linearGradient,
    this.duration = const Duration(milliseconds: 3000),
    this.logoSize = 150,
    this.speed = const Duration(milliseconds: 1000),
    this.pageRouteTransition,
    this.paddingText = const EdgeInsets.only(right: 10, left: 10, top: 20),
    this.text,
    this.paddingLoading = const EdgeInsets.only(bottom: 100),
    this.displayLoading = true,
  }) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool _isNetworkImage = false;
  bool _isLottie = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));

    _animationController.forward();

    if (widget.imageSrc != null && widget.imageSrc!.isNotEmpty) {
      if (widget.imageSrc!.startsWith("http://") ||
          widget.imageSrc!.startsWith("https://")) {
        _isNetworkImage = true;
      } else {
        _isNetworkImage = false;
      }
    } else {
      _isNetworkImage = false;
    }

    //lottie
    if (widget.imageSrc != null && widget.imageSrc!.isNotEmpty) {
      if (widget.imageSrc!.endsWith(".json")) {
        _isLottie = true;
      } else {
        _isLottie = false;
      }
    } else {
      _isLottie = false;
    }

    log("widget._isNetworkImage $_isNetworkImage");

    Future.delayed(
      Duration(milliseconds: widget.duration.inMilliseconds + 2000),
    ).then((value) {
      if (widget.pageRouteTransition ==
          PageRouteTransition.CupertinoPageRoute) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => HomeScreen()));
      } else if (widget.pageRouteTransition ==
          PageRouteTransition.SlideTransition) {
        Navigator.of(context).pushReplacement(_tweenAnimationPageRoute());
      } else {
        Navigator.of(context).pushReplacement(_normalPageRoute());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.linearGradient,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FadeTransition(
          opacity: _animation,
          child: Stack(
            children: <Widget>[
              (widget.imageSrc != null &&
                      widget.imageSrc!.isNotEmpty &&
                      !_isLottie)
                  ? (_isNetworkImage)
                      ? Align(
                          alignment: Alignment.center,
                          child: Image.network(
                            widget.imageSrc!,
                            height: widget.logoSize,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            widget.imageSrc!,
                            height: widget.logoSize,
                            fit: BoxFit.cover,
                          ),
                        )
                  : const SizedBox(),
              (widget.imageSrc != null &&
                      widget.imageSrc!.isNotEmpty &&
                      _isLottie)
                  ? (_isNetworkImage)
                      ? Align(
                          alignment: Alignment.center,
                          child: Lottie.network(
                            widget.imageSrc!,
                            height: widget.logoSize,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            widget.imageSrc!,
                            height: widget.logoSize,
                            fit: BoxFit.cover,
                          ),
                        )
                  : const SizedBox(),
              widget.text != null
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: widget.logoSize + 40),
                        child: Padding(
                          padding: widget.paddingText,
                          child: SizedBox(height: 100, child: getTextWidget()),
                        ),
                      ),
                    )
                  : const SizedBox(),
              widget.displayLoading
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: widget.paddingLoading,
                        child: const CircularProgressIndicator(),
                      ))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextWidget() {
  return AnimatedTextKit(
    animatedTexts: [widget.text!],
  );
}

  Route _tweenAnimationPageRoute() {
    /// Tween Animation
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route _normalPageRoute() {
    /// Normal Animation
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}

enum PageRouteTransition {
  Normal,
  CupertinoPageRoute,
  SlideTransition,
}

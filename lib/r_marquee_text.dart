library r_marquee_text;

import 'dart:math' as math;
import 'package:flutter/material.dart';

enum RMarqueeTextDirection {
  right,
  left,
  top,
  bottom,
}

class RMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final RMarqueeTextDirection direction;
  final TextDirection textDirection;
  final Duration duration;
  final Size size;
  const RMarqueeText(
      {Key key,
      this.text,
      this.textStyle,
      this.direction: RMarqueeTextDirection.right,
      this.textDirection: TextDirection.ltr,
      this.duration: const Duration(seconds: 10),
      this.size : const Size(350, 120)})
      : super(key: key);

  @override
  _RMarqueeTextState createState() => _RMarqueeTextState();
}

class _RMarqueeTextState extends State<RMarqueeText>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animatable<double> stopAnim;
  Animatable<double> moveAnim;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    stopAnim = CurveTween(curve: Interval(0, 0.4)).chain(CurveTween(
      curve: const SawTooth(5),
    ));
    moveAnim = CurveTween(curve: Interval(0.4, 1.0)).chain(CurveTween(
      curve: const SawTooth(5),
    ));

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: _buildAnimationWidget,
      ),
    );
  }

  Widget _buildAnimationWidget(BuildContext context, Widget child) {
    return CustomPaint(
      painter: RMarqueeTextPainter(
        marqueeTextDirection: widget.direction,
        progress: moveAnim.evaluate(_controller),
        text: widget.text,
        textStyle: widget.textStyle ?? Theme.of(context).textTheme.headline3,
      ),
      size: widget.size,
    );
  }
}

class RMarqueeTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final double progress;
  final double space;
  final RMarqueeTextDirection marqueeTextDirection;

  RMarqueeTextPainter(
      {this.text,
      this.textStyle,
      this.progress,
      this.space: 60,
      this.marqueeTextDirection: RMarqueeTextDirection.left});

  TextPainter _textPainter;

//  TextPainter _textPainter2;
  Paint _painter;

  void initPainter() {
    _textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
    );
    _textPainter.textDirection = TextDirection.ltr;

//    _textPainter2 = TextPainter(
//      text: TextSpan(
//        text: text,
//        style: textStyle.copyWith(
//          color: Colors.red,
//        ),
//      ),
//    );
//    _textPainter2.textDirection = TextDirection.ltr;

    _painter = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_textPainter == null) initPainter();

    _textPainter.layout();
//    _textPainter2.layout();
    double textWidth = _textPainter.width;
    double textHeight = _textPainter.height;
    double offsetTop = (size.height - textHeight) / 2;

    if (marqueeTextDirection == RMarqueeTextDirection.left) {
      //当前字超过当前宽度
      double moveWidth = math.max(textWidth, size.width) - space + size.width;
      double firstMoveSize = progress * moveWidth;
      _textPainter.paint(canvas, Offset(-firstMoveSize, offsetTop));
//    print(
//        'textWidth:$width , moveSIze:$firstMoveSize , parentWidth:${size.width} , parentHeight:${size.height}');
      //可以看见空白了
      if (firstMoveSize >= math.max(textWidth, size.width) - space) {
        double offset = moveWidth - firstMoveSize;
        _textPainter.paint(canvas, Offset(offset, offsetTop));
      }
    } else if (marqueeTextDirection == RMarqueeTextDirection.right) {
      double moveWidth = math.max(textWidth, size.width);
      double firstMoveSize = progress * moveWidth;
      _textPainter.paint(canvas, Offset(firstMoveSize, offsetTop));

      if (firstMoveSize >= moveWidth - textWidth) {
        //剩余的路程
        double offset = firstMoveSize - (size.width - textWidth);
        _textPainter.paint(canvas, Offset(-textWidth + offset, offsetTop));
      }
    } else if (marqueeTextDirection == RMarqueeTextDirection.top) {
      double moveHeight = offsetTop + textHeight;
      double firstMoveSize = progress * moveHeight;
      _textPainter.paint(canvas, Offset(0, offsetTop - firstMoveSize));

      _textPainter.paint(
          canvas, Offset(0, offsetTop * 2 + textHeight - firstMoveSize));
    } else if (marqueeTextDirection == RMarqueeTextDirection.bottom) {
      double moveHeight = offsetTop + textHeight;
      double firstMoveSize = progress * moveHeight;
      _textPainter.paint(canvas, Offset(0, offsetTop + firstMoveSize));

      _textPainter.paint(canvas, Offset(0, -textHeight + firstMoveSize));
    }
    // 0 - 1
    Path path = Path();
    double borderSpace = 5;
    double moveSpace = 0;
    int widthCount = size.width ~/ borderSpace;
    for (int i = 0; i <= widthCount; i++) {
      if (i % 2 != 0) {
        path.moveTo(moveSpace + i * (borderSpace), 0);
        path.lineTo(moveSpace + (i + 1) * (borderSpace), 0);
      } else {
        path.moveTo(i * (borderSpace + moveSpace), size.height);
        path.lineTo((i + 1) * (borderSpace + moveSpace), size.height);
      }
    }

    path.moveTo(0, 0);
    int heightCount = size.height ~/ borderSpace;
    for (int i = 0; i < heightCount; i++) {
      if (i % 2 != 0) {
        path.moveTo(0, i * borderSpace);
        path.lineTo(0, (i + 1) * borderSpace);
      } else {
        path.moveTo(size.width, i * borderSpace);
        path.lineTo(size.width, (i + 1) * borderSpace);
      }
    }
    canvas.drawPath(path, _painter);
//    canvas.clipPath(path);
//    canvas.drawRect(Offset.zero & size, _painter);
  }

  @override
  bool shouldRepaint(RMarqueeTextPainter oldDelegate) =>
      oldDelegate.text != text ||
      oldDelegate.textStyle != textStyle ||
      oldDelegate.progress != progress ||
      oldDelegate.marqueeTextDirection != marqueeTextDirection;
}

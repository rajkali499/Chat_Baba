import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlassMorphicFlexContainer extends StatelessWidget {
  /// Creates a widget with GlassMorphic Trend that combines [CustomPainter] class,[BackdropFilter], [Expanded], and [Flex].
  ///
  ///
  /// The [color] and [decoration] arguments cannot be supplied, since
  /// in glassMorphic container designs [BoxDecoration] is already being configured to you
  /// You can easily customize [borderGradient] and [linearGradient] like:
  ///! [Note] If you want to create a container with fixed size or dimensions like `height` , 'width','Size',
  ///! please user use [GlassMorphismContainer]
  ///* [GlassMorphicFlexContainer] is only of UIs where you need flexibility and responsiveness
  /// ```dart
  /// GlassMorphicFlexContainer(
  ///   flex:2
  ///   borderRadius: 20,
  ///   blur: 3,
  ///   alignment: Alignment.bottomCenter,
  ///   border: 2,
  ///   linearGradient: LinearGradient(
  ///     begin: Alignment.topLeft,
  ///     end: Alignment.bottomRight,
  ///     colors: [
  ///         Color(0xFFffffff).withOpacity(0.5),
  ///         Colors.red.withOpacity(0.2),
  ///       ],
  ///     stops: [
  ///       0.1,
  ///       1,
  ///     ]),
  ///   borderGradient: LinearGradient(
  ///     begin: Alignment.topLeft,
  ///     end: Alignment.bottomRight,
  ///     colors: [
  ///         Color(0xFFffffff).withOpacity(0.5),
  ///         Colors.red.withOpacity(0.5),
  ///       ],
  ///     ),
  ///   child: SizedBox()
  /// ),
  /// ```

  /// Align the [child] within the container.
  ///
  /// If non-null, the container will expand to fill its parent and position its
  /// child within itself according to the given value. If the incoming
  /// constraints are unbounded, then the child will be shrink-wrapped instead.
  ///
  /// Ignored if [child] is null.
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry? alignment;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final int? flex;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  /// it is similar to all the containers
  final Matrix4? transform;

  /// The [child] contained by the container.
  ///
  /// If null, and if the [constraints] are unbounded or also null, the
  /// container will expand to fill all available space in its parent, unless
  /// the parent provides unbounded constraints, in which case the container
  /// will attempt to be as small as possible.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child
  final Widget? child;

  /// All the bellow parameters are used to design the GlassMorphic effects and this effect is used to
  /// improve the performance ans scalability as per the requirement.
  final double borderRadius;
  final BoxShape shape;
  final BoxConstraints? constraints;
  final double border;
  final double blur;
  final LinearGradient linearGradient;
  final LinearGradient borderGradient;

  GlassMorphicFlexContainer(
      {super.key,
      this.child,
      this.alignment,
      this.padding,
      this.shape = BoxShape.rectangle,
      this.margin,
      this.transform,
      required this.borderRadius,
      required this.linearGradient,
      required this.border,
      required this.blur,
      required this.borderGradient,
      this.constraints,
      this.flex = 1})
      : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(
          flex! >= 1,
          'Flex value can be less than 1 : $flex. Please Provide a flex value > 1',
        ),
        assert(constraints == null || constraints.debugAssertIsValid());

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        showName: false, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin,
        defaultValue: null));
    properties.add(ObjectFlagProperty<Matrix4>.has('transform', transform));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex!,
      child: Container(
        key: key,
        alignment: alignment,
        padding: padding,
        constraints: const BoxConstraints.tightForFinite(),
        transform: transform,
        child: Stack(
          children: [
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur * 2),
                child: Container(
                  alignment: alignment ?? Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: linearGradient,
                  ),
                ),
              ),
            ),
            GlassMorphicBorder(
              strokeWidth: border,
              radius: borderRadius,
              gradient: borderGradient,
            ),
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlassMorphicContainer extends StatelessWidget {
  /// Creates a widget with GlassMorphic Trend that combines [CustomPainter] class, [ClipRect],[BackdropFilter], and [BlurFilter].
  ///
  ///
  /// The [color] and [decoration] arguments cannot be supplied, since
  /// in glassMorphic container designs [BoxDecoration] is already being configured to you
  /// You can easily customize [borderGradient] and [linearGradient] like:
  ///! [Note] If you want to create a container with Dynamic dimensions like `height` , 'width','Size',
  ///! please user use [GlassMorphismFlexContainer]
  ///* [GlassMorphicContainer] is only of UIs where you don't use flexibility and responsiveness

  /// ```dart
  /// GlassMorphicContainer(
  /// width: 250,
  /// height: 250,
  ///  borderRadius: 20,
  ///  blur: 3,
  ///  alignment: Alignment.bottomCenter,
  ///  border: 2,
  ///  linearGradient: LinearGradient(
  ///  begin: Alignment.topLeft,
  ///      end: Alignment.bottomRight,
  ///      colors: [
  ///        Color(0xFFffffff).withOpacity(0.5),
  ///        Colors.red.withOpacity(0.2),
  ///      ],
  ///      stops: [
  ///        0.1,
  ///        1,
  ///      ]),
  ///  borderGradient: LinearGradient(
  ///    begin: Alignment.topLeft,
  ///    end: Alignment.bottomRight,
  ///    colors: [
  ///      Color(0xFFffffff).withOpacity(0.5),
  ///      Colors.red.withOpacity(0.5),
  ///    ],
  ///  ),
  ///  child: null
  /// ),
  /// ```


  /// Align the [child] within the container.
  ///
  /// If non-null, the container will expand to fill its parent and position its
  /// child within itself according to the given value. If the incoming
  /// constraints are unbounded, then the child will be shrink-wrapped instead.
  ///
  /// Ignored if [child] is null.
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry? alignment;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final double? width;
  final double? height;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  /// it is similar to all the containers
  final Matrix4? transform;

  /// The [child] contained by the container.
  ///
  /// If null, and if the [constraints] are unbounded or also null, the
  /// container will expand to fill all available space in its parent, unless
  /// the parent provides unbounded constraints, in which case the container
  /// will attempt to be as small as possible.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child
  final Widget? child;

  /// All the bellow parameters are used to design the GlassMorphic effects and this effect is used to
  /// improve the performance ans scalability as per the requirement.
  final double borderRadius;
  final BoxShape shape;
  final BoxConstraints? constraints;

  final double border;
  final double blur;
  final LinearGradient? linearGradient;
  final LinearGradient? borderGradient;
  final Color color;
  final bool needIntrinsicHeight;
  final bool needIntrinsicWidth;

  GlassMorphicContainer(
      {super.key,
      this.child,
      this.alignment,
      this.padding,
      this.shape = BoxShape.rectangle,
      BoxConstraints? constraints,
      this.margin,
      this.transform,
      this.width,
      this.height,
      required this.borderRadius,
      this.linearGradient,
      required this.color,
      required this.border,
      required this.blur,
      this.borderGradient,
      this.needIntrinsicHeight = true,
      this.needIntrinsicWidth = false})
      : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(constraints == null || constraints.debugAssertIsValid()),
        constraints = constraints?.tighten(width: width, height: height) ??
            BoxConstraints.tightFor(width: width, height: height);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        showName: false, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin,
        defaultValue: null));
    properties.add(ObjectFlagProperty<Matrix4>.has('transform', transform));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: width,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      height: height,
      transform: transform,
      child: needIntrinsicHeight == false
          ? Stack(
              children: [
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: BackdropFilter(
                    filter:
                        ImageFilter.blur(sigmaX: blur * 2, sigmaY: blur * 2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        // gradient: linearGradient,
                        color: color,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    child: child,
                  ),
                ),
              ],
            )
          : needIntrinsicHeight && needIntrinsicWidth
              ? IntrinsicWidth(
                  child: IntrinsicHeight(
                      child: Stack(
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: blur * 2, sigmaY: blur * 2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadius),
                              // gradient: linearGradient,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Container(
                          child: child,
                        ),
                      ),
                    ],
                  )),
                )
              : IntrinsicHeight(
                  child: Stack(
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: blur * 2, sigmaY: blur * 2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadius),
                              // gradient: linearGradient,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Container(
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

/// This class is responsible for creating a [gradient Border] around
/// the GlassMorphic Container.
/// You must have to change your [flutter channel] to Dev version if
/// your want to play with it on the web. currently flutter doesn't
/// support custom painter in
///                [Flutter web]                       [Flutter Apps]
///   [master] -- [  Supported   ✔ ]        :        [  Supported   ✔ ]
///    [dev]   -- [  Supported   ✔ ]        :        [  Supported   ✔ ]
///   [beta]   -- [  Supported   ✔ ]        :        [  Supported   ✔ ]
///  [stable]  -- [  Supported   ✔ ]        :        [  Supported   ✔ ]

class GlassMorphicBorder extends StatelessWidget {
  final _GradientPainter _painter;
  final double _radius;
  final double? width;
  final double? height;

  GlassMorphicBorder({
    super.key,
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    this.height,
    this.width,
  })  : _painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        _radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      size: MediaQuery.of(context).size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
        ),
        width: width,
        height: height,
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required this.strokeWidth,
      required this.radius,
      required this.gradient});
  final Paint paintObject = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    RRect innerRect2 = RRect.fromRectAndRadius(
        Rect.fromLTRB(strokeWidth, strokeWidth, size.width - (strokeWidth),
            size.height - (strokeWidth)),
        Radius.circular(radius - strokeWidth));

    RRect outerRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height), Radius.circular(radius));
    paintObject.shader = gradient.createShader(Offset.zero & size);

    Path outerRectPath = Path()..addRRect(outerRect);
    Path innerRectPath2 = Path()..addRRect(innerRect2);
    canvas.drawPath(
        Path.combine(PathOperation.difference, outerRectPath, innerRectPath2),
        paintObject);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

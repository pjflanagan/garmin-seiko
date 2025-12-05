import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import WatchFaceHelpers;

class WatchFaceBackground extends WatchUi.Drawable {
  private var _backgroundColor as Number;
  private var _shadowColor as Number;
  private var _handColor as Number;
  private var _logoColor as Number;
  private var _radius as Number;

  public function initialize(
    params as
      {
        :identifier as Object,
        :backgroundColor as Number,
        :shadowColor as Number,
        :handColor as Number,
        :logoColor as Number,
        :radius as Number,
      }
  ) {
    _backgroundColor = params[:backgroundColor];
    _shadowColor = params[:shadowColor];
    _handColor = params[:handColor];
    _logoColor = params[:logoColor];
    _radius = params[:radius];

    Drawable.initialize({
      :identifier => params[:identifier],
    });
  }

  private function drawTickMarks(dc as Graphics.Dc) {
    dc.setColor(_logoColor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(8);
    for (var markAngle = 0; markAngle < 360; markAngle += 6) {
      dc.drawArc(
        _radius,
        _radius,
        _radius - 10,
        Graphics.ARC_CLOCKWISE,
        markAngle + 1,
        markAngle - 1
      );
    }
    dc.setPenWidth(12);
    for (var markAngle = 0; markAngle < 360; markAngle += 30) {
      dc.drawArc(
        _radius,
        _radius,
        _radius - 10,
        Graphics.ARC_CLOCKWISE,
        markAngle + 2,
        markAngle - 2
      );
    }
  }

  private function drawHourHand(
    dc as Graphics.Dc,
    clockTime as System.ClockTime
  ) {
    var hour = clockTime.hour;
    var minutes = clockTime.min;
    var hourAngle = ((hour % 12).toFloat() + minutes.toFloat() / 60.0) * 30.0; // 360 / 12 = 30

    // hour hand
    var hourHandPoints = WatchFaceHelpers.getHandPoints(
      dc,
      _radius,
      0.1,
      hourAngle,
      [
        [0.044, -0.05],
        [0.067, -0.6],
        [0.024, -0.7],
        [0.0, -0.84],
        [-0.024, -0.7],
        [-0.067, -0.6],
        [-0.044, -0.05],
      ]
    );
    var hourHandDecorationPoints = WatchFaceHelpers.getHandPoints(
      dc,
      _radius,
      -0.48,
      hourAngle,
      [
        [0.028, 0.0],
        [0.0, -0.076],
        [-0.028, 0.0],
      ]
    );
    dc.setColor(_handColor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(hourHandPoints);
    dc.setColor(_shadowColor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(1);
    WatchFaceHelpers.drawPolygon(dc, hourHandPoints);
    dc.setColor(_backgroundColor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(hourHandDecorationPoints);
  }

  private function drawMinuteHand(
    dc as Graphics.Dc,
    clockTime as System.ClockTime
  ) {
    var minutes = clockTime.min;
    var seconds = clockTime.sec;
    var minuteAngle = (minutes.toFloat() + seconds.toFloat() / 60.0) * 6.0; // 360 / 60 = 6

    var minuteHandPoints = WatchFaceHelpers.getHandPoints(
      dc,
      _radius,
      0.2,
      minuteAngle,
      [
        [0.08, -0.06],
        [0.038, -0.8],
        [0.12, -0.8],
        [0.028, -0.96],
        [0.0, -1.14],
        [-0.028, -0.96],
        [-0.12, -0.8],
        [-0.038, -0.8],
        [-0.08, -0.06],
      ]
    );
    var minuteHandDecorationPoints = WatchFaceHelpers.getHandPoints(
      dc,
      _radius,
      -0.64,
      minuteAngle,
      [
        [0.052, 0.0],
        [0.0, -0.08],
        [-0.052, 0.0],
      ]
    );
    dc.setColor(_handColor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(minuteHandPoints);
    dc.setColor(_shadowColor, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(1);
    WatchFaceHelpers.drawPolygon(dc, minuteHandPoints);
    dc.setColor(_logoColor, Graphics.COLOR_TRANSPARENT);
    dc.setColor(_backgroundColor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(minuteHandDecorationPoints);
  }

  private function drawSecondHand(
    dc as Graphics.Dc,
    clockTime as System.ClockTime
  ) {
    var seconds = clockTime.sec;
    var secondAngle = seconds.toFloat() * 6; // 360 / 60 = 6

    var offsetY = 0.34;
    var secondHandPoints = WatchFaceHelpers.getHandPoints(
      dc,
      _radius,
      offsetY,
      secondAngle,
      [
        [0.02, 0.0],
        [0.0, -1.14],
        [-0.02, 0.0],
      ]
    );
    var counterWeightCirclePoint = WatchFaceHelpers.rotatePoint(
      _radius,
      _radius,
      secondAngle,
      _radius,
      offsetY * _radius + _radius
    );
    // var counterWeightCircleRadius =

    // outline
    dc.setPenWidth(3);
    dc.setColor(_shadowColor, Graphics.COLOR_TRANSPARENT);
    WatchFaceHelpers.drawPolygon(dc, secondHandPoints); // hand
    dc.drawCircle(
      counterWeightCirclePoint[0],
      counterWeightCirclePoint[1],
      0.058 * _radius
    ); // counterweight circle
    dc.drawCircle(_radius, _radius, 0.058 * _radius); // center circle

    // fill
    dc.setColor(_handColor, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(secondHandPoints); // hand
    dc.fillCircle(
      counterWeightCirclePoint[0],
      counterWeightCirclePoint[1],
      0.058 * _radius
    ); // counterweight circle
    dc.fillCircle(_radius, _radius, 0.058 * _radius); // center circle

    // decoration
    dc.setColor(_backgroundColor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(_radius, _radius, 0.018 * _radius); // center circle
    dc.fillCircle(
      counterWeightCirclePoint[0],
      counterWeightCirclePoint[1],
      0.028 * _radius
    ); // counterweight circle
  }

  public function draw(dc) {
    // set the background color then call to clear the screen
    dc.setColor(Graphics.COLOR_TRANSPARENT, _backgroundColor);
    dc.clear();

    drawTickMarks(dc);

    // draw each hand
    var clockTime = System.getClockTime();
    drawHourHand(dc, clockTime);
    drawMinuteHand(dc, clockTime);
    drawSecondHand(dc, clockTime);
  }
}

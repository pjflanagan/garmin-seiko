
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Math;
import Toybox.System;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.Application.Properties;

module WatchFaceHelpers {

  // ------------------------------------------------------------------
  // Math
  // ------------------------------------------------------------------

  function min(a as Number or Float, b as Number or Float) as Number or Float {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }

  function abs(a as Number or Float) as Number or Float {
    if (a < 0) {
      return -a;
    } else {
      return a;
    }
  }

  // normalizes degrees to the range [0, 360)
  // but only if it is within 360 degrees of that range
  function normalizeDegrees(degrees as Number) as Number {
    if (degrees < 0) {
      return degrees + 360;
    } else if (degrees >= 360) {
      return degrees - 360;
    }
    return degrees;
  }


  // ------------------------------------------------------------------
  // Sizing
  // ------------------------------------------------------------------

  function getChordLength(
    radius as Number,
    distanceFromCenter as Number
  ) as Float {
    // chord length = 2 * sqrt(r^2 - d^2)
    return (
      2 * Math.sqrt(radius * radius - distanceFromCenter * distanceFromCenter)
    );
  }

  function getAvailableWidth(radius as Number, yOffset as Number) as Number {
    var chordLength = getChordLength(radius, abs(yOffset)).toNumber();

    // -12 on each side for the hour radius
    return chordLength - 24;
  }

  // ------------------------------------------------------------------
  // Draw
  // ------------------------------------------------------------------


  // x and y are the base coordinates, all other coordinates are relative to this
  function drawPolygon(
    dc as Graphics.Dc,
    points as Array<Graphics.Point2D>
  ) as Void {
    var lastPoint = points[points.size() - 1];
    for (var i = 0; i < points.size(); i++) {
      var x = points[i][0];
      var y = points[i][1];
      dc.drawLine(lastPoint[0], lastPoint[1], x, y);
      lastPoint = [x, y];
    }
    // close the polygon
    // dc.drawLine(lastPoint[0], lastPoint[1], x, y);
  }

  function rotatePoint(
    centerX as Float or Number,
    centerY as Float or Number,
    angleDegrees as Float or Number,
    x as Float or Number,
    y as Float or Number
  ) as Array<Float> {
    var angleRad = Math.toRadians(angleDegrees);
    var cosAngle = Math.cos(angleRad);
    var sinAngle = Math.sin(angleRad);

    // translate point back to origin
    var originX = x - centerX;
    var originY = y - centerY;

    // rotate point
    var newDeltaX = originX * cosAngle - originY * sinAngle;
    var newDeltaY = originX * sinAngle + originY * cosAngle;

  // translate point back:
    var rotatedX = newDeltaX + centerX;
    var rotatedY = newDeltaY + centerY;

    return [rotatedX, rotatedY];
  }

  function getHandPoints(
    dc as Graphics.Dc,
    radius as Number,
    // offset percent Y
    offset as Float,
    angle as Float,
    // percent of radius deltas drawn from the center upward
    pointDeltas as Array<Array<Float> >
  ) as Array<Graphics.Point2D> {
    var points = new [pointDeltas.size() + 1];
    var offsetY = offset * radius;
    var dx;
    var dy;

    // build the polygon
    for (var i = 0; i < pointDeltas.size(); i++) {
      dx = pointDeltas[i][0] * radius;
      dy = pointDeltas[i][1] * radius + offsetY;
      points[i] = [radius + dx, radius + dy];
    }
    // close the polygon
    points[pointDeltas.size()] = [radius, radius + offsetY];

    
    for (var i = 0; i < points.size(); i++) {
      var rotatedPoint = rotatePoint(
        radius.toFloat(),
        radius.toFloat(),
        angle.toFloat(),
        points[i][0].toFloat(),
        points[i][1].toFloat()
      );
      
      points[i][0] = rotatedPoint[0];
      points[i][1] = rotatedPoint[1];
    }

    return points;
  }
}

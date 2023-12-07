using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;

using Colors;

class BigTimeView extends WatchUi.WatchFace {
  const WHITE = Colors.valsToRGB(255, 255, 255);
  const BLACK = Colors.valsToRGB(0, 0, 0);

  const BLUE = Colors.valsToRGB(0, 0, 255);
  const LIGHTSKYBLUE = Colors.valsToRGB(174, 218, 230);

  const DARKGREEN = Colors.valsToRGB(0, 100, 0);
  const LIGHTGREEN = Colors.valsToRGB(144, 238, 144);

  const DARKYELLOW = Colors.valsToRGB(255, 215, 0);
  const LEMONCHIFFON = Colors.valsToRGB(255, 250, 205);

  const RED = Colors.valsToRGB(255, 0, 0);
  const PINK = Colors.valsToRGB(255, 192, 203);

  const DARKVIOLET = Colors.valsToRGB(148, 0, 211);
  const PLUM = Colors.valsToRGB(221, 160, 221);

  const SADDLEBROWN = Colors.valsToRGB(139, 69, 19);
  const SANDYBROWN = Colors.valsToRGB(244, 164, 96);

  const DEEPPINK = Colors.valsToRGB(255, 20, 147);
  const LAWNGREEN = Colors.valsToRGB(124, 252, 0);

  const grad = 60;

  var ix = 0;
  var x; // center of the screen
  var y; // center of the screen

  var colorList as Array<Number> = [
    WHITE,
    BLACK,
    BLUE,
    LIGHTSKYBLUE,
    DARKGREEN,
    LIGHTGREEN,
    DARKYELLOW,
    LEMONCHIFFON,
    RED,
    PINK,
    DARKVIOLET,
    PLUM,
    SADDLEBROWN,
    SANDYBROWN,
    DEEPPINK,
    LAWNGREEN,
  ];
  var gradient;
  var previousColorScheme = -1; // ensure this is not valid for the first time

  function initialize() {
    WatchUi.WatchFace.initialize();
  }

  function onLayout(dc) {
    x = dc.getWidth() / 2;
    y = dc.getHeight() / 2;
  }

  //! Called when this View is brought to the foreground. Restore
  //! the state of this View and prepare it to be shown. This includes
  //! loading resources into memory.
  function onShow() {}

  //! Update the view
  function onUpdate(dc) {
    // this represents the color scheme.
    var military = Application.getApp().getProperty("UseMilitaryFormat")
      ? 1
      : 0;

    var colorScheme =
      (military << 24) +
      (Application.getApp().getProperty("TextColor") << 16) +
      (Application.getApp().getProperty("CenterColor") << 8) +
      Application.getApp().getProperty("EdgeColor");

    var textColor =
      colorList[Application.getApp().getProperty("TextColor")].toNumber();

    //create gradient, if needed:
    if (colorScheme != previousColorScheme) {
      gradient = new Colors.Gradient(
        colorList[Application.getApp().getProperty("EdgeColor")],
        colorList[Application.getApp().getProperty("CenterColor")],
        grad
      );
      previousColorScheme = colorScheme;
    }

    dc.clear();
    // here, the 4th parameter is the radius.
    Colors.drawCurvedGradientRA(dc, x, y, x, gradient);
    dc.setColor(textColor, Gfx.COLOR_TRANSPARENT);

    var myTime = Sys.getClockTime();
    var colon = myTime.sec % 2 ? ":" : " ";

    var displayTime;
    if (Application.getApp().getProperty("UseMilitaryFormat")) {
      displayTime =
        myTime.hour.format("%02d") + colon + myTime.min.format("%02d");
      dc.drawText(
        x,
        y - dc.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT) / 2,
        Gfx.FONT_NUMBER_THAI_HOT,
        displayTime,
        Gfx.TEXT_JUSTIFY_CENTER
      );
    } else {
      var ampm = "AM";
      var hh = myTime.hour;

      if (hh > 12) {
        hh = myTime.hour - 12;
        ampm = "PM";
      }
      displayTime = hh.format("%d") + colon + myTime.min.format("%02d");
      dc.drawText(
        x,
        y - dc.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT) / 2,
        Gfx.FONT_NUMBER_THAI_HOT,
        displayTime,
        Gfx.TEXT_JUSTIFY_CENTER
      );
      dc.drawText(
        x,
        y + dc.getFontHeight(Gfx.FONT_SYSTEM_LARGE),
        Gfx.FONT_SYSTEM_LARGE,
        ampm,
        Gfx.TEXT_JUSTIFY_CENTER
      );
    }

    var batteryText = Sys.getSystemStats().battery.format("%3d");
    dc.drawText(
      x,
      y - dc.getFontHeight(Gfx.FONT_SYSTEM_LARGE) * 2,
      Gfx.FONT_SYSTEM_LARGE,
      batteryText + "%",
      Gfx.TEXT_JUSTIFY_CENTER
    );
  }

  //! Called when this View is removed from the screen. Save the
  //! state of this View here. This includes freeing resources from
  //! memory.
  function onHide() {}

  //! The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {}

  //! Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {}
}

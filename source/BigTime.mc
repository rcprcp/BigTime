import Toybox.Application;
import Toybox.WatchUi;

class BigTime extends Application.AppBase {
  var mview;

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state) {}

  // onStop() is called when your application is exiting
  function onStop(state) {}

  // Return the initial view of your application here
  function getInitialView() as Array<Views or InputDelegates>? {
    return [new BigTimeView()] as Array<Views or InputDelegates>?;
  }

  // New app settings have been received so trigger a UI update
  function onSettingsChanged() {
    WatchUi.requestUpdate();
  }
}

function getApp() as BigTime {
  return Application.getApp() as BigTime;
}

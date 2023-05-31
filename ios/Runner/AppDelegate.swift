import UIKit
import Flutter
import GoogleMaps
/*import FirebaseCore
// import Mobilisten*/

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCK7jH4DKtCSJ4KGTdGnFLqkMBO0Zqq2dM")
     if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
    //FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
/*    ZohoSalesIQ.initWithAppKey("2ctxtwrakW6nQsrTOYUThulpTdgApl1mbjYEe4VzqjMp%2Fi8X7P%2Bj6XWMMyMCcAHZKm4N74Q7pi0%3D_in",
//     accessKey:"XLg6fR%2BNMZnxx16rZ8z0UXIZYPjOlvSJ%2FLpKgpvm1%2FILDQJPNDGMXNxAiwg2T2cK5uXsNdcqUtt%2Btwqn3VRmJknsOpeavWrAYVcO3PbdpCP4wHVjInXbKZNGgPvndB4EswD0r9dD2VIFJN4RDHFkDlr%2BTn2jiY24")
//     { (completed) in}*/
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

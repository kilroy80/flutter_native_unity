import Flutter
import UIKit
import flutter_unity_widget

public class FlutterNativeUnityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_native_unity", binaryMessenger: registrar.messenger())
    let instance = FlutterNativeUnityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? NSDictionary
    let data = arguments?["data"] as? String ?? ""
    let projectName = arguments?["projectName"] as? String ?? "Runner"
    let className = arguments?["className"] as? String ?? "NativeUnityViewController"

    switch call.method {
        case "unity#vc#create":
            guard let presentingVC = UIApplication.shared.topViewController else {
                print("presentingVC nil")
                return
            }

            if let nextVc = viewControllerFromString(projectName: projectName, viewControllerName: className) as? NativeUnityViewController {
                nextVc.modalPresentationStyle = UIModalPresentationStyle.fullScreen

                weak var delegate: ViewControllerDataDelegate?
                delegate = nextVc
                delegate?.initMessage(message: data)

                presentingVC.present(nextVc, animated: false)
            }
        
//            nextVc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//
//            weak var delegate: ViewControllerDataDelegate?
//            delegate = nextVc
//            delegate?.initMessage(message: data)
//
//            presentingVC.present(nextVc, animated: false)
        
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension UIApplication {
    var topViewController: UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            topViewController = connectedScenes.compactMap {
                return ($0 as? UIWindowScene)?.windows.filter { $0.isKeyWindow  }.first?.rootViewController
            }.first
        } else {
            topViewController = keyWindow?.rootViewController
        }
        if let presented = topViewController?.presentedViewController {
            topViewController = presented
        } else if let navController = topViewController as? UINavigationController {
            topViewController = navController.topViewController
        } else if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
        }
        return topViewController
    }

    class func topNavigationController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {

            if let nav = viewController as? UINavigationController {
                return nav
            }
            if let tab = viewController as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return selected.navigationController
                }
            }
            return viewController?.navigationController
        }
}

extension NSObject {

    func viewControllerFromString(projectName: String, viewControllerName: String) -> UIViewController? {

        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
//            print("CFBundleName - \(appName)")
            if let viewControllerType = NSClassFromString("\(appName).\(viewControllerName)") as? UIViewController.Type {
                return viewControllerType.init()
            } else {
                if let viewController = NSClassFromString("\(projectName).\(viewControllerName)") as? UIViewController.Type {
                    return viewController.init()
                }
            }
        }

        return nil
    }
}

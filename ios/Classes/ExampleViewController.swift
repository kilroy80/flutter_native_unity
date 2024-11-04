import Foundation
import flutter_native_unity
//import flutter_unity_widget

class ExampleViewController : NativeUnityViewController {

    var button: UIButton!

    open override func viewDidLoad() {
        super.viewDidLoad()
        addPlaceHolder()
        addContentsView()
    }

    open override func initMessage(message: String) {
        print(message)
    }

    open override func onUnitySceneLoaded(message: String) {
        print(message)
    }

    open override func onUnityMessage(message: String) {
        print(message)
    }

    func addPlaceHolder() {

        let aImageView = UIImageView(frame: CGRect(x: (windowSize().width - 150) / 2.0, y: (windowSize().height - 150) / 2.0, width: 150, height: 150))
//        aImageView.backgroundColor = .red
//        aImageView.image = UIImage.make(name: "logo")
        aImageView.image = Bundle.main.icon ?? UIImage()
        aImageView.translatesAutoresizingMaskIntoConstraints = false

        placeHolderView.insertSubview(aImageView, at: 1)
    }

    func addContentsView() {
        button = UIButton(frame: CGRect(x: 0, y: statusBarHeight(), width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Exit Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        contentsView.insertSubview(button, at: 0)
    }

    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        closeViewController()
    }

    open override func handleMassage(_ notification: NSNotification) {
        super.handleMassage(notification)
    }
}

extension UIViewController {
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }

    func screenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }

    // Split Screen.
    func windowSize() -> CGSize {
        return self.view.window?.frame.size ?? screenSize()
    }
}

//public extension UIImage {
//  static func make(name: String) -> UIImage? {
//      let bundle = Bundle(for: FlutterNativeUnityPlugin.self)
//      return UIImage(named: "FlutterNativeUnityPlugin.bundle/\(name)", in: bundle, compatibleWith: nil)
//  }
//}

extension Bundle {

  var releaseVersionNumber: String? {
    return infoDictionary?["CFBundleShortVersionString"] as? String
  }

  var buildVersionNumber: String? {
    return infoDictionary?["CFBundleVersion"] as? String
  }

  var icon: UIImage? {

    if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
       let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
       let files = primary["CFBundleIconFiles"] as? [String],
       let icon = files.last
    {
      return UIImage(named: icon)
    }

    return nil
  }
}

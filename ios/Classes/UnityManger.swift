//
//  UnityManger.swift
//  Runner
//
//  Created by bumsung on 10/22/24.
//

import UIKit
import UnityFramework

public protocol UnityManagerDelegate: AnyObject {
    func onUnityManagerMessage(message: String)
}

class UnityManager: NSObject {
    
    let TAG = "UnityManager"
    static let shared = UnityManager()

    private let dataBundleId: String = "com.unity3d.framework"
    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"

    private var ufw: UnityFramework?

    private var hostMainWindow: UIWindow?
    
    public var unityManagerDelegate: UnityManagerDelegate?

    override private init() {}

    // 유니티로 전송할 메시지 struct 정의
    struct UnityMessage {
        let gameObject: String
        let unityMethodName: String
        let unityMessage: String
    }

    func setHostMainWindow(_ hostMainWindow: UIWindow?) {
        self.hostMainWindow = hostMainWindow
    }

    func launchUnity() {
        
        // host main window가 있어야만 유니티가 뒤로 내려감.
        let window = UIApplication.shared.windows.first
        UnityManager.shared.setHostMainWindow(window)
        
        print(TAG, "launchUnity")
        let isInitialized = ufw?.appController() != nil
        if isInitialized {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.rootViewControllerForUniWebView = ufw?.appController().rootViewController

            ufw?.showUnityWindow()
        } else {
            guard let ufw = loadUnityFramework() else { return }
            self.ufw = ufw
            ufw.setDataBundleId(dataBundleId)
            ufw.register(self)
//            NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)
            ufw.runEmbedded(
                withArgc: CommandLine.argc,
                argv: CommandLine.unsafeArgv,
                appLaunchOpts: nil
            )
            
            if ufw.appController() != nil {
                ufw.appController().unityMessageHandler = self.unityMessageHandlers
            }
        }
    }

    @objc
    func unityMessageHandlers(_ message: UnsafePointer<Int8>?) {
        if let strMsg = message {
            let msg = String(utf8String: strMsg) ?? ""
            print("unityMessageHandlers \(msg)")
            
            self.unityManagerDelegate?.onUnityManagerMessage(message: msg)
            
//            notifyFlutter(
//                data: DataStreamEvent(
//                    eventType: DataStreamEventTypes.OnUnityMessage,
//                    data: msg))
        } else {
//            notifyFlutter(
//                data: DataStreamEvent(
//                    eventType: DataStreamEventTypes.OnUnityMessage,
//                    data: ""))
        }
    }

    func closeUnity() {
        print(TAG, "closeUnity")
        unloadUnity()
        hostMainWindow?.makeKeyAndVisible()
    }
  
    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + frameworkPath

        let bundle = Bundle(path: bundlePath)
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
//            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
//            machineHeader.pointee = _mh_execute_header
//
//            ufw?.setExecuteHeader(machineHeader)
            
            let machineHeader = #dsohandle.assumingMemoryBound(to: MachHeader.self)
            ufw!.setExecuteHeader(machineHeader)
        }
        return ufw
    }

    func sendMessageToUnity(_ message: UnityMessage) {
        ufw?.sendMessageToGO(withName: message.gameObject,
                             functionName: message.unityMethodName,
                             message: message.unityMessage)
    }

    func unloadUnity() {
        print(TAG, "unloadUnity")
        ufw?.unloadApplication()
    }
}

extension UnityManager: UnityFrameworkListener {
    func unityDidUnload(_: Notification!) {
        print(TAG, "unityDidUnload")
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
    } // unityDidUnload

    func unityDidQuit(_: Notification!) {
        print(TAG, "unityDidQuit")
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
    } // unityDidQuit
}

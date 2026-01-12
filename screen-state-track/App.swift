import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIGestureRecognizerDelegate {
    var window: UIWindow?
    private var isScreenOn = true
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        self.window = window
        
        registerForScreenOnOffNotification()
    }
    
    func screenStatusChanged() {
        isScreenOn.toggle()
        print(isScreenOn ? "SCREEN ON" : "SCREEN OFF")
    }
    
    private func registerForScreenOnOffNotification() {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        Unmanaged.passUnretained(self).toOpaque(),
                                        screenStatusChangedCallback,
                                        "com.apple.iokit.hid.displayStatus" as CFString,
                                        nil,
                                        .deliverImmediately)
    }
}

private let screenStatusChangedCallback: CFNotificationCallback = { _, cfObserver, _, _, _ in
    guard let observer = cfObserver else { return }
    let sceneDelegate = Unmanaged<SceneDelegate>.fromOpaque(observer).takeUnretainedValue()
    sceneDelegate.screenStatusChanged()
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {}

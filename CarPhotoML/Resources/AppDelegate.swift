import UIKit
import ReSwift

let mainStore = Store<AppState>(
    reducer: carPhotoReducer,
    state: nil
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController: MainViewController = MainViewController()
        let navigationController: UINavigationController = UINavigationController(rootViewController: mainViewController);
        
        self.window!.rootViewController = navigationController;
        
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
}


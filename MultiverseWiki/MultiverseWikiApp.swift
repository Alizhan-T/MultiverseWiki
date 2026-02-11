import SwiftUI
import CoreData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MultiverseWikiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .onAppear {
                        if Auth.auth().currentUser != nil {
                            isLoggedIn = true
                        }
                    }
            }
        }
    }
}

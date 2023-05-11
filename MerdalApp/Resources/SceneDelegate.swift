//
//  SceneDelegate.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        AuthManager.shared.assignUser()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            window?.rootViewController = createWelcomePage()
        } else {
            createMainPage()
        }
    }
    
    func createWelcomePage() -> UINavigationController {
        let vc = WelcomeVC()
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.prefersLargeTitles = true
        nc.navigationItem.largeTitleDisplayMode = .always
        return nc
    }
    
    func createMainPage() {
        let db = Firestore.firestore()
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            return
        }
        
        
        // şu db işlemi en son gerçekleşiyor buna bir çözüm bul
        db.collection("doktor").getDocuments { [weak self] querySnapshot, error in
            guard let self, error == nil else { return }
            let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
            
            if wantedDatas.isEmpty == false {
                AuthManager.shared.userType = .doctor
                
                let nc = UINavigationController(rootViewController: PatientsVC())
                nc.navigationBar.prefersLargeTitles = true
                nc.navigationItem.largeTitleDisplayMode = .always
                self.window?.rootViewController = nc
            } else {
                let nc1 = UINavigationController(rootViewController: TasksVC())
                nc1.navigationBar.prefersLargeTitles = true
                nc1.tabBarItem = UITabBarItem(title: "Görevler", image: UIImage(systemName: "list.bullet.clipboard"), tag: 0)
                
                let nc2 = UINavigationController(rootViewController: ProfileVC())
                nc2.navigationBar.prefersLargeTitles = true
                nc2.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.crop.circle"), tag: 1)
                
                let tbc = UITabBarController()
                tbc.viewControllers = [nc1, nc2]
                self.window?.rootViewController = tbc
            }
        }
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


//
//  TapBarViewController.swift
//  JipJung_Clone_Pulsar
//
//  Created by Hamin Jeong on 2023/03/04.
//

import UIKit

class TapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = HomeViewController()
        let exploreVC = ExploreViewController()
        let meVC = MeViewController()
        
        homeVC.title = "HOME"
        homeVC.tabBarItem.image = UIImage(systemName: "person")
        homeVC.navigationItem.largeTitleDisplayMode = .always
        
        exploreVC.title = "EXPLORE"
        exploreVC.tabBarItem.image = UIImage(systemName: "person.fill")
        exploreVC.navigationItem.largeTitleDisplayMode = .always
        
        meVC.title = "ME"
        meVC.tabBarItem.image = UIImage(systemName: "person.circle")
        meVC.navigationItem.largeTitleDisplayMode = .always
        
        let naviHomeVC = UINavigationController(rootViewController: homeVC)
        let naviExploreVC = UINavigationController(rootViewController: exploreVC)
        let naviMeVC = UINavigationController(rootViewController: meVC)
        
        naviExploreVC.navigationBar.prefersLargeTitles = true
        naviHomeVC.navigationBar.prefersLargeTitles = true
        naviMeVC.navigationBar.prefersLargeTitles = true
        
        setViewControllers([naviHomeVC, naviExploreVC, naviMeVC], animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

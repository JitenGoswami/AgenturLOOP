//
//  UIViewController.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 31/01/23.
//

import UIKit

extension UIViewController{
    
    /// To push viewcontroller
    func pushNavigation(identifierId: String) {
        let objVC = Constant.StoryBoardID.sMain.instantiateViewController(withIdentifier: identifierId)
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    /// To present viewcontroller
    func presentNavigation(identifierId: String, movieModel: MoviesModel?){
        let objVC = Constant.StoryBoardID.sMain.instantiateViewController(withIdentifier: Constant.StoryBoardID.sDetailScreenVC) as! DetailScreenVC
        objVC.movieModel = movieModel
        let navigationController: UINavigationController = UINavigationController(rootViewController: objVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

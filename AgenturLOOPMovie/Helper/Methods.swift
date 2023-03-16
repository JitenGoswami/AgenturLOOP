//
//  Methods.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 26/02/23.
//

import UIKit

struct Methods{
    
    //MARK: - User Default
    static func setUserDefault(objectToSave: Any?, keyName: String) {
        let defaults = UserDefaults.standard
        
        if (objectToSave != nil){
            defaults.set(objectToSave, forKey: keyName)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    static func getUserDefault(keyName : String) -> Any? {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: keyName){
            return name as Any?
        }
        return nil
    }
    
    static func removeUserDefault(keyName : String) {
        let defaults = UserDefaults.standard
        
        if (keyName != "") {
            defaults.removeObject(forKey: keyName)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    static func getBookMarkedArray() -> Array<MoviesModel>?{
        
        let objStored = Methods.getUserDefault(keyName: Constant.UserDefaultKeys.uBookMarked)
        if let objStored = objStored{
            return try! JSONDecoder().decode([MoviesModel].self, from: objStored as! Data)
        }
        return nil
    }
    
    static func setMovieRating(object: Any, movieModel: MoviesModel){
        if let tableViewCell = object as? AllMoviesTVC{
            tableViewCell.imgRatingStar1.tintColor = movieModel.rating > 1 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            tableViewCell.imgRatingStar2.tintColor = movieModel.rating > 2 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            tableViewCell.imgRatingStar3.tintColor = movieModel.rating > 3 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            tableViewCell.imgRatingStar4.tintColor = movieModel.rating > 4 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            tableViewCell.imgRatingStar5.tintColor = movieModel.rating > 5 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
        }
        
        else if let detailScreenVC = object as? DetailScreenVC{
            detailScreenVC.imgRatingStar1.tintColor = movieModel.rating > 1 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            detailScreenVC.imgRatingStar2.tintColor = movieModel.rating > 2 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            detailScreenVC.imgRatingStar3.tintColor = movieModel.rating > 3 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            detailScreenVC.imgRatingStar4.tintColor = movieModel.rating > 4 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
            detailScreenVC.imgRatingStar5.tintColor = movieModel.rating > 5 ? Constant.ColorCodes.yellowStarColor : Constant.ColorCodes.grayStarColor
        }
    }
    
}

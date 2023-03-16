//
//  Constant.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 31/01/23.
//

import UIKit

struct Constant {
    //MARK: - StoryBoard ID
    struct StoryBoardID {
        static let sMain = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        static let sAllMoviesScreenVC = "AllMoviesScreenVC"
        static let sDetailScreenVC = "DetailScreenVC"
        
    }
    
    //MARK: - Navigation Title
    struct NavigationTitle {
        static let ntAllMovies = "All Movies"
    }
    
    //MARK: - Json Urls
    struct JsonUrls {
        
        /// Api urls
        static let wAllMoviesUrl = "https://apps.agentur-loop.com/challenge/movies.json"
        static let wStaffPicksUrl = "https://apps.agentur-loop.com/challenge/staff_picks.json"
        
    }
    
    //MARK: - Json Urls
    struct ColorCodes {
        static let yellowStarColor = UIColor(red: 0.99, green: 0.62, blue: 0.01, alpha: 1.0)
        static let grayStarColor = UIColor(red: 0.08, green: 0.11, blue: 0.15, alpha: 0.1)
    }
    
    //MARK: - UserDefault Keys
    struct UserDefaultKeys {
        static let uBookMarked = "BookMarked"
    }
    
    //MARK: - Image Names
    struct ImageNames {
        static let iBookMark = "bookmark.png"
        
    }
    
    //MARK: - Alert Messages
       struct AlertMessages {
           static let aSomethingWentWrong = "Something went wrong"
       }
}

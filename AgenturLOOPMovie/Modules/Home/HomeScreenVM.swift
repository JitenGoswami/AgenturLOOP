//
//  HomeScreenVM.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 26/02/23.
//

import Foundation

struct HomeScreenVM {
    
    static func homeValue(completion: @escaping (_ success: Bool, _ data: [MoviesModel]?, _ message: String?) -> ()) {
        
        let url = URL(string: Constant.JsonUrls.wStaffPicksUrl)!
        let jsonDecoder = JSONDecoder()
        do{
            let dataUrl = try Data(contentsOf: url)
            let urlDataFromJson = try jsonDecoder.decode([MoviesModel].self, from: dataUrl)
            completion(true, urlDataFromJson, nil)
        }catch {
            completion(false, nil, Constant.AlertMessages.aSomethingWentWrong)
        }
    }
}

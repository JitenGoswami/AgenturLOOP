//
//  AllMoviesScreenVM.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 26/02/23.
//

import Foundation

struct AllMoviesScreenVM {
    
    static func allMoviesValue(completion: @escaping (_ success: Bool, _ data: [MoviesModel]?, _ message: String?) -> ()) {
        
        let url = URL(string: Constant.JsonUrls.wAllMoviesUrl)!
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

//
//  AllMoviesModel.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 30/01/23.
//

import Foundation

struct MoviesModel: Codable{
    
    var id: Int
    var title: String
    var releaseDate: String
    var posterUrl: String?
    var revenue: Int?
    var overview: String
    var budget: Int
    var rating: Float
    var language: String
    var genres: Array<String>
    var runtime: Int
    var reviews: Int
}

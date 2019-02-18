//
//  File.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-18.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

struct Movie: Codable{
    var title: String
    var image: String
    
    enum CodingKeys: String, CodingKey{
        case title
        case image = "poster_path"
        
    }
}

struct arrayOfMovies: Codable{
    var results: [Movie]
}

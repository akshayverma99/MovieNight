//
//  Genre.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

struct Genre: Codable, Equatable {
    var id: Int
    var name: String
    
    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        if lhs.id == rhs.id && lhs.name == rhs.name{
            return true
        }else{
            return false
        }
    }
    
}

struct ArrayOfGenre: Codable{
    var genres: [Genre]
}

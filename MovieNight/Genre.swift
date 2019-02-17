//
//  Genre.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

struct Genre: Codable {
    var id: Int
    var name: String
}

struct ArrayOfGenre: Codable{
    var genres: [Genre]
}

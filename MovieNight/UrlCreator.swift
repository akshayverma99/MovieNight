//
//  UrlCreator.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

class URLCreator{
    
    private static let baseUrl = "https://api.themoviedb.org/3"
    private static let apiKey = "3b411bd061b0f06b06a59da5d2c77d2d"
    private static let genre = "/genre/movie/list"
    private static let apiBridge = "?api_key="
    
    
    /// Returns the URL required to get the various movie genres
    /// Throws an error if the url init fails but it shouldnt
    static func getGenreUrl() throws -> URL{
        if let url = URL(string: "\(URLCreator.baseUrl)\(URLCreator.genre)\(URLCreator.apiBridge)\(URLCreator.apiKey)"){
            return url
        }else{
            throw NetworkingErrors.invalidURL
        }
        
    }
    
}

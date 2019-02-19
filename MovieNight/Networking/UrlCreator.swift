//
//  UrlCreator.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

class URLCreator{
    
    private static let baseImageUrl = "https://image.tmdb.org/t/p/"
    private static let imageSize = "w154"
    private static let baseUrl = "https://api.themoviedb.org/3"
    private static let apiKey = "3b411bd061b0f06b06a59da5d2c77d2d"
    private static let genre = "/genre/movie/list"
    private static let discover = "/discover/movie"
    private static let with = "%7C"
    private static let and = "%2C"
    private static let genreReqInfo = "&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres="
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
    
    /// Returns the URL required to get all the movies matching the selected genres
    /// Throws an error if the url init fails but it shouldnt
    static func getUrlForMutualMovies() throws -> URL{
        
        var placeHolder = "\(baseUrl)\(discover)\(apiBridge)\(apiKey)\(genreReqInfo)"
        
        for index in 0...DataHandler.getListOfMutualGenres().count-1{
            if index == 0{
                placeHolder.append("\(DataHandler.getListOfMutualGenres()[0].id)")
            }else{
                placeHolder.append("\(and)\(DataHandler.getListOfMutualGenres()[index].id)")
            }
        }
        
        if let url = URL(string: placeHolder){
            return url
        }else{
            throw NetworkingErrors.invalidURL
        }
    }
    
    /// Returns the URL required to get a movies poster
    /// Throws an error if the url init fails but it shouldnt
    static func getImageUrl(ending: String) throws -> URL{
        if let url = URL(string: "\(baseImageUrl)\(imageSize)\(ending)"){
            return url
        }else{
            throw NetworkingErrors.invalidURL
        }
    }
    
}

//
//  DataHandler.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

class DataHandler{
    private static var listOfGenres: [Genre]?
    
    static func getListOfGenres()throws -> [Genre]{
        if let array = listOfGenres{
            return array
        }else{
            throw DataErrors.noData
        }
    }
    
    static func updateGenres(with array: [Genre]){
        DataHandler.listOfGenres = array
    }
}

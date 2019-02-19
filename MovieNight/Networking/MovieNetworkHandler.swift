//
//  MovieNetworkHandler.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

enum movieRequest{
    case genre
    case movies
    case movieImage(String)
}

enum responseType{
    case error(Error)
    case data(Data)
}

/// Handles all networking requests
class MovieNetworkHandler{
    
    /// Retrieves the appropriate data for each request
    func getData(for request: movieRequest, completionHandler: @escaping (responseType)->Void){
        
            do{
                var url: URL
                
                switch request{
                case .genre: url = try URLCreator.getGenreUrl()
                case .movies: url = try URLCreator.getUrlForMutualMovies()
                case .movieImage(let urlEnding): url = try URLCreator.getImageUrl(ending: urlEnding)
                }
                
                URLSession.shared.dataTask(with: url){ data, response, error in
                    
                    // Returns the error, if there isnt an error, it returns the data
                    
                    if let error = error{
                        completionHandler(.error(error))
                        return
                    }
                    if let data = data{
                        completionHandler(.data(data))
                        return
                    }   
                }.resume()
            }catch{
                completionHandler(.error(NetworkingErrors.invalidURL))
            }
        
    }
    
}

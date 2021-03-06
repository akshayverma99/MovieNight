//
//  DataHandler.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation

class DataHandler{
    private static var arrayOfMovies: [Movie] = []
    private static var selectedGenres: [Bool]  = []
    private static var listOfGenres: [Genre] = []
    private static var listOfChosenGenres: [Genre] = []
    
    static var buttonPressed: selectedButton = .personOne
    static var currentStage: PhaseOfSelection = .initialSelection
    
    
    // MARK: Array Of Movie Methods
    static func addArrayOfMovies(_ array: [Movie]){
        arrayOfMovies = array
    }
    
    static func getArrayOfMovies() -> [Movie]{
        return arrayOfMovies
    }
    
    // Mark: Bool Array Methods
    
    static func changeBoolValue(at index: Int, to bool: Bool){
        selectedGenres[index] = bool
    }
    
    static func resetSelectedArray(){
        selectedGenres = []
        fillSelectedBoolArray()
    }
    
    static func fillSelectedBoolArray(){
        for _ in listOfGenres{
            selectedGenres.append(false)
        }
    }
    
    static func getSelectedArray() -> [Bool]{
        return selectedGenres
    }
    
    // MARK: Entire list of chosen genres Methods
    
    /// Returns the entire list of genres
    static func getListOfGenres() -> [Genre]{
        return listOfGenres
    }
    
    /// Updates the classes list of all the Genres
    static func updateGenres(with array: [Genre]){
        DataHandler.listOfGenres = array
    }
    
    // MARK: Chosen Genre Methods
    
    /// returns just the chosen Genres
    static func getChosenGenres() -> [Genre]{
        return listOfChosenGenres
    }
    
    /// adds a genre to the list of chosen Genres
    static func addChosenGenre(_ addedGenre: Genre){
        if listOfChosenGenres.count == 0{
            listOfChosenGenres.append(addedGenre)
            print(listOfChosenGenres)
        }
        
        
        // Ensures that no genre is added twice although everything still works
        // even if they are, just saving a very tiny amount of space
        for genre in listOfChosenGenres{
            if genre == addedGenre{
                return
            }
        }
        listOfChosenGenres.append(addedGenre)

    }
    
    static func resetChosenArray(){
        listOfChosenGenres = []
    }
    
    /// Removes a given genre from the list of chosen Genres
    static func removeChosenGenre(_ genre: Genre){
        
        if listOfChosenGenres.count == 1{
            listOfChosenGenres.remove(at: 0)
            return
        }
        
        // Loops through all the genres and removes any that match the name
        for index in 0...listOfChosenGenres.count-1{
  
            if listOfChosenGenres[index].name == genre.name{
                listOfChosenGenres.remove(at: index)
                
                // prevents unneccessary looping + crashing due to the array shrinking
                // due to the removal
                return
            }
        }
    }
    
}

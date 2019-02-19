//
//  GenreTableViewCell.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var GenreLabel: UILabel!
    @IBOutlet weak var GenreSelectButton: UIButton!
    
    var index: Int = 0
    var genre: Genre?
    
    var buttonSelected: Bool = false{
        didSet{
            if self.buttonSelected == false{
                GenreSelectButton.setImage(#imageLiteral(resourceName: "1"), for: .normal)
                DataHandler.changeBoolValue(at: index, to: false)
            }else{
                GenreSelectButton.setImage(#imageLiteral(resourceName: "2"), for: .normal)
                DataHandler.changeBoolValue(at: index, to: true)
            }
        }
    }
    
    
    // Switches the users Button image and assigns the selected genres to an array
    // and removes unselected genres from the array
    @IBAction func GenreButtonPressed(_ sender: UIButton) {
        
        // Going from true to false
        if buttonSelected == true{
            buttonSelected = false
            guard let genre = genre else {return}
            
            if DataHandler.currentStage == .initialSelection{
                DataHandler.removeChosenGenre(genre)
            }else if DataHandler.currentStage == .remainingSelection{
                DataHandler.removeGenreFromMutual(genre)
            }
            
            
            // Going from false to true
        }else{
            buttonSelected = true
            guard let genre = genre else {return}
            
            if DataHandler.currentStage == .initialSelection{
                DataHandler.addChosenGenre(genre)
            }else if DataHandler.currentStage == .remainingSelection{
                DataHandler.addGenreToMutual(genre)
            }
            
            
        }
    }
    
    
    
    
}

//
//  GenreTableViewController.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

enum PhaseOfSelection{
    case initialSelection
    case remainingSelection
    case displayMovies
}

class GenreTableViewController: UITableViewController {
    
    var previousVC: ViewController!
    var phaseOfSelection: PhaseOfSelection = .initialSelection
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataHandler.fillSelectedBoolArray()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch DataHandler.currentStage {
        case .initialSelection: return DataHandler.getListOfGenres().count
        case .remainingSelection: return DataHandler.getChosenGenres().count
        default:
            print("Should not be able to reach, disable buttons")
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as! GenreTableViewCell
        
        switch DataHandler.currentStage {
        case .initialSelection:
            cell.genre = (DataHandler.getListOfGenres())[indexPath.row]
            cell.GenreLabel.text = (DataHandler.getListOfGenres())[indexPath.row].name
            cell.index = indexPath.row
            if (DataHandler.getSelectedArray())[indexPath.row]{
                cell.buttonSelected = true
            }else{
                cell.buttonSelected = false
            }
        case .remainingSelection:
            cell.genre = (DataHandler.getChosenGenres())[indexPath.row]
            cell.GenreLabel.text = (DataHandler.getChosenGenres())[indexPath.row].name
            cell.index = indexPath.row
            if (DataHandler.getSelectedArray())[indexPath.row]{
                cell.buttonSelected = true
            }else{
                cell.buttonSelected = false
            }
            default: print("Should not be able to reach, disable buttons")
        }
        
        return cell
        
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if DataHandler.currentStage == .initialSelection{
            if DataHandler.getChosenGenres().count > 0{
                switch DataHandler.buttonPressed{
                case .personOne:
                    previousVC.PlayerOneButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    previousVC.PlayerOneButton.isEnabled = false
                case .personTwo:
                    previousVC.PlayertwoButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    previousVC.PlayertwoButton.isEnabled = false
                }
                DataHandler.currentStage = .remainingSelection
                DataHandler.resetSelectedArray()
                dismiss(animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "No Genres", message: "Please select at least one genre", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: false, completion: nil)
            }
        }else{
            if DataHandler.getListOfMutualGenres().count > 0{
                switch DataHandler.buttonPressed{
                case .personOne:
                    previousVC.PlayerOneButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    previousVC.PlayerOneButton.isEnabled = false
                case .personTwo:
                    previousVC.PlayertwoButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    previousVC.PlayertwoButton.isEnabled = false
                }
                DataHandler.currentStage = .displayMovies
                previousVC.updateMovies()
                DataHandler.resetSelectedArray()
                dismiss(animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "No Genres", message: "Please select at least one genre", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: false, completion: nil)
                
            }
        }
    }
    



}

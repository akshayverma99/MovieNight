//
//  ViewController.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var PlayerOneButton: UIButton!
    @IBOutlet weak var PlayertwoButton: UIButton!
    @IBOutlet weak var MovieCollectionView: UICollectionView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        retrieveGenreData()
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupViews(){
        viewOne.layer.cornerRadius = 15
        viewTwo.layer.cornerRadius = 15
        PlayerOneButton.layer.cornerRadius = 15
        PlayertwoButton.layer.cornerRadius = 15
    }
    
    func retrieveGenreData(){
        let networkHandler = MovieNetworkHandler()
        networkHandler.getData(for: .genre){ response in
            switch response{
            case .data(let data):
                let decoder = JSONDecoder()
                do{
                    let array = try decoder.decode(ArrayOfGenre.self, from: data)
                    DispatchQueue.main.async {
                        DataHandler.updateGenres(with: array.genres)
                    }
                }catch let error{
                    self.displayError(error: error)
                }
            case .error(let error):
                self.displayError(error: error)
            }
            
        }
    }
    
    
    /// Creates and displays a modal popup for whatever error there is
    func displayError(error: Error){
        if error is NetworkingErrors{
            let alertModal = UIAlertController(title: "Network Error", message: "Please Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertModal.addAction(action)
            self.present(alertModal, animated: false, completion: nil)
        }else{
            let alertModal = UIAlertController(title: "Data Error", message: "\(error)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertModal.addAction(action)
        }
    }
    
    @IBAction func PersonButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
}






























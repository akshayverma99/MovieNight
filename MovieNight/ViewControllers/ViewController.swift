//
//  ViewController.swift
//  MovieNight
//
//  Created by Akshay Verma on 2019-02-17.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit

enum selectedButton{
    case personOne
    case personTwo
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var PlayerOneButton: UIButton!
    @IBOutlet weak var PlayerTwoButton: UIButton!
    @IBOutlet weak var MovieCollectionView: UICollectionView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var blockerView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        retrieveGenreData()
        MovieCollectionView.delegate = self
        MovieCollectionView.dataSource = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Rounds the corners for all the views, makes the UI look 10x better
    func setupViews(){
        viewOne.layer.cornerRadius = 15
        viewTwo.layer.cornerRadius = 15
        PlayerOneButton.layer.cornerRadius = 15
        PlayerTwoButton.layer.cornerRadius = 15
        blockerView.layer.cornerRadius = 15
        MovieCollectionView.layer.cornerRadius = 15
        
        self.PlayerOneButton.isEnabled = false
        self.PlayerTwoButton.isEnabled = false
        self.retryButton.isHidden = true
    }
    
    
    // Retrieves the list of all available genres to choose from
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
                        self.PlayerOneButton.isEnabled = true
                        self.PlayerTwoButton.isEnabled = true
                        self.retryButton.isHidden = true
                    }
                }catch let error{
                    DispatchQueue.main.async{
                        self.displayError(error: error)
                    }
                }
            case .error(let error):
                DispatchQueue.main.async{
                    self.displayError(error: error)
                }
            }
            
        }
    }
    
    
    /// Creates and displays a modal popup for whatever error there is
    /// Also adds the retry button which allows the users to retry the genre request
    func displayError(error: Error){
        if error is NetworkingErrors{
            let alertModal = UIAlertController(title: "URL Error", message: "Please Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertModal.addAction(action)
            self.present(alertModal, animated: false){
                DispatchQueue.main.async{
                    self.retryButton.isHidden = false
                }
            }
        }else{
            let alertModal = UIAlertController(title: "Networking Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertModal.addAction(action)
            self.present(alertModal, animated: false){
                DispatchQueue.main.async{
                    self.retryButton.isHidden = false
                }
            }
        }
    }
    
    /// Displays a modal for when no movies meet the criteria the users input
    /// Also resets the buttons so they are enabled and the correct color again
    func displayNoMovies(){
        let alertModal = UIAlertController(title: "Movie Error", message: "No Movies meet your criteria, please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertModal.addAction(action)
        self.present(alertModal, animated: false){
            DataHandler.currentStage = .initialSelection
            self.PlayerOneButton.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            self.PlayerTwoButton.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            self.PlayerOneButton.isEnabled = true
            self.PlayerTwoButton.isEnabled = true
        }

    }
    
    // The names of the buttons that are pressed
    enum titleText: String{
        case PersonOne
        case PersonTwo
    }
    
    /// Presents and gives the relevant data to the table view
    /// If the genre data has not been loaded, an error modal is
    /// presented and the genre data request is tried again
    @IBAction func PersonButtonPressed(_ sender: UIButton) {
            if DataHandler.getListOfGenres().count >= 0{
                if sender.titleLabel?.text == titleText.PersonOne.rawValue{
                    DataHandler.buttonPressed = .personOne
                }else if sender.titleLabel?.text == titleText.PersonTwo.rawValue{
                    DataHandler.buttonPressed = .personTwo
                }
                performSegue(withIdentifier: "GenreSelect", sender: nil)
            }else{
                let alertModal = UIAlertController(title: "Network Error", message: "Please Try Again", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel){ alertAction in
                    self.retrieveGenreData()
                }
                alertModal.addAction(action)
                self.present(alertModal, animated: false){
                    self.retrieveGenreData()
                }
            }
    
    }
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        self.retrieveGenreData()
    }
    
    
    // passes the tableview controller this View controller so it can call updates and modify buttons
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let NavController = segue.destination as? UINavigationController,let tableVC = NavController.viewControllers.first as? GenreTableViewController{
            tableVC.previousVC = self
            tableVC.phaseOfSelection = DataHandler.currentStage
        }
    }
    
    /// Gets the relevant movies from the movieDB database based on matching criteria
    /// if an error is thrown somewhere, a modal is presented
    /// if no movies match the criteria, the users and prompted to try again and everything is reset
    func updateMovies(){
        let networkHandler = MovieNetworkHandler()
        let jsonDecoder = JSONDecoder()
        
        networkHandler.getData(for: .movies){ response in
            switch response{
            case .data(let data):
                do{
                    DataHandler.addArrayOfMovies(try jsonDecoder.decode(arrayOfMovies.self, from: data).results)
                    
                    DispatchQueue.main.async{
                        if DataHandler.getArrayOfMovies().count == 0{
                            self.displayNoMovies()
                            DataHandler.resetChosenArray()
                            DataHandler.currentStage = .initialSelection
                        }else{
                            self.blockerView.isHidden = true
                            self.MovieCollectionView.reloadData()
                        }
                    }
                    
                }catch let error{
                    DispatchQueue.main.async{
                        self.displayError(error: error)
                    }
                }
            case .error(let error):
                DispatchQueue.main.async{
                    self.displayError(error: error)
                }
            }
        }
    }
    
    // MARK: Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataHandler.getArrayOfMovies().count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Updates the collection view with the relevant image of the movie
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        let networkHandler = MovieNetworkHandler()
        
        if DataHandler.getArrayOfMovies().count > 0{
            networkHandler.getData(for: .movieImage(DataHandler.getArrayOfMovies()[indexPath.row].image)){ response in
                
                switch response{
                case .error(let error):
                    
                    DispatchQueue.main.async{
                        self.displayError(error: error)
                    }
                case .data(let image):
                    
                    DispatchQueue.main.async{
                        cell.imageView.image = UIImage(data: image)
                    }
                }
                
            }
        }
        return cell
    }
    
}






























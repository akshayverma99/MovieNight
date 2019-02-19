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
    @IBOutlet weak var PlayertwoButton: UIButton!
    @IBOutlet weak var MovieCollectionView: UICollectionView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    
    var buttonPressed: selectedButton = .personOne
    
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
            self.present(alertModal, animated: false, completion: nil)
        }
    }
    
    
    enum titleText: String{
        case PersonOne
        case PersonTwo
    }
    
    @IBAction func PersonButtonPressed(_ sender: UIButton) {
        
        
        if DataHandler.currentStage == .initialSelection{
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
                self.present(alertModal, animated: false, completion: nil)
            }
            
        }else{
            if sender.titleLabel?.text == titleText.PersonOne.rawValue{
                DataHandler.buttonPressed = .personOne
            }else if sender.titleLabel?.text == titleText.PersonTwo.rawValue{
                DataHandler.buttonPressed = .personTwo
            }
            performSegue(withIdentifier: "GenreSelect", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let NavController = segue.destination as? UINavigationController,let tableVC = NavController.viewControllers.first as? GenreTableViewController{
            tableVC.previousVC = self
            tableVC.phaseOfSelection = DataHandler.currentStage
        }
    }
    
    func updateMovies(){
        let networkHandler = MovieNetworkHandler()
        let jsonDecoder = JSONDecoder()
        
        networkHandler.getData(for: .movies){ response in
            switch response{
            case .data(let data):
                do{
                    DataHandler.addArrayOfMovies(try jsonDecoder.decode(arrayOfMovies.self, from: data).results)
                    print(DataHandler.getArrayOfMovies())
                    
                    DispatchQueue.main.async{
                         self.MovieCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataHandler.getArrayOfMovies().count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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






























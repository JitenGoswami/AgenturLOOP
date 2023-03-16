//
//  HomeScreenVC.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 30/01/23.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    // MARK: - IBOutlet Variables
    /// IBOutlet UITableView
    @IBOutlet weak var tblMoviesStaffPicks: UITableView!
    
    /// IBOutlet UICollectionView
    @IBOutlet weak var cvFavorites: UICollectionView!
    
    /// IBOutlet UIButton
    @IBOutlet weak var btnSearch: UIButton!
    
    // MARK: - Local Variables
    private var arrMoviesStaffPicks: [MoviesModel] = [MoviesModel]()
    private var arrFavourites: [MoviesModel] = [MoviesModel]()
    
    // MARK: - UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSearch.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.btnSearch.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.btnSearch.layer.shadowOpacity = 1.0
        self.btnSearch.layer.shadowRadius = 10.0
        self.btnSearch.layer.masksToBounds = false
        
        self.tblMoviesStaffPicks.dataSource = self
        self.tblMoviesStaffPicks.delegate = self
        
        self.cvFavorites.dataSource = self
        self.cvFavorites.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initialization()
    }
    
    // MARK: -  Initialization Methods
    private func initialization(){
        
        self.wsStaffPickMovies()
        self.getBookMarkedMovies()
    }
    
    //MARK: - UIButton Actions
    @IBAction func btnSearchClicked(_ sender: Any) {
        self.pushNavigation(identifierId: Constant.StoryBoardID.sAllMoviesScreenVC)
    }
    
    //MARK: - Webservice Methods
    func wsStaffPickMovies() {
        HomeScreenVM.homeValue { success, data, message in
            if success && (data?.count)! > 0{
                self.arrMoviesStaffPicks = data!
                self.tblMoviesStaffPicks.reloadData()
            }else{
                print(Constant.AlertMessages.aSomethingWentWrong)
            }
        }
    }
    
    //MARK: - Functional Methods
    func getBookMarkedMovies(){
        self.arrFavourites.removeAll()
        self.arrFavourites = Methods.getBookMarkedArray() ?? [MoviesModel]()
        self.cvFavorites.reloadData()
    }
}

//MARK: - UITableViewDataSource Extension
extension HomeScreenVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMoviesStaffPicks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellAllMovies = tableView.dequeueReusableCell(withIdentifier: "AllMoviesTVC", for: indexPath) as! AllMoviesTVC
        
        let movieModel = self.arrMoviesStaffPicks[indexPath.row]
        
        cellAllMovies.lblMovieName.text = movieModel.title
        cellAllMovies.lblReleaseYear.text = movieModel.releaseDate.components(separatedBy: "-").first
        
        Methods.setMovieRating(object: cellAllMovies, movieModel: movieModel)
        
        if let posterUrl = movieModel.posterUrl{
            cellAllMovies.imgMoviePoster.loadImage(imageUrl: URL(string: posterUrl)!, placeHolderImage: "userpic")
            cellAllMovies.imgMoviePoster.layer.cornerRadius = 10
        }
        
        if let arrBookmark = Methods.getBookMarkedArray(){
            if arrBookmark.contains(where: { $0.id == movieModel.id }) {
                cellAllMovies.btnBookMark.backgroundColor = Constant.ColorCodes.yellowStarColor
            } else {
                cellAllMovies.btnBookMark.backgroundColor = .white
            }
        }
        
        cellAllMovies.favButtonPressed = { [ weak self ] in
            if var arrBookmark = Methods.getBookMarkedArray(){
                if arrBookmark.contains(where: { $0.id == movieModel.id }) {
                    let removeIdx = arrBookmark.lastIndex(where: {$0.id == movieModel.id})
                    arrBookmark.remove(at: removeIdx!)
                    cellAllMovies.btnBookMark.backgroundColor = .white
                } else {
                    arrBookmark.append((movieModel))
                    cellAllMovies.btnBookMark.backgroundColor = Constant.ColorCodes.yellowStarColor
                }
                
                if let encoded = try? JSONEncoder().encode(arrBookmark) {
                    Methods.setUserDefault(objectToSave: encoded, keyName: Constant.UserDefaultKeys.uBookMarked)
                }
            }else{
                cellAllMovies.btnBookMark.backgroundColor = Constant.ColorCodes.yellowStarColor
                var arrBookmark = Array<MoviesModel>()
                arrBookmark.append(movieModel)
                if let encoded = try? JSONEncoder().encode(arrBookmark) {
                    Methods.setUserDefault(objectToSave: encoded, keyName: Constant.UserDefaultKeys.uBookMarked)
                }
            }
            
            self?.getBookMarkedMovies()
            self?.tblMoviesStaffPicks.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        return cellAllMovies
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "      OUR STAFF PICKS"
    }
}

//MARK: - UITableViewDelegate Extension
extension HomeScreenVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentNavigation(identifierId: Constant.StoryBoardID.sDetailScreenVC, movieModel: arrMoviesStaffPicks[indexPath.row])
    }
}

//MARK: - UICollectionViewDataSource Extension
extension HomeScreenVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrFavourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellMovieFavourite = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteMovieCVC", for: indexPath) as! FavouriteMovieCVC
        
        let movieModel = self.arrFavourites[indexPath.row]
        if let posterUrl = movieModel.posterUrl{
            cellMovieFavourite.vImageShadow.addSubview(configureMoviePosterImage(cellMovieFavourite: cellMovieFavourite, posterUrl: posterUrl))
        }
        
        return cellMovieFavourite
    }
    
    private func configureMoviePosterImage(cellMovieFavourite: FavouriteMovieCVC, posterUrl: String) -> UIImageView{
        let radius: CGFloat = 14
        cellMovieFavourite.contentView.layer.cornerRadius = radius
        cellMovieFavourite.contentView.layer.borderColor = UIColor.clear.cgColor
        cellMovieFavourite.contentView.layer.masksToBounds = true
        
        cellMovieFavourite.layer.shadowColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 0.5).cgColor
        cellMovieFavourite.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cellMovieFavourite.layer.shadowRadius = radius
        cellMovieFavourite.layer.shadowOpacity = 0.5
        cellMovieFavourite.layer.masksToBounds = false
        cellMovieFavourite.layer.shadowPath = UIBezierPath(roundedRect: cellMovieFavourite.vImageShadow.bounds, cornerRadius: radius).cgPath
        cellMovieFavourite.layer.cornerRadius = radius
        
        
        let imgMoviePoster = UIImageView(frame: cellMovieFavourite.vImageShadow.bounds)
        imgMoviePoster.clipsToBounds = true
        imgMoviePoster.layer.cornerRadius = radius
        imgMoviePoster.load(url: URL(string: posterUrl)!)
        return imgMoviePoster
    }
}

//MARK: - UICollectionViewDelegate Extension
extension HomeScreenVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentNavigation(identifierId: Constant.StoryBoardID.sDetailScreenVC, movieModel: arrFavourites[indexPath.row])
    }
}

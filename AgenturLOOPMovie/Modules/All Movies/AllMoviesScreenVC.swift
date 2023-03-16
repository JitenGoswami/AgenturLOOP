//
//  AllMoviesScreenVC.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 30/01/23.
//

import UIKit

class AllMoviesScreenVC: UIViewController {
    
    // MARK: - IBOutlet Variables
    /// IBOutlet UISearchBar
    @IBOutlet weak var searchBarAllMovies: UISearchBar!
    
    /// IBOutlet UITableView
    @IBOutlet weak var tblAllMovies: UITableView!
    
    // MARK: - Local Variables
    private var arrAllMovies: [MoviesModel] = [MoviesModel]()
    private var arrSearchMovies: [MoviesModel] = [MoviesModel]()
    private var isSearchingMovie = false
    
    // MARK: - UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constant.NavigationTitle.ntAllMovies
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialization()
    }
    
    // MARK: -  Initialization Methods
    private func initialization(){
        self.wsAllMovies()
    }
    
    //MARK: - Webservice Methods
    func wsAllMovies() {
        
        AllMoviesScreenVM.allMoviesValue { success, data, message in
            if success && (data?.count)! > 0{
                self.arrAllMovies = data!
                self.tblAllMovies.dataSource = self
                self.tblAllMovies.delegate = self
                self.tblAllMovies.reloadData()
                self.tblAllMovies.keyboardDismissMode = .onDrag
                self.searchBarAllMovies.delegate = self
                self.searchBarAllMovies.showsCancelButton = true
            }else{
                print(Constant.AlertMessages.aSomethingWentWrong)
            }
        }
    }
}

//MARK: - UISearchBarDelegate Extension
extension AllMoviesScreenVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.arrSearchMovies = self.arrAllMovies.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased() }
        isSearchingMovie = true
        self.tblAllMovies.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchingMovie = false
        searchBar.text = ""
        self.tblAllMovies.reloadData()
        self.searchBarAllMovies.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        isSearchingMovie = false
        self.searchBarAllMovies.endEditing(true)
    }
}

//MARK: - UITableViewDataSource Extension
extension AllMoviesScreenVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchingMovie ? self.arrSearchMovies.count : self.arrAllMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellAllMovies = tableView.dequeueReusableCell(withIdentifier: "AllMoviesTVC", for: indexPath) as! AllMoviesTVC
        
        let movieModel = isSearchingMovie ? self.arrSearchMovies[indexPath.row] : self.arrAllMovies[indexPath.row]
        
        cellAllMovies.lblMovieName.text = movieModel.title
        cellAllMovies.lblReleaseYear.text = movieModel.releaseDate.components(separatedBy: "-").first
        
        Methods.setMovieRating(object: cellAllMovies, movieModel: movieModel)
        
        cellAllMovies.btnBookMark.setImage(UIImage(named: Constant.ImageNames.iBookMark)?.withRenderingMode(.alwaysTemplate), for: .normal)
        cellAllMovies.btnBookMark.tintColor = .black
        
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
            
            self?.tblAllMovies.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        return cellAllMovies
    }
}

//MARK: - UITableViewDelegate Extension
extension AllMoviesScreenVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBarAllMovies.endEditing(true)
        
        self.presentNavigation(identifierId: Constant.StoryBoardID.sDetailScreenVC, movieModel: isSearchingMovie ? self.arrSearchMovies[indexPath.row] : self.arrAllMovies[indexPath.row])
    }
}

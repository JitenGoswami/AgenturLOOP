//
//  DetailScreenVC.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 30/01/23.
//

import UIKit

class DetailScreenVC: UIViewController {
    
    // MARK: - IBOutlet Variables
    /// IBOutlet UIScrollView
    @IBOutlet weak var svHome: UIScrollView!
    
    /// IBOutlet NSLayoutConstraint
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    /// IBOutlet UIView
    @IBOutlet weak var vHome: UIView!
    @IBOutlet weak var vImageShadow: UIView!
    
    /// IBOutlet UIButton
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var btnBudget: UIButton!
    @IBOutlet weak var btnRevenue: UIButton!
    @IBOutlet weak var btnOriginalLanguage: UIButton!
    @IBOutlet weak var btnRating: UIButton!
    
    /// IBOutlet UILable
    @IBOutlet weak var lblOverView: UILabel!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblMovieYear: UILabel!
    @IBOutlet weak var lblMovieDate: UILabel!
    
    /// IBOutlet UIStackView
    @IBOutlet weak var stackViewgenres1: UIStackView!
    @IBOutlet weak var stackViewgenres2: UIStackView!
    
    /// IBOutlet UIImageView
    @IBOutlet weak var imgRatingStar1: UIImageView!
    @IBOutlet weak var imgRatingStar2: UIImageView!
    @IBOutlet weak var imgRatingStar3: UIImageView!
    @IBOutlet weak var imgRatingStar4: UIImageView!
    @IBOutlet weak var imgRatingStar5: UIImageView!
    
    // MARK: - Local Variables
    var movieModel: MoviesModel?
    
    // MARK: - UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initialization()
    }
    
    // MARK: -  Initialization Methods
    private func initialization(){
        contentViewHeight.constant = UIScreen.main.bounds.height + 300
        svHome.contentSize = vHome.frame.size
        
        self.setValuesInComponents()
    }
    
    private func setValuesInComponents(){
        if let movieModel = movieModel{
            let movieHr = movieModel.runtime / 60
            let movieMin = movieModel.runtime - movieHr * 60
            
            self.btnBookMark.setImage(UIImage(named: Constant.ImageNames.iBookMark)?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.btnBookMark.tintColor = .black
            
            if let arrBookmark = Methods.getBookMarkedArray(){
                if arrBookmark.contains(where: { $0.id == movieModel.id }) {
                    self.btnBookMark.backgroundColor = Constant.ColorCodes.yellowStarColor
                } else {
                    self.btnBookMark.backgroundColor = .white
                }
            }
            
            Methods.setMovieRating(object: self, movieModel: movieModel)
            
            lblMovieDate.text = changeDateFormat(strDate: movieModel.releaseDate) + "  .  " + String(movieHr) + "h " + String(movieMin) + "m"
            lblMovieName.text = movieModel.title
            lblMovieYear.text = "(" + (movieModel.releaseDate.components(separatedBy: "-").first!) + ")"
            lblOverView.text = movieModel.overview
            
            btnBudget.configuration?.subtitle = "$ " + String(movieModel.budget).strReversedWithSeparate(string: String(movieModel.budget), every: 3, with: ".")
            btnRevenue.configuration?.subtitle = "$ " + String(movieModel.revenue ?? 0).strReversedWithSeparate(string: String(movieModel.budget), every: 3, with: ".")
            btnOriginalLanguage.configuration?.subtitle = Locale(identifier: "en_US_POSIX").localizedString(forLanguageCode: movieModel.language)
            btnRating.configuration?.subtitle = String(format: "%.2f", movieModel.rating) + " (" + String(movieModel.reviews) + ")"
            
            if let posterUrl = movieModel.posterUrl{
                vImageShadow.addSubview(configureMoviePosterImage(posterUrl: posterUrl))
            }
            
            setMovieGenres(movieModel: movieModel)
        }
    }
    
    //MARK: - Functional Methods
    private func configureMoviePosterImage(posterUrl: String) -> UIImageView{
        let radius: CGFloat = 14
        vImageShadow.clipsToBounds = false
        vImageShadow.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        vImageShadow.layer.shadowOpacity = 1
        vImageShadow.layer.shadowOffset = CGSize.zero
        vImageShadow.layer.shadowRadius = 20
        vImageShadow.layer.cornerRadius = radius
        vImageShadow.layer.shadowPath = UIBezierPath(roundedRect: vImageShadow.bounds, cornerRadius: 20).cgPath
        
        let imgMoviePoster = UIImageView(frame: vImageShadow.bounds)
        imgMoviePoster.clipsToBounds = true
        imgMoviePoster.layer.cornerRadius = radius
        imgMoviePoster.load(url: URL(string: posterUrl)!)
        return imgMoviePoster
    }
    
    private func setMovieGenres(movieModel: MoviesModel){
        for i in 0..<movieModel.genres.count {
            let button = UIButton()
            button.setTitle(movieModel.genres[i], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.init(red: 0.08, green: 0.11, blue: 0.15, alpha: 0.05)
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = true
            button.frame.size = CGSize(width: 80, height: ((stackViewgenres1.frame.width - 30 )/10))
            button.layer.cornerRadius = button.frame.height / 2
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            
            if i > 2 {
                stackViewgenres2.addArrangedSubview(button)
            }else{
                stackViewgenres1.addArrangedSubview(button)
            }
        }
    }
    
    //MARK: - UIButton Actions
    @IBAction func btnBookMarkClicked(_ sender: Any) {
        if let movieModel = movieModel{
            
            if var arrBookmark = Methods.getBookMarkedArray(){
                if arrBookmark.contains(where: { $0.id == movieModel.id }) {
                    let removeIdx = arrBookmark.lastIndex(where: {$0.id == movieModel.id})
                    arrBookmark.remove(at: removeIdx!)
                    
                    self.btnBookMark.backgroundColor = .white
                    
                } else {
                    arrBookmark.append((movieModel))
                    
                    self.btnBookMark.backgroundColor = Constant.ColorCodes.yellowStarColor
                }
                
                if let encoded = try? JSONEncoder().encode(arrBookmark) {
                    Methods.setUserDefault(objectToSave: encoded, keyName: Constant.UserDefaultKeys.uBookMarked)
                }
            }else{
                self.btnBookMark.backgroundColor = Constant.ColorCodes.yellowStarColor
                var arrBookmark = Array<MoviesModel>()
                arrBookmark.append(movieModel)
                
                if let encoded = try? JSONEncoder().encode(arrBookmark) {
                    Methods.setUserDefault(objectToSave: encoded, keyName: Constant.UserDefaultKeys.uBookMarked)
                }
            }
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Functional Methods
    func changeDateFormat(strDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        
        let date = dateFormatterGet.date(from: strDate)
        return dateFormatterPrint.string(from: date!)
    }
}

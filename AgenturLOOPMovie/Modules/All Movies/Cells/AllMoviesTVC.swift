//
//  AllMoviesTVC.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 30/01/23.
//

import UIKit

class AllMoviesTVC: UITableViewCell {
    
    // MARK: - IBOutlet Variables
    /// IBOutlet UIImageView
    @IBOutlet weak var imgMoviePoster: ImageLazyLoading!
    @IBOutlet weak var imgRatingStar1: UIImageView!
    @IBOutlet weak var imgRatingStar2: UIImageView!
    @IBOutlet weak var imgRatingStar3: UIImageView!
    @IBOutlet weak var imgRatingStar4: UIImageView!
    @IBOutlet weak var imgRatingStar5: UIImageView!
    
    /// IBOutlet UILabel
    @IBOutlet weak var lblReleaseYear: UILabel!
    @IBOutlet weak var lblMovieName: UILabel!
    
    /// IBOutlet UIButton
    @IBOutlet weak var btnBookMark: UIButton!
    
    // MARK: - UIViewController Life Cycle Methods
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    //MARK: - UIButton Actions
    var favButtonPressed : (() -> ()) = {}
    
    @IBAction func btnBookMarkClicked(_ sender: UIButton) {
        favButtonPressed()
    }
}

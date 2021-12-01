//
//  StackOverflowUserCell.swift
//  ScanWellTest
//
//  Created by Alex S on 11/30/21.
//

import UIKit
import Alamofire
import AlamofireImage

class StackOverflowUserCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reputationPointsLabel: UILabel!
    @IBOutlet weak var goldBadgeCountLabel: UILabel!
    @IBOutlet weak var silverBadgeCountLabel: UILabel!
    @IBOutlet weak var bronzeBadgeCountLabel: UILabel!
    
    var stackOverFlowUserModel: StackOverflowUserModel? {
        didSet {
            guard let userModel = self.stackOverFlowUserModel else { return }
            
            self.grabProfileImage(urlString: userModel.profileImageUrl, userId: userModel.userId)
            self.userNameLabel.text = userModel.displayName
            self.reputationPointsLabel.text = "\(userModel.reputationPoints)"
            self.goldBadgeCountLabel.text = "\(userModel.badgeCounts.gold)"
            self.silverBadgeCountLabel.text = "\(userModel.badgeCounts.silver)"
            self.bronzeBadgeCountLabel.text = "\(userModel.badgeCounts.bronze)"
        }
    }
    
    // MARK: - Private Methods
    
    private func grabProfileImage(urlString: String, userId: Int) {
        guard let url = URL(string: urlString) else { return }
        
        let loadingImage = UIImage.fontAwesomeIcon(name: .user,
                                                   style: .solid,
                                                   textColor: UIColor.lightGray,
                                                   size: CGSize(width: 40, height: 40))
        
        self.profileImage.af.setImage(withURL: url,
                                          cacheKey: String(format: Constants.userProfileCacheKey, "\(userId)"),
                                          placeholderImage: loadingImage,
                                          serializer: nil,
                                          filter: nil,
                                          progress: nil,
                                          progressQueue: DispatchQueue.main,
                                          imageTransition: .crossDissolve(0.3),
                                          runImageTransitionIfCached: false,
                                          completion: nil)
    }
}

//
//  UserDetailsController.swift
//  ScanWellApp
//
//  Created by Alex S on 11/30/21.
//

import UIKit
import Alamofire
import AlamofireImage
import FontAwesome_swift

class UserDetailsController: UIViewController {
    @IBOutlet weak var profileImageBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    var stackOverFlowUserModel: StackOverflowUserModel?
    
    override func viewDidLoad() {
        self.setupDefaults()
    }
    
    // MARK: - Private Methods
    
    private func setupDefaults() {
        if let userModel = self.stackOverFlowUserModel {
            self.profileNameLabel.text = userModel.displayName
            self.profileImageBackgroundView.layer.cornerRadius = self.profileImageBackgroundView.bounds.height / 2
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
            self.grabProfileImage(urlString: userModel.profileImageUrl, userId: userModel.userId)
            self.buildMemberSinceAttrString(userModel.creationTimestamp)
            self.buildLastSeenAttrString(userModel.lastSeenTimestamp)
            self.buildAboutMeAttrString(userModel.aboutMe)
        }
        
        self.setupProfileImageTapRecognizer()
    }
    
    private func grabProfileImage(urlString: String, userId: Int) {
        guard let url = URL(string: urlString) else { return }
        
        let loadingImage = UIImage.fontAwesomeIcon(name: .user,
                                                   style: .solid,
                                                   textColor: UIColor.lightGray,
                                                   size: CGSize(width: 150, height: 150))
        
        self.profileImageView.af.setImage(withURL: url,
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
    
    private func setupProfileImageTapRecognizer() {
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageWasTapped(_:))))
    }
    
    private func buildMemberSinceAttrString(_ creationDate: TimeInterval) {
        var timeArray: [String] = []
        let timeSinceCreation = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: creationDate), to: Date())
        
        if let years = timeSinceCreation.year,
           years > 0 {
            timeArray.append("\(years) " + Constants.years)
        }
        
        if let months = timeSinceCreation.month,
           months > 0 {
            timeArray.append("\(months) " + Constants.months)
        }
        
        if let days = timeSinceCreation.day,
           days > 0 {
            timeArray.append("\(days) " + Constants.days)
        }
        
        let memberSinceAttrString = NSMutableAttributedString(string: "")
        memberSinceAttrString.append(NSAttributedString(string: String.fontAwesomeIcon(name: .birthdayCake),
                                                        attributes: [.font : UIFont.fontAwesome(ofSize: 17, style: .solid)]
                                                       ))
        memberSinceAttrString.append(NSAttributedString(string: Constants.memberFor + timeArray.joined(separator: ", "),
                                                        attributes: [.font : UIFont.systemFont(ofSize: 17)]
                                                       ))
        self.memberSinceLabel.attributedText = memberSinceAttrString
    }
    
    private func buildLastSeenAttrString(_ lastSeenDate: TimeInterval) {
        var timeSinceString = ""
        let timeSinceLastSeen = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour,  .minute, .second], from: Date(timeIntervalSince1970: lastSeenDate), to: Date())
        
        if let seconds = timeSinceLastSeen.second,
           seconds < 60 {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(seconds) " + Util.addSIfNeeded(Constants.secondsAgo,
                                                                       count: seconds))
        } else if let minutes = timeSinceLastSeen.minute,
                  minutes < 60 {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(minutes) " + Util.addSIfNeeded(Constants.minutesAgo,
                                                                       count: minutes))
        } else if let hours = timeSinceLastSeen.hour,
                  hours < 24 {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(hours) " + Util.addSIfNeeded(Constants.hoursAgo,
                                                                     count: hours))
        } else if let days = timeSinceLastSeen.day,
                  days < 7 {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(days) " + Util.addSIfNeeded(Constants.daysAgo,
                                                                    count: days))
        } else if let weeks = timeSinceLastSeen.weekOfYear,
                  weeks < 4 {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(weeks) " + Util.addSIfNeeded(Constants.weeksAgo,
                                                                     count: weeks))
        } else if let months = timeSinceLastSeen.month,
                  months < 12 {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(months) " + Util.addSIfNeeded(Constants.monthsAgo,
                                                                      count: months))
        } else if let years = timeSinceLastSeen.year {
            timeSinceString = String(format: Constants.lastSeen,
                                     "\(years) " + Util.addSIfNeeded(Constants.yearsAgo,
                                                                     count: years))
        }
        
        //Member for 8 years, 8 months
        let memberSinceAttrString = NSMutableAttributedString(string: "")
        memberSinceAttrString.append(NSAttributedString(string: String.fontAwesomeIcon(name: .clock),
                                                        attributes: [.font : UIFont.fontAwesome(ofSize: 17, style: .solid)]
                                                       ))
        memberSinceAttrString.append(NSAttributedString(string: timeSinceString,
                                                        attributes: [.font : UIFont.systemFont(ofSize: 17)]
                                                       ))
        self.lastSeenLabel.attributedText = memberSinceAttrString
    }
    
    private func buildAboutMeAttrString(_ aboutMe: String) {
        guard aboutMe.count > 0 else { return }
        
        let largerFontHtml = "<span style=\"font-size: 17px\">\(aboutMe)</span>"
        do {
            let attrStr = try NSAttributedString(
                data: largerFontHtml.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ .documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            self.aboutMeTextView.attributedText = attrStr
            self.aboutMeTextView.sizeToFit()
        } catch {
            // Log error to backend or display in console.
        }
    }
    
    // MARK: - Gesture Recognizer Methods
    
    @objc private func profileImageWasTapped(_ gesture: UITapGestureRecognizer) {
        if let userModel = self.stackOverFlowUserModel,
           let parsedUrl = URL(string: userModel.stackOverflowLink) {
            UIApplication.shared.open(parsedUrl)
        }
    }
}

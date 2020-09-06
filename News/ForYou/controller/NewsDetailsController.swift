//
//  NewsDetailsController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI
import SafariServices

class NewsDetailsController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    var data: NewsModel?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }

    func setupUI() {
        if let imageUrl = data?.image_url, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url) { (result) in
                switch result {
                case .success(let value):
                    self.image = value.image
                default:
                    break
                }
            }
        }
        
        titleLabel.text = data?.title
        detailsLabel.text = data?.text
        publishDateLabel.text = Date.dateString(from: data?.publish_date.iso)
        authorLabel.text = data?.author
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        newsView.roundCorners(corners: [.topLeft, .topRight], radius: 50.0)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailButtonClicks(_ sender: UIButton) {
        sendEmail()
    }
    
    @IBAction func shareButtonClick(_ sender: UIButton) {
        shareApp(item: sender)
    }
    
    @IBAction func internetButtonClick(_ sender: UIButton) {
        guard let data = data, let url = URL(string: data.url) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
    
    
    func sendEmail() {
        guard let data = data else { return }
        let title = "News From: \(data.author)"
        let bodyMessage = "\n\(data.title)\n\n \(data.url)"
        
        if (MFMailComposeViewController.canSendMail()){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setSubject(title)
            composeVC.setMessageBody(bodyMessage, isHTML: false)
            // Present the view controller modally.
            composeVC.navigationBar.tintColor = .white
            self.present(composeVC, animated: true, completion: nil)
        } else if let emailUrl = createEmailUrl(subject: title, body: bodyMessage) {
            UIApplication.shared.open(emailUrl)
        }else {
            NewsHelper.showAlert(vc: self, message: "Looks like, your email client is not configured!")
        }
    }
       
       private func createEmailUrl(subject: String, body: String) -> URL? {
           let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
           let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
           
           let gmailUrl = URL(string: "googlegmail://co?subject=\(subjectEncoded)&body=\(bodyEncoded)")
           let outlookUrl = URL(string: "ms-outlook://compose?subject=\(subjectEncoded)")
           let yahooMail = URL(string: "ymail://mail/compose?subject=\(subjectEncoded)&body=\(bodyEncoded)")
           let sparkUrl = URL(string: "readdle-spark://compose?subject=\(subjectEncoded)&body=\(bodyEncoded)")
           let defaultUrl = URL(string: "mailto:subject=\(subjectEncoded)&body=\(bodyEncoded)")
           
           if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
               return gmailUrl
           } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
               return outlookUrl
           } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
               return yahooMail
           } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
               return sparkUrl
           }
           
           return defaultUrl
       }
       
    func shareApp(item: UIButton) {
        guard let data = data, let image = image else { return }
        let firstActivityItem = "Hey, check this news from \(data.author)"
        guard let secondActivityItem = URL(string: data.url) else { return }
                
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = item
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = .any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension NewsDetailsController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if result == .sent {
            NewsHelper.showAlert(vc: self, title: "Appreciate your feedback!", message: "We will get in touch with you soon.")
        }
    }
}

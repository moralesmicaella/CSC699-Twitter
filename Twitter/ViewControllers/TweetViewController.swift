//
//  TweetViewController.swift
//  Twitter
//
//  Created by Micaella Morales on 2/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var toolbar: UIView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.af.setImage(withURL: User.currUser.profileImageUrl)
        
        tweetTextView.delegate = self
        tweetTextView.placeholder = "What's happening?"
        tweetTextView.placeholderColor = .lightGray
        tweetTextView.becomeFirstResponder()
        
        createToolbar()
    }
    
    func createToolbar() {
        toolbar.frame.size.width = self.view.frame.size.width
        toolbar.frame.size.height = 45
        toolbar.layer.borderWidth = 0.5
        toolbar.layer.borderColor = UIColor.lightGray.cgColor
        tweetTextView.inputAccessoryView = toolbar
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        print("Tweet")
        Tweet.postTweet(status: tweetTextView.text) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let characterLimit = 280;
        
        let newText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        charCountLabel.text = String(characterLimit - newText.count)
        
        if newText.count > 0 {
            tweetButton.isUserInteractionEnabled = true
            tweetButton.alpha = 1
        } else {
            tweetButton.isUserInteractionEnabled = false
            tweetButton.alpha = 0.5
        }
        
        return newText.count < characterLimit
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

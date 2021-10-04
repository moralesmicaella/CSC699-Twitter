//
//  LoginViewController.swift
//  Twitter
//
//  Created by Micaella Morales on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            User.setCurrUser { (success) in
                if success {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
            }
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        User.login { (loggedIn) in
            if loggedIn {
                User.setCurrUser { (success) in
                    if success {
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                    }
                }
            }
        }
        
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

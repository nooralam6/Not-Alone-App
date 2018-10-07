//
//  ViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if isValid() {
            Common.sharedInst.showLoader()
            loginUser()
            //call webService
        } else {
            //show toast
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
    }
    
    func loginUser(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let endpoint = URL(string: base_url + "/login") else { return }
        
        var details = [String: Any]()
        details["email"] = email
        details["password"] = password
        
        do {
            let data = try JSONSerialization.data(withJSONObject: details, options: [])
            
            var request = URLRequest(url: endpoint)
            
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                
                if let detail = Common.sharedInst.parseData(with: data) {
                    DispatchQueue.main.async {
                        self.checkLogin(with: detail)
                    }
                }
                
                print(urlResponse as Any)
                print(error as Any)
                Common.sharedInst.hideLoader()
            }
            task.resume()
        } catch {
            Common.sharedInst.hideLoader()

        }
    }
    
    func checkLogin(with data: [String: Any]) {
        if let _ = data["success"] {
            let success = data["success"] as! [String: Any]
            let token = success["token"]
            let user = success["user"] as! [String: Any]
            
            let name = user["name"] as! String
            let mobile = user["mobile"] as! String
            let email = user["email"] as! String
            
            UserDefaults.standard.set(token, forKey: "token")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(name, forKey: "name")
            UserDefaults.standard.set(mobile, forKey: "mobile")
            UserDefaults.standard.set(email, forKey: "email")
            
            self.performSegue(withIdentifier: "goToHome", sender: self)
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //show error
        }
    }
    
}

extension ViewController {
    func isValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return false }
        
        if !email.isEmpty && !password.isEmpty {
            return Common.sharedInst.validateEmailString(email: email)
        } else {
            return false
        }
    }
}


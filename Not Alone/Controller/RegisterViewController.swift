//
//  RegisterViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var mobileTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextFIeld: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if checkData() {
            Common.sharedInst.showLoader()
            guard let name = nameTextField.text, let email = emailTextField.text, let mobile = mobileTextField.text, let password = passwordTextFIeld.text, let endpoint = URL(string: base_url + "/register") else { return }
            
            var details = [String: Any]()
            details["email"] = email
            details["password"] = password
            details["mobile"] = mobile
            details["name"] = name
            
            do {
                let data = try JSONSerialization.data(withJSONObject: details, options: [])
                
                var request = URLRequest(url: endpoint)
                
                request.httpMethod = "POST"
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.getAllTasks { (openTasks:[URLSessionTask]) in
                    print(openTasks)
                }
                
                let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                    DispatchQueue.main.async {
                        if let detail = Common.sharedInst.parseData(with: data) {
                            self.persistData(with: detail)
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
        } else {
            Common.sharedInst.hideLoader()

        }
        
    }
    
    func persistData(with data: [String: Any]) {
        
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

        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkData() -> Bool {
        guard let name = nameTextField.text, let email = emailTextField.text, let mobile = mobileTextField.text, let password = passwordTextFIeld.text else { return false }
        
        if name.isEmpty || email.isEmpty || mobile.isEmpty || password.isEmpty {
            //show error
            return false
        } else {
            return Common.sharedInst.validateEmailString(email: email)
        }
    }
    
}

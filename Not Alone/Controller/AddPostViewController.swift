//
//  AddPostViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class AddPostViewController: UIViewController {

    @IBOutlet weak var feelingMessageTextView: JVFloatLabeledTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let text = feelingMessageTextView.text else { return }
        if text.isEmpty {
            print("Please enter text")
        } else {
            postData(with: text)
        }
    }
    func postData(with text: String){
        
        do {
            Common.sharedInst.showLoader()
            guard let endpoint = URL(string: base_url + "/secret/add") else { return }
            
            var details = [String: Any]()
            var token = "Bearer "
            token += UserDefaults.standard.value(forKey: "token") as! String
            details["token"] = token
            details["text"] = text
            let data = try JSONSerialization.data(withJSONObject: details, options: [])
            
            var request = URLRequest(url: endpoint)
            
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "Authorization")

            URLSession.shared.getAllTasks { (openTasks:[URLSessionTask]) in
                print(openTasks)
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                
                if let detail = Common.sharedInst.parseData(with: data) {
                    print(detail)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PostViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class PostViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var newCommentsTextFIeld: JVFloatLabeledTextField!
    
    var commentsArray = [Comments]()
    var secretId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendCommentTapped(_ sender: Any) {
        guard let comment = newCommentsTextFIeld.text else { return }
        
        if comment.isEmpty {
            print("Please enter comment")
        } else {
            sendNewComment(with: comment)
        }
        
    }
    
    func sendNewComment(with comment: String) {
        do {
            Common.sharedInst.showLoader()
            guard let endpoint = URL(string: base_url + "/secret/comment/add") else { return }
            
            var details = [String: Any]()
            var token = "Bearer "
            token += UserDefaults.standard.value(forKey: "token") as! String
            details["token"] = token
            details["comment"] = comment
            details["secret_id"] = secretId
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
                DispatchQueue.main.async {
                    self.commentsTableView.reloadData()
                }
                Common.sharedInst.hideLoader()
                
            }
            task.resume()
            
        } catch {
            Common.sharedInst.hideLoader()
        }
    }
    
}
extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EmotionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! EmotionTableViewCell
        cell.spamButton.addTarget(self, action: #selector(markSpam(_:)), for: .touchUpInside)
        cell.messag.text = commentsArray[indexPath.row].comment
        return cell
    }
    
    @objc func markSpam(_ sender: UIButton) {
        
    }
}

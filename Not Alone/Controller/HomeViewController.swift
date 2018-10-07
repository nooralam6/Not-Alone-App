//
//  HomeViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storyButton: UIButton!
    
    var feedArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyButton.addTarget(self, action: #selector(storyButtonPressed), for: .touchUpInside)
//        let searchButtonItem = UIBarButtonItem(customView: storyButton)
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationItem.rightBarButtonItem = searchButtonItem
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    
    @objc func storyButtonPressed() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StoryViewController") as! StoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData() {
        Common.sharedInst.showLoader()
        do {
            guard let endpoint = URL(string: base_url + "/feed") else { return }
            var details = [String: Any]()
            var token = "Bearer "
            token += UserDefaults.standard.value(forKey: "token") as! String
            details["token"] = token
            
            var request = URLRequest(url: endpoint)
            
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(token, forHTTPHeaderField: "Authorization")
        
            
            let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    Common.sharedInst.parseData(with: data)
                    self.decodeData(with: data)
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
    
    func decodeData(with data: Data?) {
        let jsonDecoder = JSONDecoder()
        do {
            feedArray = try jsonDecoder.decode([Post].self, from: data!)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EmotionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "emotionCell", for: indexPath) as! EmotionTableViewCell
        cell.spamButton.addTarget(self, action: #selector(markSpam), for: .touchUpInside)
        cell.messag.text = feedArray[indexPath.row].secret ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        vc.secretId = feedArray[indexPath.row].id ?? 0	
        vc.commentsArray = feedArray[indexPath.row].comments ?? [Comments]()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func markSpam(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
    }
    
    func callMarkSpam(){
        var details = [String: Any]()
        details["id"] = ""
        details["token"] = UserDefaults.standard.value(forKey: "token")
        
        do {
            guard let endpoint = URL(string: base_url + "") else { return }
            
            let data = try JSONSerialization.data(withJSONObject: details, options: [])
            
            var request = URLRequest(url: endpoint)
            
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
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
}

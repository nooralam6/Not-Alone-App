//
//  StoryViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var storyArray = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    func getData() {
        Common.sharedInst.showLoader()
        do {
            guard let endpoint = URL(string: base_url + "/stories") else { return }
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
            storyArray = try jsonDecoder.decode([Story].self, from: data!)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

}

extension StoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EmotionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "emotionCell", for: indexPath) as! EmotionTableViewCell
        cell.spamButton.isHidden = true
//        cell.spamButton.addTarget(self, action: #selector(markSpam), for: .touchUpInside)
        cell.messag.text = storyArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StoryDetailsViewController") as! StoryDetailsViewController
        vc.story = storyArray[indexPath.row].story ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

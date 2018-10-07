//
//  StoryDetailsViewController.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import WebKit


class StoryDetailsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var storyView: WKWebView!
    var story = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyView.loadHTMLString(story, baseURL: nil)

        // Do any additional setup after loading the view.
    }
    


}

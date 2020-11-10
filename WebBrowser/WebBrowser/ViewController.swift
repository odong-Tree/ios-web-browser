//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    let myUrl = "https://www.indiepost.co.kr"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openStartPage()
    }
    
    func openStartPage() {
        guard let indiePostUrl = URL(string: myUrl) else { return }
        let request = URLRequest(url: indiePostUrl)
        webView.load(request)
    }
    
    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "error", message: "url을 불러오는데 오류가 발생했습니다.", preferredStyle: .alert)
        let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(OKButton)
        present(errorAlert, animated: true, completion: nil)
    }

}


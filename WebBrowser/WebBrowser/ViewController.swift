//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

// TODO: add indicator
class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpWebView()
    }
    
    func setUpUI() {
        searchBar.delegate = self
        webView.navigationDelegate = self
    }
    
    func setUpWebView() {
        let startUrl = "https://www.indiepost.co.kr"
        requestURL(urlString: startUrl)
    }
    
    func requestURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            return showErrorAlert(error: .convertUrl)
        }
        
        let request = URLRequest(url: url)
        print(request)
        webView.load(request)
    }
    
    func showErrorAlert(error: ErrorMessage) {
        let alert = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmAction)
        present(alert, animated: false, completion: nil)
    }
    
    @IBAction func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
        else {
            showErrorAlert(error: .moveBack)
        }
    }
    
    @IBAction func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
        else {
            showErrorAlert(error: .moveForward)
        }
    }
    
    @IBAction func reloadPage() {
        webView.reload()
    }
    
    @IBAction func movePage() {
        self.searchBar.endEditing(true)
        guard let urlString = searchBar.text,
              urlString.isNotEmpty else {
            return showErrorAlert(error: .emptyAddress)
        }
        
        let requestUrlString: String
        if isNotUrl(origin: urlString) {
            requestUrlString = makeUrlString(originString: urlString)
        }
        else {
            requestUrlString = urlString
        }
        
        guard checkUrlValidation(urlString: requestUrlString) else {
            return showErrorAlert(error: .validateAddress)
        }
        
        requestURL(urlString: requestUrlString)
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.movePage()
    }
}

extension ViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        guard let urlString = webView.url?.absoluteString else {
            return showErrorAlert(error: .loadPage)
        }
        
        debugPrint("redirect url: \(urlString)")
        
        self.requestURL(urlString: urlString)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString {
            self.searchBar.text = urlString
        }
    }
    
    func isNotUrl(origin: String) -> Bool {
        if origin.hasPrefix("https://") || origin.hasPrefix("http://") {
            return false
        }
        return true
    }
    
    func makeUrlString(originString: String) -> String {
        return "https://" + originString
    }
    
    func checkUrlValidation(urlString: String) -> Bool {
        let urlRegex = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegex).evaluate(with: urlString)
    }
}

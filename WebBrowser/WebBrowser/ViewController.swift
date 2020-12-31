//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpWebView()
    }
    
    // MARK: - setup
    func setUpUI() {
        searchBar.delegate = self
        webView.navigationDelegate = self
    }
    
    func setUpWebView() {
        let startUrl = "https://www.indiepost.co.kr"
        do {
            try requestURL(startUrl)
        } catch {
            self.showError(error)
        }
    }
    
    // MARK: - request url
    func requestURL(_ urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw WebError.converUrl
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
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

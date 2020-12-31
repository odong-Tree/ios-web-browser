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
    private func setUpUI() {
        searchBar.delegate = self
        webView.navigationDelegate = self
    }
    
    private func setUpWebView() {
        let startUrl = "https://www.indiepost.co.kr"
        do {
            try requestURL(startUrl)
        } catch {
            self.showError(error)
        }
    }
    
    // MARK: - request url
    private func requestURL(_ urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw WebError.converUrl
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - IBActions
    @IBAction func goBack() {
        guard webView.canGoBack else {
            return self.showError(WebError.moveBack)
        }
        webView.goBack()
    }
    
    @IBAction func goForward() {
        guard webView.canGoForward else {
            return self.showError(WebError.moveForward)
        }
        webView.goForward()
    }
    
    @IBAction func reloadPage() {
        webView.reload()
    }
    
    @IBAction func movePage() {
        do {
            self.searchBar.endEditing(true)
            guard let urlString = searchBar.text,
                  urlString.isNotEmpty else {
                throw WebError.emptyAddress
            }
            
            let requestUrlString: String
            if isNotUrl(origin: urlString) {
                requestUrlString = makeUrlString(originString: urlString)
            }
            else {
                requestUrlString = urlString
            }
            
            guard checkUrlValidation(urlString: requestUrlString) else {
                throw WebError.validateAddress
            }
            
            try requestURL(requestUrlString)
        } catch {
            self.showError(error)
        }
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.movePage()
    }
}

extension ViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        do {
            guard let urlString = webView.url?.absoluteString else {
                throw WebError.loadPage
            }
            try self.requestURL(urlString)
        } catch {
            self.showError(error)
        }
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

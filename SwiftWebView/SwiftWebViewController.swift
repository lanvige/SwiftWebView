//
//  SwiftWebViewController.swift
//  SwiftWebView
//
//  Created by Lanvige Jiang on 3/29/15.
//  Copyright (c) 2015 D2 Labs http://d2labs.cn . All rights reserved.
//

import UIKit
import WebKit
import Foundation


public protocol SwiftWebViewControllerDelegate {
    func webView(webView: SwiftWebViewController, didStartLoadingURL URL: NSURL)
    func webView(webView: SwiftWebViewController, didFinishLoadingURL URL: NSURL)
    func webView(webView: SwiftWebViewController, didFailToLoadURL URL: NSURL, error: NSError)
}

public class SwiftWebViewController: UIViewController {
    // MARK: - Perproty
    
    // Delegate
    public var delegate: SwiftWebViewControllerDelegate?
    // Configurations
    public var showsPageTitleInNavigationBar: Bool = true
    // Theme
    var tintColor: UIColor?
    var barTintColor: UIColor?
    
    // MARK: 
    
    /** A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations. The default value is false. */
    var allowsBackForwardNavigationGestures: Bool {
        get {
            return webView.allowsBackForwardNavigationGestures
        }
        set(value) {
            webView.allowsBackForwardNavigationGestures = value
        }
    }
    
    /** A boolean value if set to true shows the toolbar; otherwise, hides it. */
    public var showToolbar: Bool {
        set(value) {
            self.toolbarHeight = value ? 44 : 0
        }
        
        get {
            return self.toolbarHeight == 44
        }
    }
    
    
    // private
    // Observing Content
    private var myContext = 0
    private var toolbarHeight: Float = 0
    private var webView: WKWebView
    
    // MARK: - NSObject

    public init(config: WKWebViewConfiguration?) {
        self.webView = WKWebView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init() {
        self.init(config: nil)
    }
    

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.webView.navigationDelegate = nil
        self.webView.UIDelegate = nil
        
        self.stopObservingWebView()
    }
    
    // MARK: - UIViewController Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGrayColor()

        // Do any additional setup after loading the view.
        self.setupDomainLabel()
        self.setupWebView()
        self.setupProgressView()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    public override func viewWillDisappear(animated: Bool) {
        //
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDomainLabel() {
        var domainLabel = UILabel()
        domainLabel.text = "baidu.com"
        domainLabel.textColor = UIColor.whiteColor()
        domainLabel.font = UIFont.systemFontOfSize(12)
        domainLabel.textAlignment = .Center
        self.view.addSubview(domainLabel)
        
        domainLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[domainLabel]-0-|", options: nil, metrics: nil, views: ["domainLabel": domainLabel]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-20-[domainLabel(20)]", options: nil, metrics: nil, views: ["domainLabel": domainLabel, "topGuide": self.topLayoutGuide]))
    }
    
    func setupWebView() {
        self.webView.backgroundColor = UIColor.clearColor()
        self.webView.scrollView.backgroundColor = UIColor.clearColor()
        var a = UIWebView()
        
        self.webView.navigationDelegate = self
        self.webView.multipleTouchEnabled = false
        self.webView.autoresizesSubviews = true
        
        self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.startObservingWebView(webView)
        
        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[webView]-0-|", options: nil, metrics: nil, views: ["webView": webView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-0-[webView]-0-|", options: nil, metrics: nil, views: ["webView": webView, "topGuide": self.topLayoutGuide]))
    }
    
    func setupProgressView() {
        self.view.addSubview(progressView)
        self.progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[progressView]-0-|", options: nil, metrics: nil, views: ["progressView": progressView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-0-[progressView(2)]", options: nil, metrics: nil, views: ["progressView": progressView, "topGuide": self.topLayoutGuide]))
    }
    
    // MARK: - Lazy View

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .Default)
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0)
        
        return progressView
    }()
    
    private lazy var operationToolbar: SwiftWebViewToolbar = {
        let toolbar = SwiftWebViewToolbar()
        return toolbar
    }()
    
    // 
    private func showError(errorString: String?) {
        var alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}


// WKNavigationDelegate
extension SwiftWebViewController: WKNavigationDelegate {
    private func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //
        self.updateUIState()
        
        if let delegate = self.delegate {
            delegate.webView(self, didStartLoadingURL: webView.URL!)
        }
    }
    
    private func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        self.updateUIState()
        
        if let delegate = self.delegate {
            delegate.webView(self, didFinishLoadingURL: webView.URL!)
        }
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        self.updateUIState()

        if let delegate = self.delegate {
            delegate.webView(self, didFailToLoadURL: webView.URL!, error: error)
        }
    }
    
    private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        self.updateUIState()
        
        if let delegate = self.delegate {
            delegate.webView(self, didFailToLoadURL: webView.URL!, error: error)
        }
    }
}


// Public API
extension SwiftWebViewController {
    
    public func loadURL(URL: NSURL) {
        // Do any additional setup after loading the view.
        webView.loadRequest(NSURLRequest(URL: URL))
    }
    
    public func loadURLString(URLString: String) {
        let URL = NSURL(string: URLString)
        
        if let urlValue = URL {
            self.loadURL(urlValue)
        }
    }
    
    public func loadFile() {
    }
}


// Update Navigation Event
extension SwiftWebViewController {
    private func updateUIState() {
        
        if (self.showsPageTitleInNavigationBar) {
                self.title = webView.title
        }
        
            if (webView.canGoBack) {
                self.navigationItem.leftItemsSupplementBackButton = true
                
                var closeBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "performBackNavigation")
                self.navigationItem.leftBarButtonItem = closeBarButtonItem
            }
    
        
        if let backBarButtonItem = self.navigationItem.backBarButtonItem {
            backBarButtonItem.action = Selector("performBackNavigation")
        }
    }
    
    private func canWebViewGoBack() -> Bool {
        return self.webView.canGoBack
    }
    
    private func webViewGoBack() {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        }
    }
    
    private func performBackNavigation() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}


// iOS 8 WKWebView Progress
extension SwiftWebViewController {
    private func startObservingWebView(webView: WKWebView) {
        let options = NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: options, context: &myContext)
    }
    
    private func stopObservingWebView() {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if (context == &myContext) {
            self.progressView.alpha = 1
            
            if let progress: Float = change[NSKeyValueChangeNewKey]?.floatValue {
                var animated = progress > self.progressView.progress
                
                self.progressView.setProgress(progress, animated: animated)
                
                if (progress >= 1) {
                    UIView.animateKeyframesWithDuration(0.3, delay: 0.3, options: UIViewKeyframeAnimationOptions.allZeros, animations: { () -> Void in
                        self.progressView.alpha = 0
                        }, completion: { (finished) -> Void in
                            self.progressView.setProgress(0, animated: false)
                    })
                }
            }
            
            // if let webView = self.wkWebView {
            //    var progress: Float = (Float)(webView.estimatedProgress)
            //    }
            // }
            
            // println("Date changed: \(change[NSKeyValueChangeNewKey])")
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}
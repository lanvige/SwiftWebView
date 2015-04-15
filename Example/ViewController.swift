//
//  ViewController.swift
//  SwiftWebViewExample
//
//  Created by Lanvige Jiang on 4/14/15.
//  Copyright (c) 2015 Lanvige Jiang. All rights reserved.
//

import UIKit
import SwiftWebView

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var pushButton: UIButton!
    
    
    @IBAction func pushAction(sender: UIButton) {
        var a = SwiftWebViewController()
        a.delegate = self
        self.navigationController?.pushViewController(a, animated: true)
        
        a.loadURLString("http://www.baidu.com")
    }
    
    
    @IBAction func presentAction(sender: UIButton) {
        var nav = UINavigationController()
    }
}


extension MainViewController: SwiftWebViewControllerDelegate {
    func webView(webView: SwiftWebViewController, didStartLoadingURL URL: NSURL) {
        //
        println("start")
    }
    
    func webView(webView: SwiftWebViewController, didFinishLoadingURL URL: NSURL) {
        //
    }
    
    func webView(webView: SwiftWebViewController, didFailToLoadURL URL: NSURL, error: NSError) {
        //
    }
}

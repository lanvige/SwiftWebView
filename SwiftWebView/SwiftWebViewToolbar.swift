//
//  SwiftWebViewToolbar.swift
//  SwiftWebView
//
//  Created by Lanvige Jiang on 4/13/15.
//  Copyright (c) 2015 Lanvige Jiang. All rights reserved.
//

import UIKit

protocol SwiftWebViewToolbarDelegate {
    func webViewNavigationToolbarGoBack(toolbar: SwiftWebViewToolbar)
    func webViewNavigationToolbarGoForward(toolbar: SwiftWebViewToolbar)
    func webViewNavigationToolbarRefresh(toolbar: SwiftWebViewToolbar)
}

class SwiftWebViewToolbar: UIView {
    var forwardButton, refreshButton, stopButton, actionButton, fixedSeparator, flexibleSeparator: UIBarButtonItem?
    // lazy
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(contentsOfFile: "ss"), style: .Plain, target: self, action: "")
        return button
        }()
    
    func enableBackward() {
    }
    
    func enableForward() {
    }
    
    func toggerShow() {
    }
}

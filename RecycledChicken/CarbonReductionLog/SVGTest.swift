//
//  SVGTest.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/10.
//

import UIKit
import SVGKit
import WebKit

class SVGTest: UIView, NibOwnerLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
        backgroundColor = .red
        let webview = WKWebView()
        addSubview(webview)
        webview.center = center
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.frame.size = CGSize(width: 400, height: 400)
        
        if let url = Bundle.main.url(forResource: "fillRightChicken", withExtension: "svg"), let svgString = try? String(contentsOf: url) {
            let color = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            let hexSTringColor = hexStringFromColor(color: color)
            let changeSVGColor = changeSVGColor(svgContent: svgString, hexString: hexSTringColor)
            let changeSVGSize = changeSVGSize(svgContent: changeSVGColor, size: CGSize(width: 100, height: 100))
            webview.loadHTMLString(changeSVGSize, baseURL: nil)
        }
    }
    
    func changeSVGColor(svgContent: String, hexString:String) -> String {
        // Modify SVG content using JavaScript to change fill color
        var result = svgContent
        if let startIndex = svgContent.range(of: "fill:")?.upperBound,
           let endIndex = svgContent.range(of: ";", range: startIndex..<svgContent.endIndex)?.lowerBound {
            let rangeToReplace = startIndex..<endIndex
            result.replaceSubrange(rangeToReplace, with: hexString)
        }
        return result
    }
    
    func changeSVGSize(svgContent: String, size:CGSize) -> String {
        var result = svgContent
        if let widthRangeToReplace = getRangeString(svgContent, "width=\"", "\"") {
            let widthStr = "\(size.width)"
            result.replaceSubrange(widthRangeToReplace, with: widthStr)
        }
        if let heightRangeToReplace = getRangeString(svgContent, "height=\"", "\"") {
            let widthStr = "\(size.height)"
            result.replaceSubrange(heightRangeToReplace, with: widthStr)
        }
        return result
    }

    func getRangeString(_ svgContent:String, _ start:String, _ end:String) -> Range<String.Index>? {
        if let startIndex = svgContent.range(of: start)?.upperBound,
           let endIndex = svgContent.range(of: end, range: startIndex..<svgContent.endIndex)?.lowerBound {
            let rangeToReplace = startIndex..<endIndex
            return rangeToReplace
        }
        return nil
    }
    
}

extension SVGTest: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
     
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    guard let height = height as? CGFloat else { return }
                    print(height)
                })
            }
        })

    }
    
}

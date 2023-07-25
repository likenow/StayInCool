//
//  WebView.swift
//  StayInCool
//
//  Created by kbj on 2023/7/25.
//

import SwiftUI
import WebKit

struct WebViewWithHeader: View {
    let htmlFileName: String
    let headerTitle: String

    var body: some View {
        VStack {
            Text(headerTitle)
                .font(.title3)

            WebView(htmlFileName: htmlFileName)
        }
    }
}


struct WebView: UIViewRepresentable {
    let htmlFileName: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let htmlPath = Bundle.main.path(forResource: htmlFileName, ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

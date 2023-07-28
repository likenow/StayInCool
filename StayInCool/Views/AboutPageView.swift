//
//  AboutPageView.swift
//  StayInCool
//
//  Created by kbj on 2023/7/25.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        VStack {
            Text("哪凉快哪儿呆着去")
                .font(.title3)
                .padding(4)
            
            Text("v1.0.0")
                .font(.subheadline)
                .padding(4)
            
            Text("应用名是中国的一句俗语。有两层含义: ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 10)
            Text("一就是本意，哪里凉快就去哪里歇着去凉快凉快；")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 20)
            Text("二是有点厌烦态度,通常说是对于那些话多比较碍事还不讲理的人，叫他哪里凉快待哪里去,别再在你面前晃了。")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 20)
            Text("本应用当然只是第一层意思。用户可以搜索到目的地的天气情况，并且会在地图上标注出来。")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing], 10)
            
            Spacer()
            
            HStack {
                NavigationLink(destination: WebViewWithHeader(htmlFileName: "privacy", headerTitle: "隐私权政策")) {
                    Text("《隐私权政策》")
                }
                
                NavigationLink(destination: WebViewWithHeader(htmlFileName: "agreement", headerTitle: "用户服务协议")) {
                    Text("《用户服务协议》")
                }
            }
            .padding(10)
        }
        .navigationBarTitle("关于")
    }
}

struct SupportUsView: View {
    @StateObject private var iapViewModel = IAPViewModel()
    
    func productsReq(_ id: String) {
        for product in iapViewModel.products {
            if product.productIdentifier == id {
                iapViewModel.purchaseProduct(product: product)
                break
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("感谢您能选择使用我们的产品，您的每一份支持我们都将投入到项目研发中，支持我们进行不断的迭代更新，创造更多好用的App，和我们一起努力让这个世界更加美好！")
                    .padding([.leading, .trailing], 10)
                
                Text("赞助计划")
                    .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    Text("赞助程序员大佬")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("¥ 8.0")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .frame(width: 280, height: 50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.gray, lineWidth: 0.5)
                )
                .onTapGesture {
                    productsReq("SupportPlanC001")
                }
                
                VStack(alignment: .leading) {
                    Text("赞助设计小姐姐")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("¥ 12.0")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .frame(width: 280, height: 50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.gray, lineWidth: 0.5)
                )
                .onTapGesture {
                    productsReq("SupportPlanC002")
                }
                
                VStack(alignment: .leading) {
                    Text("赞助产品大大")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("¥ 28.0")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .frame(width: 280, height: 50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.gray, lineWidth: 0.5)
                )
                .onTapGesture {
                    productsReq("SupportPlanC003")
                }
                
                Spacer()
            }
            .navigationBarTitle("支持我们")
            .onAppear {
                // Fetch the product list when the view appears
                let productIdentifiers: Set<String> = ["SupportPlanC001", "SupportPlanC002", "SupportPlanC003"]
                iapViewModel.fetchProducts(productIdentifiers: productIdentifiers)
            }
        }
    }
}

struct AboutPageView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: AboutUsView()) {
                    Text("关于")
                }
                NavigationLink(destination: SupportUsView()) {
                    Text("支持我们")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding([.top], -20)
        }
    }
}

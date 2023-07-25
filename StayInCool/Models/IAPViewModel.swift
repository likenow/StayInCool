//
//  IAPViewModel.swift
//  StayInCool
//
//  Created by kbj on 2023/7/25.
//

import StoreKit

class IAPViewModel: ObservableObject {
    @Published var products: [SKProduct] = []
    private let storeManager = StoreManager()

    func fetchProducts(productIdentifiers: Set<String>) {
        storeManager.fetchProducts(productIdentifiers: productIdentifiers) { [weak self] (products) in
            self?.products = products
        }
    }

    func purchaseProduct(product: SKProduct) {
        storeManager.purchaseProduct(product: product)
    }

    func restorePurchases() {
        storeManager.restorePurchases()
    }
}

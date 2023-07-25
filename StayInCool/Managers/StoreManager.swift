//
//  StoreManager.swift
//  StayInCool
//
//  Created by kbj on 2023/7/25.
//

import StoreKit

class StoreManager: NSObject, ObservableObject {
    private let productRequest = SKProductsRequest()
    private var productsRequestCompletionHandler: (([SKProduct]) -> Void)?

    override init() {
        super.init()
        productRequest.delegate = self
    }

    func fetchProducts(productIdentifiers: Set<String>, completion: @escaping ([SKProduct]) -> Void) {
        productsRequestCompletionHandler = completion
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            // TODO
            print("用户禁用了应用内购买")
        }
    }

    func purchaseProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsRequestCompletionHandler?(response.products)
        productsRequestCompletionHandler = nil
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        // Handle request error, if any.
    }
}

extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase.
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // Handle failed purchase.
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // Handle restored purchase.
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing:
                break // Do nothing for these states.
            @unknown default:
                break
            }
        }
    }
}


//
//  StoreHelper.swift
//  quran
//
//  Created by developer on 5/26/22.
//

import StoreKit
import SwiftUI

enum ProductIds: String, CaseIterable {
    case threeMonthAdFree = "com.madotastudio.Quran2023.Adfree"
}

class StoreHelper: NSObject, ObservableObject {
    @Published var products = [SKProduct]()
    @Published var completedTransactions = [SKPaymentTransaction]()
    private var request: SKProductsRequest?
    
    override init() {
        super.init()
        fetchProducts()
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func fetchProducts() {
        request = SKProductsRequest(productIdentifiers: Set(ProductIds.allCases.compactMap { $0.rawValue }))
        request?.delegate = self
        request?.start()
    }
    
    private func isTransactionSubscriptionIsValid(transaction: SKPaymentTransaction, product: SKProduct) -> Bool {
        var days = 0
        if let productPeriod = product.subscriptionPeriod {
            switch productPeriod.unit {
            case .day:
                days = 1 * productPeriod.numberOfUnits
                break
            case .week:
                days = 7 * productPeriod.numberOfUnits
                break
            case .month:
                days = 30 * productPeriod.numberOfUnits
                break
            case .year:
                days = 365 * productPeriod.numberOfUnits
                break
            @unknown default:
                days = 0 * productPeriod.numberOfUnits
                break
            }
        } else {
            return false
        }
        
        guard let transactionDate = transaction.transactionDate else {
            return false
        }
        
        let date = Date.DateAfterAdding(days: days, into: transactionDate)
        
        if date > Date() {
            return true
        }
        return false
    }
    
    private func isTransactionAvailableAndUsable(withProductId productId: ProductIds) -> Bool {
        guard let transaction = completedTransactions.first(where: { paymentItem in
            paymentItem.payment.productIdentifier == productId.rawValue
        }) else {
            return false
        }
        guard let product = products.first(where: { searchProduct in
            searchProduct.productIdentifier == productId.rawValue
        }) else {
            return false
        }
        
        if isTransactionSubscriptionIsValid(transaction: transaction, product: product) {
            return true
        }
        
        return false
    }
    
    func purchaseProduct(productId: ProductIds) {
        guard let product = products.first(where: { searchProduct in
            searchProduct.productIdentifier == productId.rawValue
        }) else { return }
        
        if isTransactionAvailableAndUsable(withProductId: productId) {
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}


extension StoreHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
        self.request = nil
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.products = []
        self.request = nil
    }
}

extension StoreHelper: SKPaymentTransactionObserver {
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async {
            self.completedTransactions = queue.transactions
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let state = transaction.transactionState
            if state == .purchased || state == .restored {
                DispatchQueue.main.async {
                    self.completedTransactions.append(transaction)
                }
            }
        }
    }
}

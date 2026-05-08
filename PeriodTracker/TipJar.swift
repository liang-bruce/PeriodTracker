//
//  TipJar.swift
//  PeriodTracker
//

import Foundation
import StoreKit

@MainActor
@Observable
final class TipJar {
    // Match these IDs with the products in App Store Connect (and PeriodTracker.storekit
    // for local simulator testing). Order doesn't matter — products are sorted by price
    // before display.
    static let productIDs: [String] = [
        "com.jitianliang.PeriodTracker.tip.small",
        "com.jitianliang.PeriodTracker.tip.medium",
        "com.jitianliang.PeriodTracker.tip.large",
    ]

    var products: [Product] = []
    var loadFailed = false
    var purchaseInProgress: Product.ID?
    var lastPurchaseSucceeded = false

    func loadProducts() async {
        do {
            let fetched = try await Product.products(for: Self.productIDs)
            products = fetched.sorted { $0.price < $1.price }
            loadFailed = products.isEmpty
        } catch {
            loadFailed = true
        }
    }

    func purchase(_ product: Product) async {
        purchaseInProgress = product.id
        defer { purchaseInProgress = nil }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(let transaction)):
                // Tips are consumables — finish the transaction so StoreKit doesn't
                // re-deliver it. There's nothing to "unlock" so no other state change.
                await transaction.finish()
                lastPurchaseSucceeded = true
            case .success(.unverified), .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            // Surface failures via UI state if needed; for a tip jar, silent retry is fine.
        }
    }
}

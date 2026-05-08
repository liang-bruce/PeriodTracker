//
//  TipJarView.swift
//  PeriodTracker
//

import SwiftUI
import StoreKit

struct TipJarView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appCopy) private var copy
    @State private var tipJar = TipJar()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        if tipJar.lastPurchaseSucceeded {
                            thankYouCard
                        } else {
                            header
                            productsSection
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(copy.text(.supportApp))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(copy.text(.done)) { dismiss() }
                }
            }
            .task { await tipJar.loadProducts() }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color(.systemPink))
            Text(copy.text(.supportSubtitle))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }

    @ViewBuilder
    private var productsSection: some View {
        if tipJar.products.isEmpty && tipJar.loadFailed {
            Text(copy.text(.tipUnavailable))
                .foregroundStyle(.secondary)
                .padding(.top, 24)
        } else if tipJar.products.isEmpty {
            ProgressView()
                .padding(.top, 24)
        } else {
            VStack(spacing: 12) {
                ForEach(tipJar.products) { product in
                    productButton(for: product)
                }
            }
        }
    }

    private func productButton(for product: Product) -> some View {
        Button {
            Task { await tipJar.purchase(product) }
        } label: {
            HStack {
                Text(product.displayName)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer()
                if tipJar.purchaseInProgress == product.id {
                    ProgressView()
                } else {
                    Text(product.displayPrice)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.regularMaterial)
            )
        }
        .buttonStyle(.plain)
        .disabled(tipJar.purchaseInProgress != nil)
    }

    private var thankYouCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color(.systemPink))
            Text(copy.text(.tipThankYou))
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    TipJarView()
}

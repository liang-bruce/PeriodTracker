//
//  FertileWindowInfoView.swift
//  PeriodTracker
//

import SwiftUI

struct FertileWindowInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appCopy) private var copy

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(copy.text(.fertileWindowAlgorithm))
                        .font(.body)
                        .foregroundStyle(.primary)

                    Text(copy.text(.fertileWindowBookCitation))
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Text(copy.text(.fertileWindowDefaultNote))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .navigationTitle(copy.text(.fertileWindowTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(copy.text(.close)) { dismiss() }
                }
            }
        }
    }
}

#Preview {
    FertileWindowInfoView()
}

//
//  GoldmanSacksView.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 24/04/26.
//

import SwiftUI

struct GoldmanSacksView: View {
    @StateObject private var viewModel = GoldmanSacksViewModel()
    @Binding var showMainView: Bool
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.items.isEmpty {
                    Text("Items Loading ....")
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            NavigationLink {
                                ItemDetailView(
                                    item: item,
                                    image: viewModel.getImage(for: item)
                                )
                            } label: {
                                RowView(
                                    image: viewModel.getImage(for: item),
                                    title: item.title ?? "Untitled",
                                    explanation: item.explanation ?? "",
                                    date: viewModel.getParsedDate(for: item),
                                    onAppear: {
                                        viewModel.loadImageIfNeeded(for: item)
                                    }
                                )
                            }
                            .listRowSeparator(.hidden)
                           .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                }
            }
            .navigationBarTitle("Goldman Sacks")
            .navigationBarItems(trailing: Button(action: {
                withAnimation(.easeInOut) {
                    showMainView = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.primary)
            })
        }
        .loadingOverlay(viewModel.isLoading)
    }
}

#Preview {
//    GoldmanSacksView()
//    VStack(spacing: 12) {
//        RowView(
//            imageURL: URL(string: "https://apod.nasa.gov/apod/image/2601/AuroraFireworksstormRoiLevi1024.jpg"),
//            title: "Goldman Sacks",
//            explanation: "Quarterly results exceeded expectations with strong performance in the investment banking division.",
//            date: .now
//        )
//        RowView(
//            imageURL: URL(string: "https://picsum.photos/300"),
//            title: "Market Update",
//            explanation: "Tech sector continues to rally as investors rotate into growth equities.",
//            date: .now.addingTimeInterval(-86_400)
//        )
//    }
//    .padding()
//    .background(Color(.systemBackground))
}

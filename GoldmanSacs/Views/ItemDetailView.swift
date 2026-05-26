//
//  ItemDetailView.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 03/05/26.
//

import SwiftUI

struct ItemDetailView: View {
    let item: GSItems
    let image: UIImage?

    private var paragraphs: [String] {
        (item.explanation ?? "")
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.title ?? "Untitled")
                    .font(.title)
                    .bold()
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                        .background(Color.gray.opacity(0.1))
                }
            }
            .padding(.horizontal, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Description")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Divider()
                    
                    ForEach(paragraphs, id: \.self) { paragraph in
                        Text("\t" + paragraph + ".")
                            .font(.system(size: 16))
                            .lineSpacing(6)
                            .foregroundColor(.primary)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
//    ItemDetailView()
}

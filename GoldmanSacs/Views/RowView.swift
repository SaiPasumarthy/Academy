import SwiftUI

struct RowView: View {
    let image: UIImage?
    let title: String
    let explanation: String
    let date: Date
    let onAppear: () -> Void

    private let avatarSize: CGFloat = 50

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            HStack(alignment: .center, spacing: 12) {
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: avatarSize, height: avatarSize)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color(.separator), lineWidth: 0.5)
                            )
                    } else {
                        ZStack {
                            Circle().fill(Color.gray.opacity(0.15))
                            ProgressView()
                                .tint(.secondary)
                        }
                        .frame(width: avatarSize, height: avatarSize)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    Spacer()
                }
            }
            .padding(12)

            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding(.horizontal, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .onAppear {
            onAppear()
        }
    }
}

import SwiftUI
import CryptoKit

// MARK: - Main Flyer View

struct FlyerView: View {
    let document: FlyerDocument

    private var referenceID: String {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(document) {
            let digest = SHA256.hash(data: data)
            let hex = digest.map { String(format: "%02x", $0) }.joined()
            return String(hex.prefix(8)).uppercased()
        }
        return "NOREF"
    }

    private var sortedElements: [FlyerElement] {
        document.elements.sorted { $0.zIndex < $1.zIndex }
    }

    private var scale: CGFloat {
        // Scale from point-based layout (612x792) to screen width
        // We'll compute this dynamically based on available width
        1.0
    }

    var body: some View {
        GeometryReader { geometry in
            let pageWidth = document.page.widthPt
            let pageHeight = document.page.heightPt
            let displayScale = geometry.size.width / pageWidth

            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    // Page background
                    Rectangle()
                        .fill(Color(hex: document.page.backgroundColor))
                        .frame(
                            width: pageWidth * displayScale,
                            height: pageHeight * displayScale
                        )

                    // Render each element
                    ForEach(sortedElements) { element in
                        ElementView(element: element, scale: displayScale)
                            .position(
                                x: (element.x + element.width / 2) * displayScale,
                                y: (element.y + element.height / 2) * displayScale
                            )
                    }
                }
                .frame(
                    width: pageWidth * displayScale,
                    height: pageHeight * displayScale
                )
                .overlay(alignment: .topTrailing) {
                    Text("Ref: \(referenceID)")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(8)
                }
            }
        }
    }
}

// MARK: - Element Renderer

struct ElementView: View {
    let element: FlyerElement
    let scale: CGFloat

    var body: some View {
        Group {
            switch element.type {
            case .shape:
                ShapeElementView(element: element, scale: scale)
            case .text:
                TextElementView(element: element, scale: scale)
            case .image:
                ImageElementView(element: element, scale: scale)
            }
        }
        .frame(
            width: element.width * scale,
            height: element.height * scale
        )
        .rotationEffect(.degrees(element.rotation))
        .opacity(element.opacity)
    }
}

// MARK: - Shape Element

struct ShapeElementView: View {
    let element: FlyerElement
    let scale: CGFloat

    var body: some View {
        let radius = (element.borderRadius ?? 0) * scale
        let fillColor = element.fillColor ?? "#000000"
        let strokeCol = element.strokeColor ?? "transparent"
        let strokeW = (element.strokeWidth ?? 0) * scale

        RoundedRectangle(cornerRadius: radius)
            .fill(Color(hex: fillColor))
            .overlay(
                Group {
                    if strokeCol != "transparent" && strokeW > 0 {
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(Color(hex: strokeCol), lineWidth: strokeW)
                    }
                }
            )
    }
}

// MARK: - Text Element

struct TextElementView: View {
    let element: FlyerElement
    let scale: CGFloat

    private var alignment: TextAlignment {
        switch element.textAlign {
        case "center": return .center
        case "right": return .trailing
        default: return .leading
        }
    }

    private var frameAlignment: Alignment {
        switch element.textAlign {
        case "center": return .center
        case "right": return .trailing
        default: return .leading
        }
    }

    private var fontWeight: Font.Weight {
        switch element.fontWeight {
        case "bold": return .bold
        case "semibold": return .semibold
        case "light": return .light
        default: return .regular
        }
    }

    var body: some View {
        let fontSize = (element.fontSize ?? 16) * scale
        let textColor = element.color ?? "#000000"

        Text(element.content ?? "")
            .font(.system(size: fontSize, weight: fontWeight))
            .if(element.fontStyle == "italic") { view in
                view.italic()
            }
            .underline(element.underline ?? false)
            .foregroundColor(Color(hex: textColor))
            .multilineTextAlignment(alignment)
            .lineSpacing(fontSize * ((element.lineHeight ?? 1.2) - 1.0))
            .frame(
                width: element.width * scale,
                height: element.height * scale,
                alignment: frameAlignment
            )
            .minimumScaleFactor(0.5)
    }
}

// MARK: - Image Element

struct ImageElementView: View {
    let element: FlyerElement
    let scale: CGFloat

    var body: some View {
        let radius = (element.borderRadius ?? 0) * scale
        let borderCol = element.borderColor ?? "transparent"
        let borderW = (element.borderWidth ?? 0) * scale

        AsyncImage(url: URL(string: element.src ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: element.width * scale,
                        height: element.height * scale
                    )
                    .clipped()
            case .failure:
                // Show a placeholder with the product name from nearby elements
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30 * scale))
                            .foregroundColor(.gray)
                    )
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        ProgressView()
                    )
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: radius))
        .overlay(
            Group {
                if borderCol != "transparent" && borderW > 0 {
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color(hex: borderCol), lineWidth: borderW)
                }
            }
        )
    }
}

// MARK: - View Extension for Conditional Modifier

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview

#Preview {
    if let doc = loadFlyerDocument() {
        FlyerView(document: doc)
    } else {
        // Preview with sample data for development
        Text("No flyer data found")
    }
}

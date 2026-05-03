import SwiftUI
import Foundation

// MARK: - Flyer Document

struct FlyerDocument: Codable {
    let version: Int
    let name: String
    let page: FlyerPage
    let elements: [FlyerElement]
}

struct FlyerPage: Codable {
    let sizeName: String
    let widthPt: CGFloat
    let heightPt: CGFloat
    let backgroundColor: String
}

// MARK: - Flyer Element

struct FlyerElement: Codable, Identifiable {
    let id: String
    let type: ElementType
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let rotation: CGFloat
    let zIndex: Int
    let opacity: Double

    // Shape properties
    let shapeKind: String?
    let fillColor: String?
    let strokeColor: String?
    let strokeWidth: CGFloat?
    let borderRadius: CGFloat?

    // Text properties
    let content: String?
    let fontFamily: String?
    let fontSize: CGFloat?
    let fontWeight: String?
    let fontStyle: String?
    let underline: Bool?
    let color: String?
    let backgroundColor: String?
    let textAlign: String?
    let lineHeight: CGFloat?

    // Image properties
    let src: String?
    let borderColor: String?
    let borderWidth: CGFloat?

    enum ElementType: String, Codable {
        case shape
        case text
        case image
    }
}

// MARK: - Color Parsing

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - JSON Loading

func loadFlyerDocument() -> FlyerDocument? {
    // Try multiple approaches to find the JSON file in the bundle
    let filename = "mexican_grocery_flyer.flyerbuddy"

    // Approach 1: Standard resource lookup
    if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
        if let data = try? Data(contentsOf: url) {
            return try? JSONDecoder().decode(FlyerDocument.self, from: data)
        }
    }

    // Approach 2: Search for any .flyerbuddy.json file in the bundle
    if let resourceURL = Bundle.main.resourceURL {
        let fileManager = FileManager.default
        if let enumerator = fileManager.enumerator(at: resourceURL, includingPropertiesForKeys: nil) {
            while let fileURL = enumerator.nextObject() as? URL {
                if fileURL.lastPathComponent.hasSuffix(".flyerbuddy.json") {
                    if let data = try? Data(contentsOf: fileURL) {
                        return try? JSONDecoder().decode(FlyerDocument.self, from: data)
                    }
                }
            }
        }
    }

    // Approach 3: Fallback to embedded sample data
    return sampleFlyerDocument()
}

// MARK: - Embedded Sample Data

func sampleFlyerDocument() -> FlyerDocument {
    FlyerDocument(
        version: 1,
        name: "Supermercado Janet Professional",
        page: FlyerPage(sizeName: "letter", widthPt: 612, heightPt: 792, backgroundColor: "#ffffff"),
        elements: [
            // Red header banner
            FlyerElement(id: "header-red", type: .shape, x: 0, y: 0, width: 612, height: 50, rotation: 0, zIndex: 10, opacity: 1, shapeKind: "rectangle", fillColor: "#d32f2f", strokeColor: "transparent", strokeWidth: 0, borderRadius: 0, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Header text
            FlyerElement(id: "header-text", type: .text, x: 0, y: 10, width: 612, height: 30, rotation: 0, zIndex: 11, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "¡GRAN INAUGURACIÓN!", fontFamily: "Arial", fontSize: 28, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Store name
            FlyerElement(id: "store-name", type: .text, x: 0, y: 55, width: 612, height: 50, rotation: 0, zIndex: 6, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "SUPERMERCADO JANET", fontFamily: "Arial", fontSize: 44, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#1b5e20", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // CARNES category header bg
            FlyerElement(id: "cat-meat-bg", type: .shape, x: 30, y: 110, width: 552, height: 30, rotation: 0, zIndex: 1, opacity: 1, shapeKind: "rectangle", fillColor: "#1b5e20", strokeColor: "transparent", strokeWidth: 0, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // CARNES text
            FlyerElement(id: "cat-meat-text", type: .text, x: 30, y: 115, width: 552, height: 20, rotation: 0, zIndex: 2, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "CARNES", fontFamily: "Arial", fontSize: 20, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Meat image 1
            FlyerElement(id: "item-meat-1", type: .image, x: 30, y: 150, width: 260, height: 180, rotation: 0, zIndex: 1, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: 8, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: "https://images.unsplash.com/photo-1551028150-64b9f398f678?auto=format&fit=crop&q=80&w=400", borderColor: "#eeeeee", borderWidth: 1),
            // Meat price tag 1 bg
            FlyerElement(id: "meat-tag-bg", type: .shape, x: 30, y: 150, width: 100, height: 40, rotation: 0, zIndex: 10, opacity: 1, shapeKind: "rectangle", fillColor: "#d32f2f", strokeColor: "#ffffff", strokeWidth: 2, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Meat price tag 1 text
            FlyerElement(id: "meat-tag-text", type: .text, x: 30, y: 158, width: 100, height: 25, rotation: 0, zIndex: 11, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "$5.99 lb", fontFamily: "Arial", fontSize: 20, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Meat label 1
            FlyerElement(id: "meat-label", type: .text, x: 30, y: 335, width: 260, height: 20, rotation: 0, zIndex: 3, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "Carne Asada Preparada", fontFamily: "Arial", fontSize: 16, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#000000", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Meat image 2
            FlyerElement(id: "item-meat-2", type: .image, x: 320, y: 150, width: 260, height: 180, rotation: 0, zIndex: 1, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: 8, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: "https://images.unsplash.com/photo-1603048588665-791ca8aea617?auto=format&fit=crop&q=80&w=400", borderColor: "#eeeeee", borderWidth: 1),
            // Meat price tag 2 bg
            FlyerElement(id: "meat-tag-bg-2", type: .shape, x: 320, y: 150, width: 100, height: 40, rotation: 0, zIndex: 10, opacity: 1, shapeKind: "rectangle", fillColor: "#d32f2f", strokeColor: "#ffffff", strokeWidth: 2, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Meat price tag 2 text
            FlyerElement(id: "meat-tag-text-2", type: .text, x: 320, y: 158, width: 100, height: 25, rotation: 0, zIndex: 11, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "$2.49 lb", fontFamily: "Arial", fontSize: 20, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Meat label 2
            FlyerElement(id: "meat-label-2", type: .text, x: 320, y: 335, width: 260, height: 20, rotation: 0, zIndex: 3, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "Pierna de Pollo Fresca", fontFamily: "Arial", fontSize: 16, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#000000", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // VEGETALES category header bg
            FlyerElement(id: "cat-veg-bg", type: .shape, x: 30, y: 370, width: 552, height: 30, rotation: 0, zIndex: 1, opacity: 1, shapeKind: "rectangle", fillColor: "#1b5e20", strokeColor: "transparent", strokeWidth: 0, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // VEGETALES text
            FlyerElement(id: "cat-veg-text", type: .text, x: 30, y: 375, width: 552, height: 20, rotation: 0, zIndex: 2, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "VEGETALES", fontFamily: "Arial", fontSize: 20, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Veg image 1 - Aguacates
            FlyerElement(id: "item-veg-1", type: .image, x: 30, y: 410, width: 170, height: 130, rotation: 0, zIndex: 1, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&q=80&w=400", borderColor: "#eeeeee", borderWidth: 1),
            // Veg tag 1 bg
            FlyerElement(id: "veg-tag-bg-1", type: .shape, x: 30, y: 410, width: 70, height: 30, rotation: 0, zIndex: 10, opacity: 1, shapeKind: "rectangle", fillColor: "#ffeb3b", strokeColor: "#1b5e20", strokeWidth: 2, borderRadius: 2, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Veg tag 1 text
            FlyerElement(id: "veg-tag-text-1", type: .text, x: 30, y: 415, width: 70, height: 20, rotation: 0, zIndex: 11, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "3/$1", fontFamily: "Arial", fontSize: 16, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#1b5e20", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Veg label 1
            FlyerElement(id: "veg-label-1", type: .text, x: 30, y: 545, width: 170, height: 20, rotation: 0, zIndex: 3, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "Aguacates", fontFamily: "Arial", fontSize: 14, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#000000", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Veg image 2 - Cilantro
            FlyerElement(id: "item-veg-2", type: .image, x: 220, y: 410, width: 170, height: 130, rotation: 0, zIndex: 1, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: "https://images.unsplash.com/photo-1588879460233-575186ae9045?auto=format&fit=crop&q=80&w=400", borderColor: "#eeeeee", borderWidth: 1),
            // Veg tag 2 bg
            FlyerElement(id: "veg-tag-bg-2", type: .shape, x: 220, y: 410, width: 70, height: 30, rotation: 0, zIndex: 10, opacity: 1, shapeKind: "rectangle", fillColor: "#ffeb3b", strokeColor: "#1b5e20", strokeWidth: 2, borderRadius: 2, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Veg tag 2 text
            FlyerElement(id: "veg-tag-text-2", type: .text, x: 220, y: 415, width: 70, height: 20, rotation: 0, zIndex: 11, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "2/$1", fontFamily: "Arial", fontSize: 16, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#1b5e20", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Veg label 2
            FlyerElement(id: "veg-label-2", type: .text, x: 220, y: 545, width: 170, height: 20, rotation: 0, zIndex: 3, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "Cilantro", fontFamily: "Arial", fontSize: 14, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#000000", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Veg image 3 - Jalapeños
            FlyerElement(id: "item-veg-3", type: .image, x: 412, y: 410, width: 170, height: 130, rotation: 0, zIndex: 1, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: "https://images.unsplash.com/photo-1592398553434-60e03e085c88?auto=format&fit=crop&q=80&w=400", borderColor: "#eeeeee", borderWidth: 1),
            // Veg tag 3 bg
            FlyerElement(id: "veg-tag-bg-3", type: .shape, x: 412, y: 410, width: 70, height: 30, rotation: 0, zIndex: 10, opacity: 1, shapeKind: "rectangle", fillColor: "#ffeb3b", strokeColor: "#1b5e20", strokeWidth: 2, borderRadius: 2, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Veg tag 3 text
            FlyerElement(id: "veg-tag-text-3", type: .text, x: 412, y: 415, width: 70, height: 20, rotation: 0, zIndex: 11, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "49¢ lb", fontFamily: "Arial", fontSize: 16, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#1b5e20", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Veg label 3
            FlyerElement(id: "veg-label-3", type: .text, x: 412, y: 545, width: 170, height: 20, rotation: 0, zIndex: 3, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "Jalapeños", fontFamily: "Arial", fontSize: 14, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#000000", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Hot food bar
            FlyerElement(id: "hot-bar", type: .shape, x: 30, y: 580, width: 552, height: 60, rotation: 0, zIndex: 1, opacity: 1, shapeKind: "rectangle", fillColor: "#f57c00", strokeColor: "#ffffff", strokeWidth: 2, borderRadius: 4, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Hot food text
            FlyerElement(id: "hot-text", type: .text, x: 30, y: 595, width: 552, height: 30, rotation: 0, zIndex: 2, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "¡COMIDA CALIENTE LISTA!", fontFamily: "Arial", fontSize: 24, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.2, src: nil, borderColor: nil, borderWidth: nil),
            // Footer green
            FlyerElement(id: "footer-green", type: .shape, x: 0, y: 680, width: 612, height: 112, rotation: 0, zIndex: 20, opacity: 1, shapeKind: "rectangle", fillColor: "#1b5e20", strokeColor: "transparent", strokeWidth: 0, borderRadius: 0, content: nil, fontFamily: nil, fontSize: nil, fontWeight: nil, fontStyle: nil, underline: nil, color: nil, backgroundColor: nil, textAlign: nil, lineHeight: nil, src: nil, borderColor: nil, borderWidth: nil),
            // Footer text
            FlyerElement(id: "footer-text", type: .text, x: 0, y: 700, width: 612, height: 60, rotation: 0, zIndex: 21, opacity: 1, shapeKind: nil, fillColor: nil, strokeColor: nil, strokeWidth: nil, borderRadius: nil, content: "123 Main Street, Fennville, MI 49408\nAbierto 8 AM - 9 PM | (555) 123-4567", fontFamily: "Arial", fontSize: 18, fontWeight: "bold", fontStyle: "normal", underline: false, color: "#ffffff", backgroundColor: "transparent", textAlign: "center", lineHeight: 1.4, src: nil, borderColor: nil, borderWidth: nil),
        ]
    )
}

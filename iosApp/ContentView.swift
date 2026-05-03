import SwiftUI

struct ContentView: View {
    private let document = loadFlyerDocument()

    var body: some View {
        Group {
            if let doc = document {
                FlyerView(document: doc)
            } else {
                ScrollView {
                    SupermercadoFlyerView()
                }
            }
        }
        .ignoresSafeArea(edges: .horizontal)
        .background(Color.white)
    }
}

// MARK: - Full Flyer Layout

struct SupermercadoFlyerView: View {
    // Brand colors
    private let redBanner = Color(hex: "#d32f2f")
    private let greenDark = Color(hex: "#1b5e20")
    private let greenMedium = Color(hex: "#2e7d32")
    private let yellowTag = Color(hex: "#ffeb3b")
    private let orangeBar = Color(hex: "#f57c00")
    private let starYellow = Color(hex: "#fdd835")

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            storeNameSection
            carnesSection
            vegetalesSection
            hotFoodBanner
            footerSection
        }
    }

    // MARK: - Header Banner
    private var headerSection: some View {
        ZStack {
            redBanner
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(starYellow)
                Text("¡GRAN INAUGURACIÓN!")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.white)
                Image(systemName: "star.fill")
                    .foregroundColor(starYellow)
            }
            .padding(.vertical, 10)
        }
    }

    // MARK: - Store Name
    private var storeNameSection: some View {
        VStack(spacing: 2) {
            Text("SUPERMERCADO")
                .font(.system(size: 38, weight: .black))
                .foregroundColor(greenDark)
            Text("JANET")
                .font(.system(size: 50, weight: .black))
                .foregroundColor(greenDark)
            Text("Fennville, Michigan")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }

    // MARK: - CARNES Section
    private var carnesSection: some View {
        VStack(spacing: 0) {
            // Category header
            categoryHeader(title: "CARNES", icon: "flame.fill")

            HStack(spacing: 10) {
                productCard(
                    name: "Carne Asada\nPreparada",
                    price: "$5.99",
                    unit: "/lb",
                    icon: "🥩",
                    tagColor: redBanner,
                    tagTextColor: .white
                )
                productCard(
                    name: "Pierna de\nPollo Fresca",
                    price: "$2.49",
                    unit: "/lb",
                    icon: "🍗",
                    tagColor: redBanner,
                    tagTextColor: .white
                )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color(hex: "#f5f5f5"))
    }

    // MARK: - VEGETALES Section
    private var vegetalesSection: some View {
        VStack(spacing: 0) {
            categoryHeader(title: "VEGETALES", icon: "leaf.fill")

            HStack(spacing: 8) {
                productCard(
                    name: "Aguacates",
                    price: "3/$1",
                    unit: "",
                    icon: "🥑",
                    tagColor: yellowTag,
                    tagTextColor: greenDark
                )
                productCard(
                    name: "Cilantro",
                    price: "2/$1",
                    unit: "",
                    icon: "🌿",
                    tagColor: yellowTag,
                    tagTextColor: greenDark
                )
                productCard(
                    name: "Jalapeños",
                    price: "49¢",
                    unit: "/lb",
                    icon: "🌶️",
                    tagColor: yellowTag,
                    tagTextColor: greenDark
                )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color.white)
    }

    // MARK: - Hot Food Banner
    private var hotFoodBanner: some View {
        ZStack {
            orangeBar
            HStack(spacing: 8) {
                Image(systemName: "frying.pan.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                Text("¡COMIDA CALIENTE LISTA!")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                Image(systemName: "frying.pan.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .padding(.vertical, 16)
        }
    }

    // MARK: - Footer
    private var footerSection: some View {
        ZStack {
            greenDark
            VStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 20))
                    .foregroundColor(starYellow)
                Text("123 Main Street, Fennville, MI 49408")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text("Abierto 8 AM - 9 PM")
                            .font(.system(size: 13, weight: .medium))
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 12))
                        Text("(555) 123-4567")
                            .font(.system(size: 13, weight: .medium))
                    }
                }
                .foregroundColor(Color.white.opacity(0.9))
            }
            .padding(.vertical, 20)
        }
    }

    // MARK: - Reusable Components

    private func categoryHeader(title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 14))
            Text(title)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 14))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(greenDark)
    }

    private func productCard(
        name: String,
        price: String,
        unit: String,
        icon: String,
        tagColor: Color,
        tagTextColor: Color
    ) -> some View {
        VStack(spacing: 6) {
            // Product icon area
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

                VStack {
                    Text(icon)
                        .font(.system(size: 50))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 90)

                // Price tag
                HStack(spacing: 0) {
                    Text(price)
                        .font(.system(size: 16, weight: .black))
                    Text(unit)
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(tagTextColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(tagColor)
                .cornerRadius(4)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                .padding(4)
            }
            .frame(height: 90)

            // Product name
            Text(name)
                .font(.system(size: 12, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
    }
}

#Preview {
    ContentView()
}

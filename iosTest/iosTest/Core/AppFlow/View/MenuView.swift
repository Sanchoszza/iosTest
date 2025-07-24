//
//  MenuView.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

struct MenuView: View {
    @StateObject var viewModel = MenuViewModel()
    @StateObject var viewModelAuth = AuthViewModel()
    
    @State private var showCityPicker = false
    @State private var selectedCity: String = NSLocalizedString("city", comment: "")
    @State private var searchText: String = ""
    @State private var selectedCategorySlug: String?
    
    @State private var scrollOffset: CGFloat = 0

    var filteredCities: [String] {
        if searchText.isEmpty {
            return viewModel.cities
        } else {
            return viewModel.cities.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    
    var body: some View {
        NavigationStack {
            menuFlow
        }
        .showToast(
            message: NSLocalizedString("authSaccess", comment: ""),
            color: Color.theme.colorWhite,
            textColor: Color.theme.accessColor,
            image: "accessCircle",
            isVisible: $viewModelAuth.isSuccessToastBarVisible
        )
    }
}

#Preview {
    MenuView()
}


extension MenuView {
    private var menuFlow: some View {
        VStack {
            categoriesFlow
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    showCityPicker = true
                }) {
                    HStack {
                        Text(selectedCity)
                            .font(.custom("SF UI Display", size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.theme.colorForSelector)
                        Image("arrowDown")
                            .foregroundStyle(Color.theme.colorForSelector)
                    }
                }
                .buttonStyle(ScaledButtonStyle())
                .popover(isPresented: $showCityPicker) {
                    listCity
                        .presentationBackground(.clear)
                        .padding(.horizontal)
                }

            }
        }
        .onAppear {
            viewModel.fetchCSV()
            Task {
                await viewModel.loadCategories()
                await viewModel.loadAllProducts()
                viewModelAuth.showSuccessToastIfNeeded()
            }
        }
       
    }
    
    private var listCity: some View {
        VStack(spacing: 12) {
            TextField(text: $searchText) {
                Text("Поиск города")
                    .font(.custom("SF UI Display", size: 13))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.theme.colorForBorders)
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .background(Color.theme.secondaryNavig)
            .foregroundStyle(Color.theme.colorForBorders)
            .cornerRadius(8)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(filteredCities, id: \.self) { city in
                        Button(action: {
                            selectedCity = city
                            showCityPicker = false
                        }) {
                            Text(city)
                                .foregroundColor(.primary)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.theme.secondaryNavig)
                                .foregroundStyle(Color.theme.accentColor)
                                .cornerRadius(8)
                        }
//                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
        )
    }
    
    private var addBanners: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(1...3, id: \.self) { index in
                    Image("addBanner")
                        .resizable()
                        .frame(width: 200, height: 100)
                        .cornerRadius(10)
//                        .padding(.horizontal, 5)
                }

            }
        }
        .frame(height: 130)
    }
    
    private var categoriesFlow: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 0)

                    if scrollOffset > -10 {
                        addBanners
                            .transition(.opacity)
                            .animation(.easeInOut, value: scrollOffset)
                    }
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: categoryHeader(proxy: proxy)) {
                            productList
                                .padding(.bottom, 20)
                                .padding(.horizontal)
//                                .padding(.vertical)
                                .background {
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color.theme.colorWhite)
                                        .mask(
                                            VStack(spacing: 0) {
                                                Rectangle()
                                            }
                                        )
                                        .ignoresSafeArea()
                                }
                        }
                    }

                    
                    
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .background(Color.theme.background)
            .onChange(of: selectedCategorySlug) { _, newCategory in
                guard let category = newCategory else { return }

                if let firstProduct = viewModel.allProducts.first(where: { $0.category == category }) {
                    withAnimation {
                        proxy.scrollTo("category-\(category)-\(firstProduct.id)", anchor: .top)
                    }
                }
            }
        }
    }

    private var productList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.allProducts) { product in
                productRow(product)
                    .id("category-\(product.category)-\(product.id)")
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.theme.dividerColor)
                    .padding(.bottom, 0)
            }
        }
    }


    @ViewBuilder
    private func categoryHeader(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
               

                ForEach(viewModel.categories) { category in
                    Button(category.name) {
                        selectedCategorySlug = category.slug
                        viewModel.selectCategory(category)
                        withAnimation {
                            proxy.scrollTo(category.slug, anchor: .top)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(selectedCategorySlug == category.slug ? Color.theme.accentColor40 : Color.theme.background)
                    .foregroundColor(selectedCategorySlug == category.slug ? Color.theme.accentColor : Color.theme.accentColor40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.theme.accentColor40, lineWidth: 1)
                            .opacity(selectedCategorySlug != category.slug ? 1.0 : 0.0)
                    )
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.theme.background)
        }
    }


    @ViewBuilder
    private func productRow(_ product: Product) -> some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 132, height: 132)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.custom("SF UI Display", size: 13))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.colorBlack)

                HStack {
                    Spacer()
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.custom("SF UI Display", size: 13))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.theme.accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.theme.colorWhite)
                                .stroke(Color.theme.accentColor, lineWidth: 1)
                        }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background{
            Color.theme.colorWhite
        }
        .cornerRadius(20)
            
    }

}

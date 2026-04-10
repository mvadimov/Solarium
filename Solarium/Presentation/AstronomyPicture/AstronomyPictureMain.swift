//
//  AstronomyPictureMain.swift
//  Solarium
//
//  Created by Mark Vadimov on 8.04.26.
//

import SwiftUI

struct AstronomyPictureMain: View {
    @EnvironmentObject var apViewModel: AstronomyPictureViewModel
    var body: some View {
        VStack{
            if apViewModel.astronomy.isEmpty {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    
                    Text("Loading...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.8))
                
            } else {
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(apViewModel.astronomy, id: \.model.id) { item in
                        PostItem(dataOfImage: item.model)
                            .onTapGesture {
                                apViewModel.selectedAstronomy = item
                            }
                    }
                }
            }
        }
        .background(Image("moon"))
        .task {
            if apViewModel.astronomy.isEmpty{
                apViewModel.loadData()
            }
        }
    }
}

struct PostItem: View {
    var dataOfImage: AstronomyPictureModel
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(dataOfImage.title ?? "No title")
                        .font(.system(size: 26, weight: .semibold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    Spacer()
                }
                
                Text(dataOfImage.date)
                    .font(.system(size: 20, weight: .light))
                
                Text(dataOfImage.copyright ?? "No copyright")
                    .font(.system(size: 18, weight: .light))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.gray.opacity(0.8))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    AstronomyPictureMain()
        .environmentObject(AstronomyPictureViewModel())
}

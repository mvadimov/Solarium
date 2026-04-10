//
//  AstronomyPictureView.swift
//  Solarium
//
//  Created by Mark Vadimov on 1.04.26.
//

import SwiftUI
import Combine

struct AstronomyPictureView: View {
    @EnvironmentObject var apViewModel: AstronomyPictureViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                Text(apViewModel.selectedAstronomy?.model.title ?? "No title")
                    .font(.system(size: 30))
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                
                
                Image(uiImage: apViewModel.selectedAstronomy?.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding(.horizontal, 20)
                
                Text(apViewModel.selectedAstronomy?.model.explanation ?? "No explanation")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 15))
                    .fontWeight(.light)
                    .padding(.horizontal, 15)
                
                
                if let cop = apViewModel.selectedAstronomy?.model.copyright {
                    let year = apViewModel.selectedAstronomy?.model.date.prefix(4)
                    
                    Text("Copyright © \(String(describing: year)) | \(cop)")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.white)
                        .frame(width: 300, height: 40, alignment: .center)
                }

            }
        }
        .background(Color(UIColor.darkGray))
    }
}

//
//  ContentView.swift
//  Solarium
//
//  Created by Mark Vadimov on 30.03.26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var apViewModel: AstronomyPictureViewModel
    @EnvironmentObject var mwViewModel: MarsWeatherViewModel
    var body: some View {
        VStack {
            Text("The Weather on Mars")
                .foregroundStyle(Color.white)
                .font(Font.system(size: 25).bold())
                
            Rectangle()
                .frame(width: 300, height: 1)
                .foregroundStyle(Color.white)
                .padding(.bottom, 20)
            
            VStack{
                Image("Mars")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                
                Rectangle()
                    .frame(width: 75, height: 45)
                    .foregroundStyle(Color.orangeBgInfo)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
        .background(Color.black)
        .task {
            <#code#>
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
        .environmentObject(AstronomyPictureViewModel())
        .environmentObject(MarsWeatherViewModel())
}

//
//  ContentView.swift
//  Solarium
//
//  Created by Mark Vadimov on 30.03.26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var apViewModel = AstronomyPictureViewModel()
    @StateObject private var mvViewModel = MarsWeatherViewModel()
    @State private var selectedTab = 2
    var body: some View {
        VStack{
            if apViewModel.selectedAstronomy == nil {
                TabView {
                    AstronomyPictureMain().environmentObject(apViewModel)
                        .tabItem {
                            Label("Astronomy Picture", systemImage: "moon.stars")
                        }
                        .tag(1)
                    
                    MarsWeatherView().environmentObject(mvViewModel)
                        .tabItem {
                            Label("Mars Weather", systemImage: "globe.europe.africa.fill")
                        }
                        .tag(2)
                }
                .onAppear{
                    selectedTab = 2
                }
            } else {
                ZStack{
                    AstronomyPictureView().environmentObject(apViewModel)

                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    ContentView()
}

//
//  MarsWeatherView.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import SwiftUI
import Combine
import SceneKit

struct MarsWeatherView: View {
    @EnvironmentObject var mwViewModel: MarsWeatherViewModel
    @State private var rotationAngle: Float = 0
    var body: some View {
        VStack(spacing: 20) {
            Text("Mars Weather")
                .foregroundStyle(Color.white)
                .font(Font.system(size: 25).bold())
            
            MarsSceneView(rotationAngle: $rotationAngle)
                .frame(height: 350)
                .onAppear {
                    rotationAngle += .pi * 1.5
                }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(convertMarsWeather(from: mwViewModel.weather)) { sol in
                        GeometryReader { geometry in
                            InfoFieldView(solNum: sol.solNum, temperature: sol.tempeture, pressure: sol.pressure, speedWind: sol.windSpeed, season: sol.season)
                                .rotation3DEffect(
                                    Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -20),
                                    axis: (x: 0, y: 10, z: 0)
                                )
                        }
                        .frame(width: 275, height: 300)
                    }
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .background(Image("bg-stars"))
        .task {
            mwViewModel.loadData()
        }
    }
    
    func convertMarsWeather(from data: MarsWeatherAPI) -> [MarsWeatherModel] {
        var models = [MarsWeatherModel]()
        
        for solKey in data.solKeys {
            guard let solData = data.sols[solKey] else { continue }
            
            let model = MarsWeatherModel(
                solNum: Int(solKey) ?? 0,
                tempeture: solData.at.av,
                windSpeed: solData.hws.av,
                pressure: solData.pre.av,
                season: solData.season
            )
            
            models.append(model)
        }
        
        return models.sorted { $0.solNum < $1.solNum }
    }
}

#Preview {
    MarsWeatherView().environmentObject(MarsWeatherViewModel())
}

struct InfoFieldView: View {
    var solNum: Int
    var temperature: Double
    var pressure: Double
    var speedWind: Double
    var season: String
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline){
                Text("SOL: ")
                    .foregroundStyle(Color.white.opacity(0.75))
                    .font(Font.system(size: 17).bold())
                    .padding(.top, 10)
                
                Text("\(solNum)")
                    .foregroundStyle(Color.white)
                    .font(Font.system(size: 25).bold())
                    .padding(.top, 10)
            }
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 225, height: 1)
                .padding(.bottom, 15)
            
            HStack(spacing: 10) {
                InfoColumnView(
                    iconName: "thermometer.transmission",
                    value: temperature,
                    unit: "°C",
                    title: "Temp"
                )
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 1, height: 75)
                
                InfoColumnView(
                    iconName: "barometer",
                    value: pressure,
                    unit: "hpa",
                    title: "Pressure"
                )
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 1, height: 75)
                
                InfoColumnView(
                    iconName: "wind",
                    value: speedWind,
                    unit: "km/h",
                    title: "Wind"
                )
            }
            .padding([.bottom, .horizontal], 15)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 225, height: 1)
                .padding(.bottom, 15)
            
            HStack(alignment: .lastTextBaseline){
                Text("Season: ")
                    .foregroundStyle(Color.white.opacity(0.75))
                    .font(Font.system(size: 17).bold())
                
                Text((season.lowercased() == "fall" ? "Autumn" : season).capitalized)
                    .foregroundStyle(Color.white)
                    .font(Font.system(size: 25).bold())
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.orangeBgInfo)
        .cornerRadius(15)
    }
}

struct InfoColumnView: View {
    let iconName: String
    let value: Double
    let unit: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 27, height: 27)
                .foregroundStyle(Color.white)
                .padding(.bottom, 7)
            
            HStack(alignment: .lastTextBaseline, spacing: 2){
                Text(String(format: "%.1f", value))
                    .foregroundStyle(Color.white)
                    .font(Font.system(size: 18).bold())
                
                Text(unit)
                    .foregroundStyle(Color.white)
                    .font(Font.system(size: 13))
                    .fontWeight(.medium)
            }
            
            Text(title)
                .foregroundStyle(Color.white.opacity(0.7))
                .font(Font.system(size: 13))
                .fontWeight(.medium)
        }
    }
}

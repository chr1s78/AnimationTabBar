//
//  MyTestView.swift
//  AnimationTabBar
//
//  Created by 吕博 on 2021/7/31.
//

import SwiftUI

struct MyTestView: View {
    var body: some View {
        HomeView()
    }
}

struct MyTestView_Previews: PreviewProvider {
    static var previews: some View {
      //  MyTestView()
        
        HomeView()
    }
}

struct HomeView: View {
    
    @State var selectedtab = "house"
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // Location For each Curve...
    @State var xAxis: CGFloat = 0
    
    @Namespace var animation
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedtab) {
                
                Color.purple
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("home")
                
                Color.yellow
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("gift")
                
                Color.blue
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("bell")
                
                Color.orange
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("message")
            }
            
            // Custom tab Bar...
            
            HStack(spacing: 0) {
                
                ForEach(tabitem, id: \.self) { image in
                    
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedtab = image
                                xAxis = reader.frame(in: .global).minX
                                print("xAxis: \(xAxis)")
                                print("geometry frame: \(reader.frame(in: .global))")
                            }
                        }, label: {
                            
                            
                            Image(systemName: image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedtab == image ? getColor(image: image) : Color.gray)
                                .padding(selectedtab == image ? 15 : 0)
                                .background(Color.white.opacity(selectedtab == image ? 1 : 0) .clipShape(Circle()))
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedtab == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0, y: selectedtab == image ? -50 : 0)
                            
                        })
                        .onAppear(perform: {
                            if image == tabitem.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25, height: 30)
                    
                    if image != tabitem.last{Spacer(minLength: 0)}
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color.white.clipShape(CustomTabShape(xAxis: xAxis)).cornerRadius(12))
            .padding(.horizontal)
            // Bottom Edge ...
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    // getting Image Color ...
    
    func getColor(image: String) -> Color {
        
        switch image {
        case "house":
            return Color.purple
        case "gift":
            return Color.yellow
        case "bell":
            return Color.blue
        case "message":
            return Color.orange
        default:
            return Color.black
        }
    }
}

var tabitem = ["house", "gift", "bell", "message"]

// Curve ...

struct CustomTabShape: Shape {
    
    var xAxis: CGFloat
    var deepY: CGFloat = 35
    var deepX: CGFloat = 25
    
    var animatableData: CGFloat {
        get { return xAxis }
        set { xAxis = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
        
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: deepY)
            let control1 = CGPoint(x: center - deepX, y: 0)
            let control2 = CGPoint(x: center - deepX, y: deepY)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + deepX, y: deepY)
            let control4 = CGPoint(x: center + deepX, y: 0)
            
            print("to1: \(to1) co1: \(control1) co2: \(control2)")
            print("to2: \(to2) co3: \(control3) co4: \(control4)")
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}


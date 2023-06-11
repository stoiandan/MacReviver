//
//  ContentView.swift
//  MacReviver
//
//  Created by Dan Stoian on 06.06.2023.
//

import SwiftUI


struct MainView: View {
    @Bindable var model = MainViewModel()
    
    var body: some View {
        if !model.errorMessae.isEmpty {
            Text(model.errorMessae)
        } else {
            mainBody
                .task {
                    await model.fetchHardwareVersions()
                }
        }
    }
    
    
    var mainBody: some View {
        NavigationSplitView(sidebar: {
            List(selection: $model.selectedSwVersion) {
                DisclosureGroup(
                    content: {
                        ForEach(model.hardwareVersions) { hwVersion in
                            DisclosureGroup(content: {
                                ForEach(hwVersion.versions) { swVersion in
                                    Text(swVersion.build)
                                        .tag(swVersion)
                                }
                            }, label: {
                                Label(hwVersion.name, systemImage: "cart.circle.fill")
                                
                            })
                        }
                    },
                    label: { Label("Mac Firmware", systemImage: "apple.logo") }
                )
            }.listStyle(.sidebar)
            
            Spacer()
        }, detail: {
            if let _ = model.selectedSwVersion {
                DetailSoftwareView(viewModel: model.detailViewModel)
            } else {
                Text("Please select a firmware")
            }
        })
    }
}



#Preview {
    MainView()
}

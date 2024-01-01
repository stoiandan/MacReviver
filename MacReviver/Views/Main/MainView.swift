//
//  ContentView.swift
//  MacReviver
//
//  Created by Dan Stoian on 06.06.2023.
//

import SwiftUI


struct MainView: View {
    @Bindable var model = MainViewModel()
    @State var autoDetectionFailed = false
    
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
                if autoDetectionFailed == false && model.autoDetectedViewModel == nil {
                    Text("Trying to auto-detect hardware...")
                        .font(.headline)
                }
                if let vm = model.autoDetectedViewModel {
                    VStack{
                        Text("This image was autoamtically detected based on your hardware").font(.subheadline)
                            .padding()
                        Spacer()
                        DetailSoftwareView(viewModel: vm)
                        Spacer()
                    }
                }
                if autoDetectionFailed == true {
                    Text("Could not automatically detect hardware").font(.headline)
                    Text("Please manually select your firmware").font(.subheadline)
                }

            }
        }).task {
            let vm = await autoDetect()
            if vm == nil {
                autoDetectionFailed = true
            }
            model.autoDetectedViewModel = vm
        }
    }
}



#Preview {
    MainView()
}

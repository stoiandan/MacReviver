//
//  DetailSoftwareView.swift
//  MacReviver
//
//  Created by Dan Stoian on 10.06.2023.
//

import SwiftUI

struct DetailSoftwareView: View {
    var viewModel: DetailSoftwareViewModel
    
    var body: some View {
        VStack {
            switch viewModel.donwloadState {
            case .finished, .notStarted:
                Image(systemName: .finished == viewModel.donwloadState ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                    .resizable()
                    .foregroundColor(.finished == viewModel.donwloadState ? .green : .primary)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .onTapGesture(perform: viewModel.download)
                if viewModel.donwloadState == .finished {
                    Text("Download Finished successfully and SHA1 hashes match!")
                }
            case .inProgress(let progressValue):
                ProgressView(value: progressValue,total: 1) {
                    Text("Downloading... \(Int(progressValue*100))%")
                }
                .progressViewStyle(.circular)
                
            case .error(let errorMessage):
                Text(errorMessage)
                    .font(.subheadline)
                    .background(.red)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                LabeledContent("", content: {
                    HStack {
                        Image(systemName: "hammer.circle")
                            .foregroundColor(viewModel.copiedState == .build ? .green : .primary)
                        Text("Build: \(viewModel.softwareVersion.build)")
                    }
                })
                .onTapGesture {
                    viewModel.copyToClipboard(keyPath: \.build)
                }
                if let firmwareSHA1 = viewModel.softwareVersion.firmwareSHA1 {
                    LabeledContent("", content: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(viewModel.copiedState == .sha ? .green : .primary)
                            Text("SHA1: \(firmwareSHA1)")
                        }
                    })
                    .onTapGesture {
                        viewModel.copyToClipboard(keyPath: \.firmwareSHA1!)
                    }
                }
                
                LabeledContent("", content: {
                    HStack {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(viewModel.copiedState == .url ? .green : .primary)
                        Text("Download URL: \(viewModel.softwareVersion.firmwareURL)")
                    }
                })
                .onTapGesture {
                    viewModel.copyToClipboard(keyPath: \.firmwareURL)
                }
                
            }.padding()
        }
    }
}

#Preview {
    DetailSoftwareView(viewModel: DetailSoftwareViewModel( SoftwareVersion(build: "2HFFv", firmwareSHA1: "1231fsdfsdr32rfsdfds", firmwareURL: "https://cdn.net.apple.com")))
}

//
//  DetailSoftwareView.swift
//  MacReviver
//
//  Created by Dan Stoian on 10.06.2023.
//

import SwiftUI

struct DetailSoftwareView: View {
    @Bindable var viewModel: DetailSoftwareViewModel
    
    var body: some View {
        if !gviewModel.donwloadState.isDownloading()  {
            Group {
                Image(systemName: .finished == viewModel.donwloadState ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                    .resizable()
                    .foregroundColor(.finished == viewModel.donwloadState ? .green : .primary)
                    .frame(maxWidth: 100, maxHeight: 100)
                
                Text(.finished == viewModel.donwloadState ? "Download Finished successfully and SHA1 hashes match!" : "Click to download firmware")
            }
            .onTapGesture(perform: .finished == viewModel.donwloadState ? {} : viewModel.download)
        }
        
        VStack {
            switch viewModel.donwloadState {
            case .finished, .notStarted:
                EmptyView()
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
                LabelView(viewModel: viewModel.labelViewModel(forKeyPath: \.build, withTitle: "Build: ", icon: "hammer.circle"), copiedState: $viewModel.copiedState)

                if let firmwareSHA1 =
                    viewModel.softwareVersion.firmwareSHA1 {
                    LabelView(viewModel: viewModel.labelViewModel(forKeyPath: \.firmwareSHA1!, withTitle: "SHA1: ", icon: "checkmark.circle.fill"), copiedState: $viewModel.copiedState)
                }
                
                LabelView(viewModel: viewModel.labelViewModel(forKeyPath: \.firmwareURL, withTitle: "Download URL", icon: "link.circle.fill"), copiedState: $viewModel.copiedState)
                
            }.padding()
        }
    }
}

#Preview {
    DetailSoftwareView(viewModel: DetailSoftwareViewModel( SoftwareVersion(build: "2HFFv", firmwareSHA1: "1231fsdfsdr32rfsdfds", firmwareURL: "https://cdn.net.apple.com")))
}

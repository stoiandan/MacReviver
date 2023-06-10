//
//  DetailSoftwareView.swift
//  MacReviver
//
//  Created by Dan Stoian on 10.06.2023.
//

import SwiftUI

struct DetailSoftwareView: View {
    let viewModel: DetailSoftwareViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "square.and.arrow.down.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .onTapGesture {
                    if viewModel.isDownloading {
                        return
                    }
                    
                    viewModel.isDownloading.toggle()
                    viewModel.download()
                }
            if viewModel.isDownloading {
                ProgressView(value: viewModel.progress)
            }
            VStack(alignment: .leading, spacing: 10) {
                Label("Build: \(viewModel.softwareVersion.build)", systemImage: "hammer.circle")
                if let firmwareSHA1 = viewModel.softwareVersion.firmwareSHA1 {
                    Label("SHA1: \(firmwareSHA1)", systemImage: "checkmark.circle.fill")
                }
                Label("Download URL: \(viewModel.softwareVersion.firmwareURL)", systemImage: "link.circle.fill")

            }.padding()
        }
    }
}

#Preview {
    DetailSoftwareView(viewModel: DetailSoftwareViewModel( SoftwareVersion(build: "2HFFv", firmwareSHA1: "1231fsdfsdr32rfsdfds", firmwareURL: "https://cdn.net.apple.com")))
}

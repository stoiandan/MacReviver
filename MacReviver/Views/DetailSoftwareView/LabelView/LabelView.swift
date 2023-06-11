//
//  LabelView.swift
//  MacReviver
//
//  Created by Dan Stoian on 11.06.2023.
//

import SwiftUI

struct LabelView: View {
    let viewModel: LabelViewModel
    @Binding var copiedState: CopiedState
    @State private var isTapped = false

    var body: some View {
        LabeledContent("", content: {
            HStack {
                Image(systemName: viewModel.iconName)
                    .foregroundColor(copiedState == viewModel.copiedState ? .green : .primary)
                    .scaleEffect(isTapped ? 1.5 : 1.0)
                Text("\(viewModel.title): \(viewModel.value)")
            }
            .font(.system(size: 15))
        })
        .onTapGesture {
            viewModel.tapGestureCallback()
            withAnimation {
                isTapped.toggle()
            }
            isTapped.toggle()
        }
    }
}

#Preview {
    LabelView(viewModel: LabelViewModel(iconName: "circle.fill", tapGestureCallback: {}, title: "Some Title", value: "this or that", copiedState: .url ), copiedState: .constant(.build))
}

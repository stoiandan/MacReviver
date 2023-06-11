//
//  LabelViewModel.swift
//  MacReviver
//
//  Created by Dan Stoian on 11.06.2023.
//

import Foundation


struct LabelViewModel {
    let iconName: String
    let tapGestureCallback: () -> ()
    let title: String
    let value: String
    let copiedState: CopiedState
}

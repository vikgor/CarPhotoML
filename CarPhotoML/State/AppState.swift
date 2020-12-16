//
//  AppState.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 11/29/20.
//

import ReSwift

struct AppState: StateType {
    var viewTitle: ViewState = .main
    var photoPickerState: PhotoPickerState = .none
    var resultText: ResultLabelState = .pickPhoto
}

enum ViewState: String {
    case main = "Photo analyzer"
    case info = "Info"
}

enum PhotoPickerState: Equatable {
    case camera
    case photoLibrary
    case none
}

enum ResultLabelState: String {
    case pickPhoto = "Upload car photo"
    case camera = "It's camera"
    case photoLibrary = "It's picker"
}

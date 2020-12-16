//
//  CarPhotoReducer.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 11/29/20.
//

import ReSwift

func carPhotoReducer(action: Action, state: AppState?) -> AppState {
    
    var state = state ?? AppState()
    
    switch action {
    case _ as TakePhoto:
        state.photoPickerState = .camera
        state.resultText = .camera
    case _ as PickPhoto:
        state.photoPickerState = .photoLibrary
        state.resultText = .photoLibrary
    default:
        state.photoPickerState = .none
        state.resultText = .pickPhoto
        break
    }
    
    return state
}

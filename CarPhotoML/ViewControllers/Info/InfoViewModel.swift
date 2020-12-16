//
//  InfoViewModel.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 12/17/20.
//

import Foundation

struct InfoViewModel {
    static let infoViewTitle = "Info"
    static let label1Text = "A ML-model driven feature to test car photos in driver verification procedure. \nThe photo is considered 'good' when it's a front photo of a car, with the license plate. \nThe photo is considered 'bad' in any other case."
    static let label2Text = "The model was trained with CreateML on 300 real-life examples and is accurate in 75% of test cases. In other 25% only 5% is when a bad photo goes through the check instead of getting marked as bad which means those photos won't reach human verification until they are considered good by the model."
    
    static let findOutMore = "Find out more"
}

//
//  MainPresenter.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 2/2/20.
//  Copyright © 2020 on3. All rights reserved.
//

import UIKit

class MainPresenter {
    
    weak var viewController: MainViewController?
    
    func setupButtonStyle(button: UIButton) {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    
}

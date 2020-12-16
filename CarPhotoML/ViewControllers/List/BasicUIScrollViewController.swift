//
//  InfoViewController.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 12/16/20.
//

import UIKit

final class InfoViewController: UIViewController {
    
    static let label1Text = "A ML-model driven feature to test car photos in driver verification procedure. The photo is considered 'good' when it's a front photo of a car, with the license plate. The photo is considered 'bad' in any other case."
    static let label2Text = "The model was trained with CreateML on 300 real-life examples and is accurate in 75% of test cases. In other 25% only 5% is when a bad photo goes through the check instead of getting marked as bad which means those photos won't reach human verification until they are considered good by the model."
    
    private var didSetupConstraints = false
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let goodImageView = UIImageView(image: UIImage(named: "carPhotoGood"))
    private let badImageView = UIImageView(image: UIImage(named: "carPhotoBad"))
    
    private let infoLabel1: UILabel = {
        let label = UILabel()
        label.text = InfoViewController.label1Text
        return label
    }()
    
    private let infoLabel2: UILabel = {
        let label = UILabel()
        label.text = InfoViewController.label2Text
        return label
    }()
    
    private let goodImageIconLabel: UILabel = {
        let label = UILabel()
        label.text = "✅"
        return label
    }()
    
    private let badImageIconLabel: UILabel = {
        let label = UILabel()
        label.text = "❌"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let iconsStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupStyles()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsets.zero)
            }

            contentView.snp.makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsets.zero)
                make.width.equalTo(scrollView)
            }

            infoLabel1.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
            }

            stackView.snp.makeConstraints { make in
                make.top.equalTo(infoLabel1.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
            }
            
            infoLabel2.snp.makeConstraints { make in
                make.top.equalTo(stackView.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
                make.bottom.equalTo(contentView).inset(20)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

private extension InfoViewController {
    func setupSubviews() {
        view.addSubview(scrollView)
        imagesStackView.addArrangedSubview(goodImageView)
        imagesStackView.addArrangedSubview(badImageView)
        iconsStackView.addArrangedSubview(goodImageIconLabel)
        iconsStackView.addArrangedSubview(badImageIconLabel)
        stackView.addArrangedSubview(imagesStackView)
        stackView.addArrangedSubview(iconsStackView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(infoLabel1)
        contentView.addSubview(stackView)
        contentView.addSubview(infoLabel2)
        view.setNeedsUpdateConstraints()
    }
    
    func setupStyles() {
        view.backgroundColor = UIColor.green
        contentView.backgroundColor = UIColor.lightGray
        
        _ = [goodImageView, badImageView].map {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        _ = [goodImageIconLabel, badImageIconLabel].map {
            $0.textAlignment = .center
        }
        
        _ = [infoLabel1, infoLabel2].map {
            $0.backgroundColor = .blue
            $0.numberOfLines = 0
            $0.lineBreakMode = .byClipping
            $0.textColor = .white
            $0.numberOfLines = 0
        }
        
        _ = [imagesStackView, iconsStackView].map {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
    }
}

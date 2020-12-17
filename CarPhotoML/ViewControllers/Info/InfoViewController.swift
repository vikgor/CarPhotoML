//
//  InfoViewController.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 12/16/20.
//

import UIKit
import SnapKit

final class InfoViewController: UIViewController {
    
    private var didSetupConstraints = false
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let goodImageView = UIImageView(image: UIImage(named: "carPhotoGood"))
    private let badImageView = UIImageView(image: UIImage(named: "carPhotoBad"))
    
    private let infoLabelPart1: UILabel = {
        let label = UILabel()
        label.text = StringValues.label1Text
        return label
    }()
    
    private let infoLabelPart2: UILabel = {
        let label = UILabel()
        label.text = StringValues.label2Text
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
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
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
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringValues.findOutMore, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupStyles()
        
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
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
            
            infoLabelPart1.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
            }
            
            stackView.snp.makeConstraints { make in
                make.top.equalTo(infoLabelPart1.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
            }
            
            [goodImageView, badImageView].forEach {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(contentView.snp.width).multipliedBy(0.5)
                }
            }
            
            infoLabelPart2.snp.makeConstraints { make in
                make.top.equalTo(stackView.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
            }
            
            moreButton.snp.makeConstraints { make in
                make.top.equalTo(infoLabelPart2.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
                make.bottom.equalTo(contentView).inset(20)
                make.height.equalTo(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

// MARK: - Private
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
        contentView.addSubview(infoLabelPart1)
        contentView.addSubview(stackView)
        contentView.addSubview(infoLabelPart2)
        contentView.addSubview(moreButton)
        view.setNeedsUpdateConstraints()
    }
    
    func setupStyles() {
        title = StringValues.infoViewTitle
        moreButton.layer.cornerRadius = 10
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
            moreButton.backgroundColor = .opaqueSeparator
            moreButton.setTitleColor(.label, for: .normal)
        } else {
            view.backgroundColor = .lightGray
            moreButton.backgroundColor = .darkGray
            moreButton.setTitleColor(.white, for: .normal)
        }
        
        [goodImageView, badImageView].forEach {
            $0.contentMode = .scaleAspectFit
        }
        
        [goodImageIconLabel, badImageIconLabel].forEach {
            $0.textAlignment = .center
        }
        
        [infoLabelPart1, infoLabelPart2].forEach {
            $0.numberOfLines = 0
            $0.lineBreakMode = .byClipping
        }
        
        [imagesStackView, iconsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
    }
    
    @objc
    func didTapMoreButton(sender: AnyObject) {
        if let url = URL(string: "https://github.com/vikgor/CarPhotoML") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

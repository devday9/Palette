//
//  ColorPaletteView.swift
//  Palette
//
//  Created by Cameron Stuart on 7/10/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {
    
    var colors: [UIColor]? {
        didSet{
            buildColorBricks()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
    }
    
    private func setUpViews() {
        addSubview(colorStackView)
        colorStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
        buildColorBricks()
    }
    
    private func generateColorBrick(for color: UIColor) -> UIView {
        let colorBrick = UIView()
        colorBrick.backgroundColor = color
        return colorBrick
    }
    
    private func buildColorBricks(){
        resetColorBricks()
        guard let colors = self.colors else { return }
        for color in colors {
            let colorBrick = self.generateColorBrick(for: color)
            self.addSubview(colorBrick)
            self.colorStackView.addArrangedSubview(colorBrick)
        }
        self.layoutIfNeeded()
    }
    
    private func resetColorBricks() {
        for subView in colorStackView.arrangedSubviews {
            self.colorStackView.removeArrangedSubview(subView)
        }
    }
    
    //MARK: - SubViews
    lazy var colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .horizontal
        return stackView
    }()
}

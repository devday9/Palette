//
//  PaletteListViewController.swift
//  Palette
//
//  Created by Deven Day on 10/13/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class PaletteListViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var buttons: [UIButton] {
        return [featuredButton, randomButton, doubleRainbowButton]
    }
    var photos: [UnsplashPhoto] = []
    
    //MARK: - Lifecycles
    override func loadView() {
        super.loadView()
        addAllSubviews()
        setupButtonStackView()
        constrainPaletteTableView()
        configurePaletteTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "offWhite")
        activateButtons()
        UnsplashService.shared.fetchFromUnsplash(for: .featured) { (photos) in
            guard let photos = photos else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
    
    //MARK: - Helper Functions
    func addAllSubviews() {
        self.view.addSubview(featuredButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(doubleRainbowButton)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(paletteTableView)
    }
    
    func setupButtonStackView() {
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8).isActive = true
    }
    
    func constrainPaletteTableView() {
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
    }
    
    func configurePaletteTableView() {
        paletteTableView.delegate = self
        paletteTableView.dataSource = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "photoCell")
    }
    
    func activateButtons() {
        buttons.forEach { $0.addTarget(self, action: #selector(selectedButton(sender:)), for: .touchUpInside)}
        featuredButton.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
    
    @objc func selectedButton(sender: UIButton) {
        buttons.forEach { $0.setTitleColor(.lightGray, for: .normal) }
        sender.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
        paletteTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        switch sender {
        case featuredButton:
            searchForCategory(unsplashRoute: .featured)
        case randomButton:
            searchForCategory(unsplashRoute: .random)
        case doubleRainbowButton:
            searchForCategory(unsplashRoute: .doubleRainbow)
        default:
            searchForCategory(unsplashRoute: .featured)
        }
    }
    
    func searchForCategory(unsplashRoute: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: unsplashRoute) { (photos) in
            guard let photos = photos else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
    
    //MARK: - Views
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitle("Featured", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Random", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Double Rainbow", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let paletteTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
}//END OF CLASS

//MARK: - Extensions
extension PaletteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let outerVerticalSpacing: CGFloat = (2 * SpacingConstants.outerVerticalPadding)
        let labelSpace: CGFloat = SpacingConstants.smallElementHeight
        let objectBuffer: CGFloat = SpacingConstants.verticalObjectBuffer
        let colorViewSpace: CGFloat = SpacingConstants.mediumElementHeight
        let secondObjectBuffer: CGFloat = SpacingConstants.verticalObjectBuffer
        return imageViewSpace + outerVerticalSpacing + labelSpace + objectBuffer + colorViewSpace + secondObjectBuffer
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PaletteTableViewCell else { return UITableViewCell() }
        
        let photo = photos[indexPath.row]
        cell.photo = photo
        
        return cell
    }
}//END OF EXTENSION

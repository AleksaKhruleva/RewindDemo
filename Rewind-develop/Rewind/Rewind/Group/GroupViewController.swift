//
//  GroupViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class GroupViewController: UIViewController {
    var contentViewHeightConstraint: NSLayoutConstraint?
    var membersTableHeightConstraint: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let groupImageView: UIImageView = UIImageView()
    private let groupNameLabel: UILabel = UILabel()
    private let membersLabel: UILabel = UILabel()
    private let membersTable: MembersTableView = MembersTableView()
    private let groupMediaButton: UIButton = UIButton(type: .system)
    private let groupMediaCollection: GroupMediaCollectionView = GroupMediaCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateViewsHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewsHeight()
    }
    
    @objc
    private func groupSettingsButtonTapped() {
        let vc = GroupSettingsViewController()
        vc.modalTransitionStyle = .coverVertical
        view.layer.add(CATransition(), forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    private func backButtonTapped() {
        modalTransitionStyle = .coverVertical
        navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func groupMediaButtonTapped() {
        let vc = GalleryBuilder.build()
        vc.modalTransitionStyle = .coverVertical
        navigationController?.view.layer.add(CATransition(), forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func updateViewsHeight() {
        contentViewHeightConstraint?.isActive = false
        membersTableHeightConstraint?.isActive = false
        
        var membersTableHeight = membersTable.contentSize.height
        
        if membersTableHeight > 0 {
            membersTableHeight -= 1
        }
        
        var contentViewHeight = groupImageView.frame.height + 10 + 25 + 30 + 20 + 10 + membersTableHeight + 30 + 20 + 10 + groupMediaCollection.frame.height + 30
        
        if contentViewHeight < view.safeAreaLayoutGuide.layoutFrame.height {
            contentViewHeight = view.safeAreaLayoutGuide.layoutFrame.height * 1.1
        }
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        membersTableHeightConstraint = membersTable.heightAnchor.constraint(equalToConstant: membersTableHeight)
        
        membersTableHeightConstraint?.isActive = true
        contentViewHeightConstraint?.isActive = true
        view.layoutIfNeeded()
    }
}

extension GroupViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureGroupSettingsButton()
        configureBackButton()
        configureScrollView()
        configureContentView()
        configureGroupImageView()
        configureGroupNameLabel()
        configureMembersLabel()
        configureMembersTable()
        configureGroupMediaButton()
        configureGroupMediaCollection()
    }
    
    private func configureGroupSettingsButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: configuration)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(groupSettingsButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func configureBackButton() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinTop(to: view.topAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .systemBackground
        
        contentView.pinLeft(to: scrollView.leadingAnchor)
        contentView.pinRight(to: scrollView.trailingAnchor)
        contentView.pinTop(to: scrollView.topAnchor)
        contentView.pinBottom(to: scrollView.bottomAnchor)
        contentView.pinWidth(to: scrollView.widthAnchor)
    }
    
    private func configureGroupImageView() {
        contentView.addSubview(groupImageView)
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        
        groupImageView.image = UIImage(named: "groupImage")
        
        groupImageView.contentMode = .scaleAspectFill
        groupImageView.clipsToBounds = true
        
        let width = UIScreen.main.bounds.width / 3
        
        groupImageView.layer.cornerRadius = width / 2
        
        groupImageView.setWidth(width)
        groupImageView.setHeight(width)
        groupImageView.pinTop(to: contentView.topAnchor)
        groupImageView.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureGroupNameLabel() {
        contentView.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        groupNameLabel.text = "Group name"
        groupNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        groupNameLabel.pinTop(to: groupImageView.bottomAnchor, 10)
        groupNameLabel.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureMembersLabel() {
        contentView.addSubview(membersLabel)
        membersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        membersLabel.text = "Group members"
        membersLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        membersLabel.pinTop(to: groupNameLabel.bottomAnchor, 25)
        membersLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureMembersTable() {
        contentView.addSubview(membersTable)
        membersTable.translatesAutoresizingMaskIntoConstraints = false
        
        membersTable.isLimitedDisplay = true
        
        membersTable.pinTop(to: membersLabel.bottomAnchor, 10)
        membersTable.pinLeft(to: contentView.leadingAnchor, 20)
        membersTable.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureGroupMediaButton() {
        contentView.addSubview(groupMediaButton)
        groupMediaButton.translatesAutoresizingMaskIntoConstraints = false
        
        groupMediaButton.setTitle("Group media ", for: .normal)
        groupMediaButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        groupMediaButton.setImage(image, for: .normal)
        
        groupMediaButton.tintColor = .black
        
        groupMediaButton.semanticContentAttribute = .forceRightToLeft
        
        groupMediaButton.addTarget(self, action: #selector(groupMediaButtonTapped), for: .touchUpInside)
        
        groupMediaButton.pinTop(to: membersTable.bottomAnchor, 25)
        groupMediaButton.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureGroupMediaCollection() {
        contentView.addSubview(groupMediaCollection)
        groupMediaCollection.translatesAutoresizingMaskIntoConstraints = false
        
        groupMediaCollection.pinTop(to: groupMediaButton.bottomAnchor, 10)
        groupMediaCollection.pinLeft(to: contentView.leadingAnchor, 20)
        groupMediaCollection.pinRight(to: contentView.trailingAnchor, 20)
    }
}

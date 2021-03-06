//
//  FeedGithubRepoCell.swift
//  Yep
//
//  Created by nixzhu on 15/12/17.
//  Copyright © 2015年 Catch Inc. All rights reserved.
//

import UIKit
import YepKit

private let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width

final class FeedGithubRepoCell: FeedBasicCell {

    override class func heightOfFeed(feed: DiscoveredFeed) -> CGFloat {

        let height = super.heightOfFeed(feed) + (80 + 15)

        return ceil(height)
    }

    var tapGithubRepoLinkAction: (NSURL -> Void)?

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SocialAccount.Github.iconName)
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        imageView.tintColor = SocialAccount.Github.tintColor
        return imageView
    }()

    lazy var githubRepoContainerView: FeedGithubRepoContainerView = {
        let view = FeedGithubRepoContainerView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return view
    }()

    lazy var socialWorkBorderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.yep_socialWorkBorder
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(logoImageView)
        contentView.addSubview(githubRepoContainerView)
        contentView.addSubview(socialWorkBorderImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureWithFeed(feed: DiscoveredFeed, layout: FeedCellLayout, needShowSkill: Bool) {

        super.configureWithFeed(feed, layout: layout, needShowSkill: needShowSkill)

        if let attachment = feed.attachment {
            if case let .Github(githubRepo) = attachment {
                githubRepoContainerView.nameLabel.text = githubRepo.name
                githubRepoContainerView.descriptionLabel.text = githubRepo.description
            }
        }

        githubRepoContainerView.tapAction = { [weak self] in
            guard let attachment = feed.attachment else {
                return
            }

            if case .GithubRepo = feed.kind {
                if case let .Github(repo) = attachment, let URL = NSURL(string: repo.URLString) {
                    self?.tapGithubRepoLinkAction?(URL)
                }
            }
        }

        if needShowSkill, let _ = feed.skill {
            logoImageView.frame.origin.x = skillButton.frame.origin.x - 10 - 18
            logoImageView.frame.origin.y = nicknameLabel.frame.origin.y

        } else {
            logoImageView.frame.origin.x = screenWidth - 18 - 15
            logoImageView.frame.origin.y = nicknameLabel.frame.origin.y
        }
        nicknameLabel.frame.size.width -= logoImageView.bounds.width + 10

        let githubRepoLayout = layout.githubRepoLayout!
        githubRepoContainerView.frame = githubRepoLayout.githubRepoContainerViewFrame
        socialWorkBorderImageView.frame = githubRepoContainerView.frame
    }
}


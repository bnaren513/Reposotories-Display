//
//  SearchTableViewCell.swift
//  GithubRepositories
//
//  Created by Pradeep Sharma on 11/10/18.
//  Copyright © 2018 Pradeep Sharma. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var customView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var commitcountLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var watchercountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

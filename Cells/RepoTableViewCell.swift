
//
//  RepoTableViewCell.swift
//  GithubRepositories
//
//  Created by Pradeep Sharma on 12/10/18.
//  Copyright © 2018 Pradeep Sharma. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet var repoLabel: UILabel!
    @IBOutlet var repoimageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

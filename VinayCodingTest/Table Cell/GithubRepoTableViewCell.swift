//
//  GithubRepoTableViewCell.swift
//  VinayCodingTest
//
//  Created by Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import UIKit

class GithubRepoTableViewCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startsLabel: UILabel!
    @IBOutlet weak var repoOwnerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadDataInCell(_ githubObject : GithubDetailModel)  {
        repoNameLabel.text = githubObject.name
        descriptionLabel.text = githubObject.descrption
        startsLabel.text = "\(githubObject.stargazersCount)"
        repoOwnerLabel.text = githubObject.fullName
        
    }
    
}

//
//  ProfileViewController.swift
//  BikeApp
//
//  Created by João Davila on 17/05/2018.
//  Copyright © 2018 BikeApp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var actionProfile: [String] = ["Edit Profile", "My Rents", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "actionProfileCell", for: indexPath) as? ActionsProfileTableViewCell
        
        profileCell?.actionLabel.text = actionProfile[indexPath.row]
        
        return profileCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 73
        return tableView.rowHeight
    }

}

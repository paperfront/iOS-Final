//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Max Miranda on 9/18/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedVC: UIViewController  {
    var countLabel: UILabel!
    var userID: String!
    
    var vcDelegate1: VCDelegate! // PART 3 CODE
    var vcDelegate2: VCDelegate! // PART 3 CODE
    
    var tableView: UITableView!
    var arrayOfSnaps: [SnapImage]!
    
    var selectedImage: SnapImage!
    
    var navBarColorSwitched = false
    

    override func viewDidLoad() {
        // vcDelegate2 = self // PART 3 CODE
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupArrayOfSnaps()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "My Snaps"
        tableView.reloadData()
    }
    
    func setupArrayOfSnaps() {
        arrayOfSnaps = []
        /* PART 2B START */
        FirebaseAPIClient.getSnaps(completion: {snaps in
            self.arrayOfSnaps = snaps
            })
        /* PART 2B FINISH */
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 70))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        view.addSubview(tableView)
    }
    
    @objc func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error{
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    /* PART 3C START (Hint: Define a function, that's already used in part 3 code) */
    func toggleColor() {
        if self.view.backgroundColor == UIColor.yellow{
            self.view.backgroundColor = UIColor.blue
        }
        else{
            self.view.backgroundColor = UIColor.yellow
        }
    }
    /* PART 3C FINISH */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toShowImage" {
            var destination = segue.destination as! ShowImageVC
            destination.snapImage = selectedImage
        }
    }

}

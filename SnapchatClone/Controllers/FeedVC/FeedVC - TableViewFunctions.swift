//
//  FeedVC - TableViewFunctions.swift
//  SnapchatClone
//
//  Created by Max Miranda on 9/18/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSnaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = indexPath[1]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
            as! FeedTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()

        cell.senderLabel.text = arrayOfSnaps[index].sender
        cell.dateSentLabel.text = arrayOfSnaps[index].timeSent
        cell.hasBeenOpenedSquare.backgroundColor = .red
        
        if arrayOfSnaps[index].opened {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.hasBeenOpenedSquare.layer.borderColor = UIColor.red.cgColor
            cell.hasBeenOpenedSquare.layer.borderWidth = 1
            cell.hasBeenOpenedSquare.backgroundColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath[1]
        selectedImage = arrayOfSnaps[index]
        if !selectedImage.opened {
            changeColors(vcDelegate1) // PART 3 CODE
            changeColors(vcDelegate2) // PART 3 CODE
            performSegue(withIdentifier: "toShowImage", sender: self)
        }
        selectedImage.opened = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func changeColors(_ vcDel : VCDelegate) {
        vcDel.toggleColor() // PART 3 CODE
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//
//  FirebaseAPIHelper.swift
//  
//
//  Created by Will Oakley on 10/24/18.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import UIKit

class FirebaseAPIClient {
    
    static func getSnaps(completion: @escaping ([SnapImage]) -> ()) {
        /* PART 2A START */
        let db = Database.database().reference()
        let storage = Storage.storage().reference()
        let snapsNode = db.child("snapImages")
        var snapArray = [SnapImage]()
        snapsNode.observeSingleEvent(of: .value, with: { (snapShot) in
            if snapShot.exists() {
                let array:NSArray = snapShot.children.allObjects as NSArray

                for child in array {
                    let snap = child as! DataSnapshot
                    if snap.value is NSDictionary {
                        let data:[String:String] = snap.value as! [String:String]
                        let url = URL(string: data["imageURL"]!)
                        let data1 = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        let currentImage = UIImage(data: data1!)
                        snapArray.append(SnapImage(sentBy: data["sentBy"]!, sentTo: data["sentTo"]!, timeSent: data["timeSent"]!, image: currentImage!))
                    }

                }
                completion(snapArray)
            }
        })
        /* PART 2A FINISH */
    }
}

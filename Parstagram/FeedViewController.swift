//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Daniel Cruz Castro on 10/11/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Declarations: Outlet, posts empty array, refresh control
    @IBOutlet var tableView: UITableView!
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.delegate = self
        tableView.dataSource = self
    }
    
// Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Declarations: Cell class assignment, posts indexing
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let posts = posts[indexPath.row]
        let user = posts["author"] as! PFUser
        
        // Body: Assign properties, query image, set image in feed
        cell.authorLabel.text = user.username
        cell.commentLabel.text = posts["caption"] as? String
        
        let imageFile = posts["image"] as! PFFileObject
        let urlString = imageFile.url! // URLs are HTTPS, but Xcode isnt giving error?
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Declaration: after making a post, refresh feed
        super.viewDidAppear(animated)
        
        // Body: Create Parse query, include key and limit
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Daniel Cruz Castro on 10/11/21.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    // Declarations: Outlet, posts empty array, refresh control
    @IBOutlet var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(hideKeyboard(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
// Functions
    // Number of "rows" func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Declarations: grab table row (user "post") items (image and comment)
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? [] // if on the left of ?? happens to be nil, take on the value on the right
        
        return comments.count + 2
    }
    
    // Number of sections func
    func numberOfSections(in tableView: UITableView) -> Int {
        // Declarations: You have as many sections as you have posts
        return posts.count
    }
    
    // Main tableView func
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Declarations: Grab post and comment cells
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        // Body: if indexPath.row == 0, then its the image as the image always precludes comments. Grab image. If not, grab comment cell. If more than current amount of comments, its add a comment row.
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let posts = posts[indexPath.section]
            let user = posts["author"] as! PFUser
            let imageFile = posts["image"] as! PFFileObject
            let urlString = imageFile.url! // URLs are HTTPS, but Xcode isnt giving error?
            let url = URL(string: urlString)!
            
            cell.authorLabel.text = user.username
            cell.commentLabel.text = posts["caption"] as? String
            cell.photoView.af.setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            let user = comment["author"] as! PFUser
            
            cell.commentLabel.text = comment["text"] as? String
            cell.nameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
    }
    
    // Run written when view is loaded func
    override func viewDidAppear(_ animated: Bool) {
        // Declaration: after making a post, refresh feed
        super.viewDidAppear(animated)
        
        // Body: Create Parse query, include key and limit
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    // Logout User func
    @IBAction func logout(_ sender: Any) {
        //Body: Send parse log out query then modify segue
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    // Did Select tableView func
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Declarations: Selected post
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
        selectedPost = post
    }
    
    // Comment bar funcs
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    // Event func to hide keyboard
    @objc func hideKeyboard(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
        }
        tableView.reloadData()
        
        // Clear and dismiss the bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
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

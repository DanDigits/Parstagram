//
//  CaptureViewController.swift
//  Parstagram
//
//  Created by Daniel Cruz Castro on 10/12/21.
//

import UIKit
import AlamofireImage
import Parse

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Declarations
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
// Functions
    @IBAction func submitImage(_ sender: Any) {
        // Declarations: Utilize "table", save image .png data
        let post = PFObject(className: "Posts")
        let imageData = imageView.image?.pngData() //.png image
        let file = PFFileObject(name: "image.png", data: imageData!) //saves as image.png
        
        // Body: Send post and respective information to database
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        post["image"] = file
        
        post.saveInBackground() { (success, error) in
            if success {
                print("Posted!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Error!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelImage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraCaptureImage(_ sender: Any) {
        // Declarations: Quick n dirty camera implementation
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // Body: if camera is available, use it, else, open up photo library. Then present.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Declarations: let image be current edited(camera) image
        let image = info[.editedImage] as! UIImage
        
        // Body: Resize image for reasons (bandwith, too large, etc), then dismiss camera/editing view
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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

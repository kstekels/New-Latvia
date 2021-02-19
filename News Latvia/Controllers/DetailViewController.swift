//
//  DetailViewController.swift
//  News Latvia
//
//  Created by karlis.stekels on 12/02/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var buttonLabel: UIButton!
    var urlLinkString = String()
    var titleString = String()
    var contentString = String()
    var imgString = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Button
        buttonLabel.layer.cornerRadius = 20
        // ----
        self.title = "Article"
        print(urlLinkString)
        
        titleLabel.text = titleString
        titleLabel.tintColor = .systemFill
        titleLabel.backgroundColor = .systemYellow
        contentTextView.text = contentString
        imageView.image = getImage()
    }
    //MARK: - Get image for detail View
    func getImage() -> UIImage {
        let imageURL:URL = URL(string: imgString)!
        let imageData = try? Data(contentsOf: imageURL)
        let image = UIImage(data: imageData!)!
        return image
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: WebViewController = segue.destination as! WebViewController
        destination.urlString = urlLinkString

    }
    

}

//
//  DetailViewController.swift
//  Milestone 10-12
//
//  Created by Константин Кек on 20.12.2020.
//

import UIKit

class DetailViewController: UIViewController {
    var caption: String?
    var imageName: String?
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageName = imageName {
            let pathToImage = getDocumentsPath().appendingPathComponent(imageName)
            image.image = UIImage(contentsOfFile: pathToImage.path)
            
            guard let caption = caption else { return }
            title = caption
        }
    }
}

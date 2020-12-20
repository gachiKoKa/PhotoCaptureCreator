//
//  ViewController.swift
//  Milestone 10-12
//
//  Created by Константин Кек on 20.12.2020.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var images = [Image]() {
        didSet {
            let lastCaption = images.last?.caption
            
            if lastCaption == "" {
                let ac = UIAlertController(title: "Set caption", message: nil, preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "OK", style: .default) {[weak ac] _ in
                    if let textInput = ac?.textFields {
                        self.images.indices.last.map { self.images[$0].caption = textInput[0].text ?? "" }
                        self.dismiss(animated: true)
                        self.save()
                        self.tableView.reloadData()
                    }
                })
                present(ac, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        getData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
        cell.textLabel?.text = images[indexPath.row].caption
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailView = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            detailView.caption = images[indexPath.row].caption
            detailView.imageName = images[indexPath.row].imageName
            navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsPath().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        images.append(Image(imageName: imageName, caption: ""))
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "images")
        }
    }
    
    func getData() {
        let defaults = UserDefaults.standard
        if let userData = defaults.object(forKey: "images") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                images = try jsonDecoder.decode([Image].self, from: userData)
            } catch {
                print("error")
            }
        }
    }
}

extension UIViewController {
    func getDocumentsPath() -> URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return documentsUrl[0]
    }
}


//
//  Extension.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/19/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            let defaultAction = UIAlertAction(title: "ok", style: .default)
            alertController.addAction(defaultAction)
        } else {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}




extension UIImageView {
    func setImageFromUrl(_ urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let imageUrl = URL(string: urlString) else {
            print("error getting image url")
            return
        }
        //print("imageUrl----------------------", imageUrl)
        URLSession.shared.dataTask(with: imageUrl){ (data, response, error) in
            if let error = error {
                print("error getting image")
                return
            }
            guard let data = data else {
                        print("error: data is nil")
                        return
                    }

                    guard let image = UIImage(data: data) else {
                        print("error: cannot create image from data")
                        return
                    }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

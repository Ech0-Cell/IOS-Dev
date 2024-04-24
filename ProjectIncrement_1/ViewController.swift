//
//  ViewController.swift
//  ProjectIncrement_1
//
//  Created by Burak Taşkıran on 7.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bauLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bauLogo.alpha = 0.0
        logoAnimation()
        
    }
    
    func logoAnimation() {
        UIView.animate(withDuration: 3.0, animations: {
            self.bauLogo.alpha = 1.0
        }) { [] (finished) in
            self.performSegue(withIdentifier: "showMainVC", sender: nil)
        }
    }


}


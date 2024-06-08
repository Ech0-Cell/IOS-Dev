import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.alpha = 0.0
        animationStart()
    }
    
    func animationStart() {
        UIView.animate(withDuration: 1.0, animations: {
            self.logo.alpha = 1.0
        }) { [] (finished) in
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }
    }

}

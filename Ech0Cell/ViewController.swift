import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar when this view controller is about to disappear
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let msisdn = numberTextField.text, !msisdn.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            
            loginUser(msisdn: msisdn, password: password)
        } else {
            showAlert(title: "Warning", message: "Please fill all the field !")
        }
    }

    func loginUser(msisdn: String, password: String) {
        let parameters = """
               {
                   "msisdn": "\(msisdn)",
                   "password": "\(password)"
               }
               """
        
               guard let postData = parameters.data(using: .utf8) else {
                   print("Error encoding parameters")
                   return
               }
               
               var request = URLRequest(url: URL(string: "https://aom-vmovtyc2ya-uc.a.run.app/api/customer/login")!, timeoutInterval: Double.infinity)
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               request.httpMethod = "POST"
               request.httpBody = postData
               
               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   guard let data = data else {
                       print(String(describing: error))
                       return
                   }
                   
                   if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let token = jsonResponse["token"] as? String {
                       DispatchQueue.main.async {
                           self.performSegue(withIdentifier: "toPackageVC", sender: msisdn)
                       }
                   } else {
                       DispatchQueue.main.async {
                           self.showAlert(title: "Warning", message: "Invalid User Information !")
                       }
                   }
               }
               
               task.resume()
           }
           
    //MARK: Show Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Send data to other ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPackageVC" {
            if let destinationVC = segue.destination as? PackageViewController {
                if let msisdn = sender as? String {
                    destinationVC.msisdn = msisdn
                }
            }
        }
    }
    
}



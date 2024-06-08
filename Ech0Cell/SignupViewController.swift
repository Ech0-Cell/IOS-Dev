import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var turkishIDorPassportNumberTextField: UITextField!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var personalDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsButton.backgroundColor = UIColor.lightGray
        personalDataButton.backgroundColor = UIColor.lightGray
    }

    //MARK: Change Button Color
    @IBAction func changeColorTerms(_ sender: UIButton) {
        if termsButton.backgroundColor == UIColor.lightGray{
            termsButton.backgroundColor = UIColor.black
        }
        else {
            termsButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction func changeColorPersonal(_ sender: UIButton) {
        if personalDataButton.backgroundColor == UIColor.lightGray{
            personalDataButton.backgroundColor = UIColor.black
        }
        else {
            personalDataButton.backgroundColor = UIColor.lightGray
        }
    }
    
    //MARK: Signup Button Clicked
    @IBAction func signupButtonClicked(_ sender: Any) {
        if let msisdn = phoneTextField.text, !msisdn.isEmpty,
           let name = nameTextField.text, !name.isEmpty,
           let surname = surnameTextField.text, !surname.isEmpty,
           let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty,
           termsButton.backgroundColor == UIColor.black,
           personalDataButton.backgroundColor == UIColor.black {
                registerCustomer(msisdn: msisdn, name: name, surname: surname, email: email, password: password)
                print("Hata yok")
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Please fill all the fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Register Customer
    func registerCustomer(msisdn: String, name: String, surname: String, email: String, password: String) {
        let parameters = """
        {
            "msisdn": "\(msisdn)",
            "packageID": 1,
            "name": "\(name)",
            "surname": "\(surname)",
            "email": "\(email)",
            "password": "\(password)",
            "securityKey": "4444"
        }
        """
        guard let postData = parameters.data(using: .utf8) else {
            print("Error encoding parameters")
            return
        }
        var request = URLRequest(url: URL(string: "https://aom-vmovtyc2ya-uc.a.run.app/api/customer/register")!,
                                 timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = jsonResponse["message"] as? String {
                DispatchQueue.main.async {
                    if message == "success" {
                        self.showAlert(title: "Success", message: "User register is success")
                    } else if message == "Customer already exists" {
                        self.showAlert(title: "Infromation", message: "Customer already exists")
                    } else {
                        self.showAlert(title: "Warning", message: "An unknown error occurred")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Warning", message: "Invalid Input")
                }
            }
        }
        task.resume()
    }

    //MARK: Show Alert Function
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

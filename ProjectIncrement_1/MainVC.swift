import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        mainLabel.numberOfLines = 0
        mainLabel.contentMode = .topLeft
        fetchData();
    }
    
    func fetchData() {
        let urlString = "http://universities.hipolabs.com/search?name=bahce"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned")
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    if let universityInfo = jsonArray.first {
                        if let name = universityInfo["name"] as? String,
                           let country = universityInfo["country"] as? String,
                           let webPages = universityInfo["web_pages"] as? [String],
                           let domains = universityInfo["domains"] as? [String],
                           let alpha_two_code = universityInfo["alpha_two_code"] as? String
                        {
                            DispatchQueue.main.async {
                                self.mainLabel.text = "Name: \(name)\nCountry: \(country)\nWebsite: \(webPages.joined(separator: ", "))\nDomain: \(domains.joined(separator: ", "))\nAlpha Two Code: \(alpha_two_code)"
                            }
                        }
                    }
                }

            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }

}

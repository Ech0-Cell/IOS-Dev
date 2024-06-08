import UIKit

class PackageViewController: UIViewController {
    
    struct BalanceResponse: Codable {
        let remData: String
        let remSms: String
        let remMin: String
    }

    @IBOutlet weak var voicePercentageCircle: UIView!
    @IBOutlet weak var voiceRemained: UILabel!
    @IBOutlet weak var dataPercentageCircle: UIView!
    @IBOutlet weak var dataRemained: UILabel!
    @IBOutlet weak var smsPercentageCircle: UIView!
    @IBOutlet weak var smsRemained: UILabel!
    var msisdn: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        percentageCircles()
        if let msisdn = msisdn {
            fetchBalance(msisdn: msisdn)
        }
    }

    //MARK: Percentage Circle
    func percentageCircles() {
        // Voice Percentage Circle
        let vPercentageCircle = PercentageCircleView(frame: voicePercentageCircle.bounds)
        vPercentageCircle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vPercentageCircle.circleColor = .systemRed
        vPercentageCircle.circleBackgroundColor = .white
        vPercentageCircle.lineWidth = 5.0
        vPercentageCircle.percentage = 0.5
        voicePercentageCircle.addSubview(vPercentageCircle)

        // Data Percentage Circle
        let dPercentageCircle = PercentageCircleView(frame: dataPercentageCircle.bounds)
        dPercentageCircle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dPercentageCircle.circleColor = .systemRed
        dPercentageCircle.circleBackgroundColor = .white
        dPercentageCircle.lineWidth = 5.0
        dataPercentageCircle.addSubview(dPercentageCircle)

        // SMS Percentage Circle
        let sPercentageCircle = PercentageCircleView(frame: smsPercentageCircle.bounds)
        sPercentageCircle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sPercentageCircle.circleColor = .systemRed
        sPercentageCircle.circleBackgroundColor = .white
        sPercentageCircle.lineWidth = 5.0
        smsPercentageCircle.addSubview(sPercentageCircle)
    }

    //MARK: Fetch Balance
    func fetchBalance(msisdn: String) {
        guard let url = URL(string: "https://aom-vmovtyc2ya-uc.a.run.app/api/balance?MSISDN=\(msisdn)") else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1MTIzNDU2Nzg5IiwiaWF0IjoxNzE1NTM1NTUyLCJleHAiOjE3MTYxNDAzNTJ9.rQHpRePFO3hgX3bk6Y4XhEi7Vivs0tD_1uQOABbYvPI4DoOUG4qKlZ9idXlJFo4Mxj4msOQAzzImzqDe_gJenw", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response code: \(httpResponse.statusCode)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                let balanceResponse = try decoder.decode(BalanceResponse.self, from: data)
                let remData = balanceResponse.remData
                let remSms = balanceResponse.remSms
                let remMin = balanceResponse.remMin
                let totalData: CGFloat = 25
                let totalSms: CGFloat = 1000
                let totalMinutes: CGFloat = 1000
                let dataPercentage = CGFloat(Double(remData)! / Double(totalData))
                let smsPercentage = CGFloat(Double(remSms)! / Double(totalSms))
                let minutesPercentage = CGFloat(Double(remMin)! / Double(totalMinutes))
                DispatchQueue.main.async {
                    self.voiceRemained.text = "\(remMin) Minutes"
                    self.dataRemained.text = "\(remData) GB Data"
                    self.smsRemained.text = "\(remSms) Sms"
                    self.setPercentageCircle(percent: dataPercentage, circleView: self.dataPercentageCircle)
                    self.setPercentageCircle(percent: smsPercentage, circleView: self.smsPercentageCircle)
                    self.setPercentageCircle(percent: minutesPercentage, circleView: self.voicePercentageCircle)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    //MARK: Set Percentage Circle
    func setPercentageCircle(percent: CGFloat, circleView: UIView) {
        if let percentageCircle = circleView.subviews.compactMap({ $0 as? PercentageCircleView }).first {
            percentageCircle.percentage = percent
        }
    }
}

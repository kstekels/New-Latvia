//
//  ViewController.swift
//  News Latvia
//
//  Created by karlis.stekels on 12/02/2021.
//

import UIKit
import Gloss

class NewsViewController: UIViewController {
    
    var items: [Item] = []
    var image = UIImage()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.style = .large
        tableView.isHidden = true
        animatedLogo()
        
        
    }
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        activityIndicatorState(animated: true)
        getDataHandler()
    }
    
    func activityIndicatorState(animated: Bool) {
        DispatchQueue.main.async {
            if animated{
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }else{
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func animatedLogo() {
        //MARK: - Animated Logo
        self.title = ""
        var charIndex = 0.0
        let titleText = "📰 in Latvia 🇱🇻"
        for letter in titleText{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.title!.append(letter) // Closure (self)
            }
            charIndex += 1
            
        }
    }


    
    func getDataHandler() {
        let jsonURL = "http://newsapi.org/v2/top-headlines?country=lv&category=business&apiKey=a473de0095844441bc54bd266083c4f3"
        
        guard let url = URL(string: jsonURL) else {
            print("Not a valid URL")
            return
        }
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "GET"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requestURL){ (data, response, error) in
            
            if let err = error {
                print("error: \(err.localizedDescription)")
            }
            guard let data = data else {
                print("Data error!")
                return
            }
            
            do{
                if let dictOfData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    print("dictOfData: ", dictOfData)
                    self.refreshData(dict: dictOfData)
                }
            }catch{
                print("Error ocured when converting JSON")
            }
            
        }
        task.resume()
        
    }
    
    func refreshData(dict: [String: Any]) {
        guard let dictResponse = dict["articles"] as? [Gloss.JSON] else {
            return
        }
        
        items = [Item].from(jsonArray: dictResponse) ?? []
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.activityIndicatorState(animated: false)
        }
        
    }
    
    
    
    
}
//MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCells", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        
        cell.titleLabelTExt.text = item.title
        cell.articleTextLabel.text = item.description
        
//        cell.textLabel?.text = items[indexPath.row].title
//        cell.detailTextLabel?.text = items[indexPath.row].description
        //MARK: - Get Image
        let urlImageString = item.urlToImage
        let imageURL:URL = URL(string: urlImageString)!
        let imageData = try? Data(contentsOf: imageURL)
        image = UIImage(data: imageData!)!
//        cell.imageView?.center = self.view.center
        cell.arcticleImageView.image = image
        //
            
        

        return cell
    }
    //MARK: - Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            // Get the new view controller using segue.destination.
//            let destination: DetailViewController = segue.destination as! DetailViewController
//            // Pass the selected object to the new view controller.
//            destination.titleString = items[indexPath.row].title
//            destination.contentString = items[indexPath.row].description
//            destination.urlLinkString = items[indexPath.row].url
//
//        }
//
//    }
}
    //MARK: - UITableViewDelegate
    extension NewsViewController: UITableViewDelegate{
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DetailViewController") as? DetailViewController{
                vc.contentString = items[indexPath.row].description
                vc.titleString = items[indexPath.row].title
                vc.urlLinkString = items[indexPath.row].url
                vc.imgString = items[indexPath.row].urlToImage

                navigationController?.pushViewController(vc, animated: true)
            }

            }


        }




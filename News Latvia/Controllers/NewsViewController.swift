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

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        
    }
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        getDataHandler()
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
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
}
//MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCells", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = items[indexPath.row].description
        //MARK: - Get Image
        let urlImageString = items[indexPath.row].urlToImage
        let imageURL:URL = URL(string: urlImageString)!
        let imageData = try? Data(contentsOf: imageURL)
        image = UIImage(data: imageData!)!
        cell.imageView?.center = self.view.center
        cell.imageView?.image = image
        //
            
        

        return cell
    }
    
    func getImage() {
        
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




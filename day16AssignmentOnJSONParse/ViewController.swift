//
//  ViewController.swift
//  day16AssignmentOnJSONParse
//
//  Created by Felix-ITS016 on 18/12/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return finalArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        if indexPath.section == 0
        {
            cell.textLabel?.text = finalArray[indexPath.row]
        }
        return cell
    }
    
    var  finalArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    enum  JsonErrors:String,Error
    {
        case responseError = "Response Error"
        case dataError = "Data Error"
        case ConversionError = "Conversion Error"
    }
    
    func Parsejson()
    {
        let urlString = "https://api.github.com/repositories/19436/commits"
        let url:URL = URL(string: urlString)!
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession( configuration:sessionConfiguration)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            do
            {
                guard let  response = response else
                {
                    throw JsonErrors.responseError
                }
                guard let data = data else
                {
                    throw JsonErrors.dataError
                }
                guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else
                {
                    throw JsonErrors.ConversionError
                }
                for item in array
                {
                    let parentsArray = item["parents"] as! [[String:Any]]
                    let shaDic = parentsArray.first!
                    let url = shaDic["url"] as! String
                    print(url)
                    self.finalArray.append(url)
                    
                }
                if self.finalArray.count>0
                {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            catch let err
            {
                print(err)
            }
        }
        dataTask.resume()
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
            Parsejson()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


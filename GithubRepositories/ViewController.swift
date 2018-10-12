//
//  ViewController.swift
//  GithubRepositories
//
//  Created by Pradeep Sharma on 11/10/18.
//  Copyright © 2018 Pradeep Sharma. All rights reserved.
//

import UIKit
import SDWebImage


class ViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var pageNumer :Int!
    var searchString : String!
    var dataArray = [AnyObject]()
    var paginationArray = [AnyObject]()
    var itemsArray = [AnyObject]()
var searchController : UISearchBar!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
  // Do any additional setup after loading the view, typically from a nib.
            super.viewDidLoad()
        pageNumer = 1
       
            self.searchController = UISearchBar()
        searchController.placeholder = "Search Here"
            self.searchController.delegate = self
            self.searchController.tintColor = UIColor.lightGray
            self.searchController.barTintColor = UIColor.lightGray
           // self.searchController.becomeFirstResponder()
        
            self.navigationItem.titleView = searchController
            
        
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
        pageNumer = 1
        self.dataArray.removeAll()
        self.tableView.reloadData()
        self.searchController.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.text
        self.searchRepositoty(string: searchBar.text, pagination: false)
         self.searchController.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //<#code#>
        if(searchText.isEmpty)
        {
            pageNumer = 1
            self.dataArray.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func searchRepositoty(string : String!,pagination : Bool)
    {
        var baseurl :String;
        
            baseurl = Constants.Base.BASE_URL + string + "&per_page=10" + "&page=" + String(pageNumer!)
       
            //+ "?access_token" +  Constants.Base.ACCESS_TOKEN
         ServiceManager.sharedInstance.requestWithParameters(paramaters: [], andMethod: baseurl, onSuccess: {(_ json: Any) -> Void in
            
            print (json)
            let response : NSDictionary = json as! NSDictionary
        
            
            if(pagination)
            {
                
                self.paginationArray = response["items"]  as! [AnyObject]
                if(self.itemsArray.count > 0)
                {
                    self.itemsArray.append(contentsOf: response["items"]  as! [AnyObject])
                    let sortedarray = (self.paginationArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "watchers_count", ascending: true)]) as! [[String:AnyObject]]
                    self.dataArray.append(contentsOf: (sortedarray as NSArray).reversed() as [AnyObject])
                }
                else
                {
                    self.pageNumer = 1
                    self.dataArray.removeAll()
                    self.showAlert(withTitle: "Alert !", message: "No Results Found")
                }
            }
            else
            {
                self.itemsArray = response["items"]  as! [AnyObject]
            if(self.itemsArray.count > 0)
            {
                let sortedarray = (self.itemsArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "watchers_count", ascending: true)]) as! [[String:AnyObject]]
                self.dataArray =  (sortedarray as NSArray).reversed() as [AnyObject]
            }
            else
            {
                self.pageNumer = 1
                self.dataArray.removeAll()
                self.showAlert(withTitle: "Alert !", message: "No Results Found")
            }
            }
        
            self.tableView.reloadData()
         },
                                                             
        onError: {(_ error: Error?) -> Void in
  
          // print( error?.localizedDescription,separator: "|")
    
         })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
         let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! SearchTableViewCell

        let itemdict :NSDictionary = self.dataArray[indexPath.row] as! NSDictionary
        let ownerdict :NSDictionary = itemdict["owner"] as! NSDictionary
        cell.nameLabel.text =   (itemdict["name"] as! String)
        cell.fullnameLabel.text =  (itemdict["full_name"] as! String)
        cell.watchercountLabel.text = "\(String(describing: itemdict["watchers_count"]!))"
        cell.commitcountLabel.text = "\(String(describing: itemdict["forks_count"]!))"
        cell.customView.layer.borderWidth = 1
        cell.customView.layer.masksToBounds = true
        cell.customView.layer.cornerRadius = 10
        cell.customView.layer.borderColor = UIColor.lightGray.cgColor
        let imageURL = URL(string: ownerdict["avatar_url"] as! String)

            cell.avatarImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .cacheMemoryOnly, completed: { (image, error, cacheType, url) -> Void in
                if ((error) != nil) {
                    // set the placeholder image here
                    
                } else {
                    // success ... use the image
                    cell.avatarImageView?.image = image
                }
            })
        
      
        return cell
    }
    @IBAction func filterButtonAction(_ sender: Any) {
        if(self.dataArray.count>0)
        {
        let myController = UIAlertController(title: "Filter", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        myController.addAction(UIAlertAction(title: "Assending order", style: UIAlertAction.Style.default, handler: { action in
            //println("Option 1")
            self.dataArray.removeAll()
            self.dataArray = (self.itemsArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "watchers_count", ascending: true)]) as! [[String:AnyObject]] as [AnyObject]
             self.tableView.reloadData()
        }))
        myController.addAction(UIAlertAction(title: "Desending order", style: UIAlertAction.Style.default, handler: { action in
            //println("Option 2")
            self.dataArray.removeAll()
            let sortedarray = (self.itemsArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "watchers_count", ascending: true)]) as! [[String:AnyObject]]
            self.dataArray =  (sortedarray as NSArray).reversed() as [AnyObject]
            self.tableView.reloadData()
        }))
        myController.addAction(UIAlertAction(title: "Pages", style: UIAlertAction.Style.default, handler: { action in
            //println("Option 2")
            
            let alertController = UIAlertController(title: "Page Number?", message: "Please enter page number:", preferredStyle: UIAlertController.Style.alert)
            
            let saveAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                self.pageNumer = Int(firstTextField.text ?? "")
                self.searchRepositoty(string: self.searchString, pagination: false)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in })
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.keyboardType = .numberPad
                textField.placeholder = "Enter Number"
            }
            
           
            alertController.addAction(cancelAction)
             alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
           
        }))
        myController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(myController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailId", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailId")
        {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller :DetailViewController = segue.destination as! DetailViewController
                controller.deatildict = self.dataArray[indexPath.row] as? NSDictionary
            }
        }
    }

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    //Bottom Refresh
    
    if scrollView == tableView{
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    {
   
        pageNumer = pageNumer + 1
        self.searchRepositoty(string: self.searchString, pagination: true)
    }
    
    }
    }
    
}




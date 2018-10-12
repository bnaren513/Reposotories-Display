//
//  ContributorViewController.swift
//  GithubRepositories
//
//  Created by Pradeep Sharma on 12/10/18.
//  Copyright © 2018 Pradeep Sharma. All rights reserved.
//

import UIKit

class ContributorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet var contributorTableView: UITableView!
    var contributordeatildict : NSDictionary!
     var dataArray = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        custombackButton()
       self.title = "Contributor"
        self.contributorDetailList()
        // Do any additional setup after loading the view.
    }
    func custombackButton()
    {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow.png"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(menuButtonTapped))
        barButtonItem.tintColor = UIColor.black
        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        // Private action
        
    }
    @objc fileprivate func menuButtonTapped() {
        // body method here
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section  == 0)
        {
            return 1;
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section  == 0)
        {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! SearchTableViewCell
         let imageURL = URL(string: contributordeatildict["avatar_url"] as! String)
       // let imageURL = URL(string: ownerdict["avatar_url"] as! String)
        
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
        else
        {
            let cell :RepoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            as! RepoTableViewCell
            let itemdict :NSDictionary = self.dataArray[indexPath.row] as! NSDictionary
           // let ownerdict :NSDictionary = itemdict["owner"] as! NSDictionary
            cell.repoLabel?.text =   (itemdict["name"] as! String)

            return cell
            
        }
        
        
        //cell.avatarImageView.sd_setImageWithURL(imageURL, completed: block)
       
    }
   
    func contributorDetailList()
    {
        let baseurl = (self.contributordeatildict["repos_url"] as! String)
            //+ "?access_token" +  Constants.Base.ACCESS_TOKEN
        ServiceManager.sharedInstance.detaildrequestWithParameters(paramaters: [], andMethod: baseurl, onSuccess: {(_ json: Any) -> Void in
            
            print (json)
            //let response : NSDictionary = json as! NSDictionary
            //print("json=\(String(describing: response))")\
            self.dataArray = json as! [AnyObject]
            
           
            self.contributorTableView.reloadData()
        },
                                                                   
                                                                   onError: {(_ error: Error?) -> Void in
                                                                    
                                                                    // print( error?.localizedDescription,separator: "|")
                                                                    
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 150
        }
        return 44
        
     }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1
        {
            return "Repo List"
        }
        return ""
    }
}

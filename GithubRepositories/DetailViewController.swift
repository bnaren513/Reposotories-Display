//
//  DetailViewController.swift
//  GithubRepositories
//
//  Created by Pradeep Sharma on 11/10/18.
//  Copyright © 2018 Pradeep Sharma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

     var dataArray = [AnyObject]()
    @IBOutlet var contributorCollectionview: UICollectionView!
    @IBOutlet var projectLinkButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    var deatildict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.hidesBackButton = true
        custombackButton()
        self.contributorList()
        self.title = "Repo";
        let ownerdict :NSDictionary = self.deatildict["owner"] as! NSDictionary
        let imageURL = URL(string: ownerdict["avatar_url"] as! String)
        
        self.imageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .cacheMemoryOnly, completed: { (image, error, cacheType, url) -> Void in
            if ((error) != nil) {
                // set the placeholder image here
                
            } else {
                // success ... use the image
                self.imageView?.image = image
            }
        })
       // self.projectLinkLabel.text =
        self.descriptionTextView.text =  "Description :" + (self.deatildict["description"] as! String)
        self.nameLabel.text = "Name :" + (self.deatildict["name"] as! String)
        // Do any additional setup after loading the view.
       
        let text : String = (self.deatildict["clone_url"] as! String)

       
         self.projectLinkButton.setTitle(text, for: .normal)
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
    
    @IBAction func projectLinkAction(_ sender: Any) {
      //  UIApplication.shared.open((), options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler: nil)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:self.deatildict["clone_url"] as! String)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string:self.deatildict["clone_url"] as! String)!)
        }
       // UIApplication.shared.canOpenURL
    }
    func contributorList()
    {
        let baseurl = (self.deatildict["contributors_url"] as! String)
            //+ "?access_token" +  Constants.Base.ACCESS_TOKEN
        ServiceManager.sharedInstance.detaildrequestWithParameters(paramaters: [], andMethod: baseurl, onSuccess: {(_ json: Any) -> Void in
            
            print (json)
            
            self.dataArray = json as! [AnyObject]
            

            self.contributorCollectionview.reloadData()
        },
                                                            
                                                            onError: {(_ error: Error?) -> Void in
                                                                
                                                                // print( error?.localizedDescription,separator: "|")
                                                                
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
         let itemdict :NSDictionary = self.dataArray[indexPath.row] as! NSDictionary
        let cell : ContributorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ContributorCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell..text = self.items[indexPath.item]
       // cell.contributorImageView.image =
         let imageURL = URL(string: itemdict["avatar_url"] as! String)
            cell.contributorImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .cacheMemoryOnly, completed: { (image, error, cacheType, url) -> Void in
                if ((error) != nil) {
                    // set the placeholder image here
                    
                } else {
                    // success ... use the image
                    cell.contributorImageView?.image = image
                }
            })
        
        cell.contributorLabel.text = itemdict["login"] as? String
       //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
   
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.performSegue(withIdentifier: "ContributorId", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let cellWidth = Float(screenWidth / 6.0) //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size = CGSize(width: CGFloat(cellWidth), height: CGFloat(cellWidth))
        
        return size
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ContributorId")
        {
            if let indexPaths = self.contributorCollectionview.indexPathsForSelectedItems{
                
                let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
                let controller :ContributorViewController = segue.destination as! ContributorViewController
                controller.contributordeatildict = self.dataArray[indexPath.item] as? NSDictionary
            }
        }
    }
}

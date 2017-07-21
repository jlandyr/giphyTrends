//
//  ViewController.swift
//  giphy
//
//  Created by Juan S. Landy on 21/7/17.
//  Copyright © 2017 eureka apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView = UIImageView()
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    var tableData : [AnyObject]!
    var dataSource = DataSource()
    
    @IBOutlet weak var collectionViewGifs: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = APIController()
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
        self.tableData = []
        
        let task2 = session.dataTask(with: url.getUrl()) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if error != nil{
                print("error=\(String(describing: error))")
                return
            }else{
                do{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                    
                    self.tableData = dic.value(forKey : "data") as? [AnyObject]
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionViewGifs.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
        task2.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
//MARK: - UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath) as! GifCollectionViewCell
        if self.tableData.count > 0
        {
            cell.tag = indexPath.row
            let object = self.tableData[indexPath.row]
            
            if let urlGif = dataSource.getData(object: object){
                if (self.cache.object(forKey: urlGif as AnyObject) != nil){
                    //cache
                    if cell.tag == indexPath.row{
                        
                        DispatchQueue.global(qos: .background).async {
                            let theImage = UIImage.gifImageWithData(data: self.cache.object(forKey: urlGif as AnyObject) as! NSData)
                            
                            DispatchQueue.main.async {
                                cell.activityIndicator.isHidden = true
                                cell.imageGif.image = nil
                                cell.imageGif?.image = theImage
                            }
                        }
                    }

                }else{
                    if cell.tag == indexPath.row{
                        cell.imageGif.image = nil
                        cell.activityIndicator.startAnimating()
                        task = session.downloadTask(with: urlGif, completionHandler: { (location, response, error) -> Void in
                            if let data = try? Data(contentsOf: urlGif){
                                
                                let theImg = UIImageView(image: UIImage.gifImageWithURL(gifUrl: urlGif.absoluteString)).image
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    cell.imageGif.image = theImg
                                    self.cache.setObject(data as AnyObject, forKey: urlGif as AnyObject)
                                    cell.activityIndicator.isHidden = true
                                    
                                })
                            }
                        })
                        task.resume()
                    }
                }
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.view.bounds.width/2.0 - 7.5
        return CGSize(width: yourWidth, height: yourWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5,5,5,5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}



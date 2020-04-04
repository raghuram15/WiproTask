//
//  TableViewCell.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var imageCache = NSCache<AnyObject, AnyObject>()
    var imageUrlString : String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor  = UIColor(red: 0, green : 102/255, blue: 0, alpha: 1)
        
        addSubview(baseView)
        baseView.addSubview(refImageView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(descriptionTextView)
        
        
        setBaseViewCons()
        setImageConstraints()
        setTitleLabelCons()
        setDescCons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK : - Initialize Views
    var baseView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var refImageView : UIImageView = {
        let imageView = UIImageView()
        //imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    var titleLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello EveryOne"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    
    var descriptionTextView : UITextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.white
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        
        return textView
    }()

    
    
    func setBaseViewCons(){
        
        baseView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    
   
    
    
    // MARK : - Setting COnstraints
    
    func setImageConstraints(){
           
          refImageView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant:  10).isActive = true
          refImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 8).isActive = true
          refImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
          refImageView.widthAnchor.constraint(equalTo: refImageView.heightAnchor, multiplier: 16/9).isActive = true
       
    }
    
    func setTitleLabelCons(){
           
        titleLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant : 5).isActive        = true
        titleLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant : 5).isActive      = true
        titleLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5).isActive    = true
        titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 5).isActive = true
       }

    func setDescCons() {
        
        descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive  = true
        descriptionTextView.leftAnchor.constraint(equalTo: refImageView.rightAnchor, constant: 5).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5).isActive = true
        // descriptionTextView.bottomAnchor.constraint(equalTo: self.refImageView.topAnchor).isActive = true
    }

  
   

   
    
}


extension TableViewCell {
    
    
    func parseImg(url: String?){
        
        let activityIndicator = UIActivityIndicatorView()
        
        imageUrlString = url
        self.refImageView.image = nil
        
        if let refimagUrl = url {
            
            
            // setup activityIndicator...
            activityIndicator.color = .darkGray
            
            addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: refImageView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: refImageView.centerYAnchor).isActive = true
            activityIndicator.startAnimating()
            
            
            if let image = imageCache.object(forKey: url as AnyObject) as? UIImage{
                if self.imageUrlString == url {
                    self.refImageView.image = image
                    activityIndicator.stopAnimating()
                }
                
                
            }
            URLSession.shared.dataTask(with: URL(string: refimagUrl)!, completionHandler: {(data, response, error) -> Void in
                
                if error != nil {
                    print(error as Any)
                    DispatchQueue.main.async(execute: {
                        activityIndicator.stopAnimating()
                    })
                    return
                }
                
                
                DispatchQueue.main.async(execute: {
                    
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        if self.imageUrlString == url {
                            self.refImageView.image = imageToCache
                        }
                        
                        
                    }
                    activityIndicator.stopAnimating()
                })
            }).resume()
            
            
            
            
        }
    }
    
}

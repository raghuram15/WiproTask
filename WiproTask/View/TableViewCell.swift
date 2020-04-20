//
//  TableViewCell.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    var imageUrlString : String?
    var viewModel = DataViewModel()
    
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
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    var titleLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
       
        return label
    }()
    
    
    var descriptionTextView : UITextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.white
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
       
        return textView
    }()

    
    
    func setBaseViewCons(){
        
        baseView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
       let con = baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
       con.priority = UILayoutPriority(999)
       con.isActive = true
        baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    
   
    
    
    // MARK : - Setting COnstraints
    
    func setImageConstraints(){
           
        refImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 1).isActive = true
          refImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 8).isActive = true
          refImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
          refImageView.widthAnchor.constraint(equalTo: refImageView.heightAnchor, multiplier: 16/9).isActive = true
       
    }
    
    func setTitleLabelCons(){
           
        titleLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant : 12).isActive        = true
        titleLabel.leftAnchor.constraint(equalTo:  refImageView.rightAnchor, constant : 5).isActive      = true
        titleLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5).isActive    = true
       // titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 5).isActive = true
       }

    func setDescCons() {
        
        descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive  = true
        descriptionTextView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        // descriptionTextView.bottomAnchor.constraint(equalTo: self.refImageView.topAnchor).isActive = true
    }

    
   

   
    
}


extension TableViewCell {
    
    
    
    
    func setData(data : Animals) {
        titleLabel.text = data.title
        descriptionTextView.text = data.description
        parseImg(url: data.imageHref)
        
    }
    

    func parseImg(url: String?){
        
        guard let url = url else {
           
            return
        }
        
        
        let activityIndicator = UIActivityIndicatorView()
        
        imageUrlString = url
        self.refImageView.image = nil
        
         
        // setup activityIndicator...
        activityIndicator.color = .darkGray
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: refImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: refImageView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        
        if let image = viewModel.imageCache.object(forKey: url as AnyObject) as? UIImage{
            if self.imageUrlString == url {
                self.refImageView.image = image
                activityIndicator.stopAnimating()
            }
            
            
        }
        
        
        viewModel.getImageData(imageUrl: url, completion: { [weak self]  data in
            guard let self = self else {return}
            DispatchQueue.main.async(execute: {
                
                switch data {
                case .failure(let _):
                    
                    activityIndicator.stopAnimating()
                    
                case .success(let dta) :
                   
                    
                    if let imageToCache = UIImage(data: dta){
                        self.viewModel.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        self.refImageView.image = imageToCache
                    }
                    activityIndicator.stopAnimating()
                }
                
                
            })
            
            
            
        })
        
    }
    
}

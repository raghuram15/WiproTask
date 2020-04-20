//
//  ViewController.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

     var indicator = UIActivityIndicatorView()
     var viewModel = DataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
        tableView.backgroundColor = UIColor(red: 0, green : 102/255, blue: 0, alpha: 1)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshUI), for: .valueChanged)
        self.refreshControl = refreshControl
             
    }
    
    
    @objc func refreshUI() {
        loadData()
        refreshControl?.endRefreshing()
    }
    
    
     func alertUser(msg : String){
           
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
        self.loadData()
        }))
        self.present(alert, animated: true, completion: nil)
       }
       
    
   

   
     func loadData(){
            
        startAnimating()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.cellId)
         viewModel.fetchBreaches { [weak self]  data in
           
               DispatchQueue.main.async {
                   self?.stopAnimating()
                    switch data {
                    case .failure(let error):
                        
                        self!.alertUser(msg: error.localizedDescription)
                        
                    case .success(let _) :
                      self!.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    





extension TableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataMdl.rows.count
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! TableViewCell
          cell.tag = indexPath.row
          let data = viewModel.dataMdl.rows[indexPath.row]
        self.title = viewModel.dataMdl.title
          cell.selectionStyle = .none
          cell.setData(data: data)
           return cell
          
          
          
      }
      
      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        
        let data = viewModel.dataMdl.rows[indexPath.item]
        
        if let _ = data.description, let _ = data.imageHref, let _ = data.title{

        if let statusText = viewModel.dataMdl.rows[indexPath.item].description {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width / 2.5, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
                return rect.height + 130
            
        }
        return 140
        }
        
       
        
        if ((data.description != nil) && (data.imageHref == nil)) {
            let rect = NSString(string: data.description!).boundingRect(with: CGSize(width: view.frame.width / 2.5, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
                return rect.height + 125
            
        }else if ((data.description == nil) && (data.imageHref != nil)) {
            return 150
        }
      
        
            return 0
        
    }
}

extension TableViewController {
    
    
    //MARK: Activity Indicator
    
    func activityIndicator() {
           indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
           indicator.style = UIActivityIndicatorView.Style.large
           indicator.center = self.view.center

           self.view.addSubview(indicator)
       }
       
       func startAnimating(){
           activityIndicator()
           indicator.startAnimating()
           indicator.color = .white
          // indicator.backgroundColor = .white
       }
       
       func stopAnimating(){
           
           indicator.stopAnimating()
           indicator.hidesWhenStopped = true
       }
       
    
}

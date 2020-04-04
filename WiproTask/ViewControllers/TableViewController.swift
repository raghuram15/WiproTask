//
//  ViewController.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

       var dataMdl = DataModel(title: "", rows: [])
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
    
     func loadData(){
            
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.cellId)
            
        viewModel.fetchBreaches { [weak self]  data in
                
                DispatchQueue.main.async {
                    switch data {
                    case .failure(let error):
                        print ("failure", error)
                        
                    case .success(let dta) :
                        print(dta)
                        self!.dataMdl = dta
                        self?.title = dta.title
                        print(data)
                        self!.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    





extension TableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataMdl.rows.count
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! TableViewCell
          cell.tag = indexPath.row
          let data = dataMdl.rows[indexPath.row]
          cell.titleLabel.text = data.title
          cell.selectionStyle = .none
          cell.descriptionTextView.text = data.description
          cell.parseImg(url: data.imageHref)
            
       
            return cell
          
          
          
      }
      
      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let data = dataMdl.rows[indexPath.item]
        
        if let _ = data.description, let _ = data.imageHref, let _ = data.title{

        if let statusText = dataMdl.rows[indexPath.item].description {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width / 2, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
                print(rect.height, "heighttttt@#")
                return rect.height + 120
            
        }
        
        
        return 140
        }
            return 0
        
    }
}

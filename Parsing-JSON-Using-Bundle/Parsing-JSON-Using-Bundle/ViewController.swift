//
//  ViewController.swift
//  Parsing-JSON-Using-Bundle
//
//  Created by Tiffany Obi on 8/3/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main //tableView has one section
    }
    typealias DataSource = UITableViewDiffableDataSource<Section,President>
    //both the SectionItemIdentifier and the ItemIdentifier needs to conform to the hashable protocol
    private var dataSource:DataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureDataSource()
        fetchPresidents()
    }
    
    func configureDataSource(){
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, president) -> UITableViewCell? in
            let presCell = tableView.dequeueReusableCell(withIdentifier: "presCell", for: indexPath)
            presCell.textLabel?.text = president.name
            presCell.detailTextLabel?.text = "\(president.number)"
            return presCell
        })
        
        //set up snapshot
          var snapshot = NSDiffableDataSourceSnapshot<Section,President>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func fetchPresidents(){
        var presidents: [President] = []
        
        do {
             presidents = try Bundle.main.parseJSON(with: "presidents")
        }catch {
            print("error: \(error)")
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(presidents, toSection: .main)
         dataSource.apply(snapshot, animatingDifferences: true)
    }
    
  override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view.
     }

}


//
//  StationsController.swift
//  Parsing_JSON_Using_URLSession
//
//  Created by Tiffany Obi on 8/4/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Combine

class StationsController: UIViewController {
    
    //create an enum to represent out table view sections
    //todo: user "region_id" to create multiple sectins
    
    enum Section {
        case primary
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource:DataSource!
    
    let apiClient = APIClient()
    
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchData()
        fetchDataUsingCombine()
        configureDataSource()
        navigationController?.title = "Citi Bike Stations"
    }

    private func fetchData(){
        //result type has 2 values
        apiClient.fetchData { [weak self](result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let stations):
                DispatchQueue.main.async {
                    self?.updateSnapshot(with: stations)
                }
            }
        }
    }
    private func fetchDataUsingCombine() {
        do {
            let _ = try apiClient.fetchData()
                .sink(receiveCompletion: { (completion) in
                    print(completion)
                }, receiveValue: { [weak self](stations) in
                    self?.updateSnapshot(with: stations)
                })
                .store(in:&subscriptions)
        } catch {
            print(error)
        }
    }
    
    private func updateSnapshot(with stations: [Station]){
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(stations, toSection: .primary)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    private func configureDataSource(){
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, station) -> UITableViewCell? in
            let stationCell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)
            
            stationCell.textLabel?.text = station.name
            stationCell.detailTextLabel?.text = "Bike Capacity: \(station.capacity)"
            
            return stationCell
           })
        
            //set up initial
            var snapshot = NSDiffableDataSourceSnapshot<Section,Station>()
            snapshot.appendSections([.primary])
            dataSource.apply(snapshot,animatingDifferences: false)
    }
    
//place in its own file
// Todo: continue to implement in order to show the section header title
    //subclass UiTableViewDiffabeDataSource
    class DataSource: UITableViewDiffableDataSource<StationsController.Section, Station>{}
}


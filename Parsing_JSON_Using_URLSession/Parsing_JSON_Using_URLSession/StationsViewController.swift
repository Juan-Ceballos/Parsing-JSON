//
//  ViewController.swift
//  Parsing_JSON_Using_URLSession
//
//  Created by Juan Ceballos on 8/4/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Combine

class StationsViewController: UIViewController {
    
    enum Section {
        case primary
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: DataSource!
    
    let apiClient = APIClient()
    
    // combine
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        //fetchData()
        fetchDataUsingCombine() // combine same result
    }

    private func fetchData()    {
        // Result type has two values
        // 1. .failure() or 2. .success()
        apiClient.fetchData { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let stations):
                dump(stations)
                DispatchQueue.main.async {
                    self?.updateSnapshot(with: stations)
                }
            }
        }
    }
    
    // **Added for Combine**
    private func fetchDataUsingCombine()    {
        /*
            .sink - receive values
            .assign - binds a value to a property or UI element
         */
        do {
            let _ = try apiClient.fetchData()
                .sink(receiveCompletion: { (completion) in
                    print(completion)
                }, receiveValue: { [weak self] (stations) in
                    self?.updateSnapshot(with: stations)
                })
            .store(in: &subscriptions)
        } catch  {
            print(error)
        }
    }
    
    private func updateSnapshot(with stations: [Station]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(stations, toSection: .primary)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureDataSource()  {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, station) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = station.name
            cell.detailTextLabel?.text = station.capacity.description
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Station>()
        snapshot.appendSections([.primary])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    

}


class DataSource: UITableViewDiffableDataSource<StationsViewController.Section, Station> {
    // implement UITableViewDataSource methods here
}

//
//  ViewController.swift
//  Parsing-JSON-Using-Bundle
//
//  Created by Juan Ceballos on 8/3/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Section {
        case main // table view has only one section
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Datasource = UITableViewDiffableDataSource<Section, President>
    
    // both the sectionItemIdentifier and the ItemIdentifier needs to conform to
    // the Hashable protocol e.g 01
    private var dataSource: Datasource!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureDataSource()
        fetchingPresidents()
    }

    private func configureDataSource()   {
        dataSource = Datasource(tableView: tableView, cellProvider: { (tableView, indexPath, president) -> UITableViewCell? in
            // configure cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = president.name
            cell.detailTextLabel?.text = president.number.description
            return cell
        })
        
        // setup initial snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, President>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func fetchingPresidents()   {
        var presidents: [President] = []
        do {
            presidents = try Bundle.main.parseJSON(with: "presidents")
        } catch {
            print(error)
            // TODO: present an alert
        }
        
        // update the snapshot
        var snapshot = dataSource.snapshot() // query dataSource for the current snapshot
        snapshot.appendItems(presidents, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}


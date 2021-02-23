//
//  ViewController.swift
//  FlightsNostalgia
//
//  Created by hyperactive on 19/01/2021.
//

import UIKit

class FlightsDisplayViewController: UIViewController {

    var flights: [Flight] = []
    var tableView: UITableView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func parseJSON(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            flights = try decoder.decode([Flight].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        view.pin(view: tableView, with: .zero)
    }
 }

extension FlightsDisplayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.flightsCellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.flightsCellIdentifier)
        }
        
        let flight = flights[indexPath.row]
       
        cell!.textLabel?.text = "\(flight.from): \(flight.to)"
        cell!.detailTextLabel?.text = "\(flight.fromTime) \(flight.toTime) \(flight.cost) \(flight.date) \(flight.duration)"
        
        
        return cell!
    }
}

extension FlightsDisplayViewController: UITableViewDelegate {
    
}


//
//  TableViewController.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import UIKit

/// Home view of the application.

class TableViewController: UITableViewController {
    
    /// The data used to set the tableView.
    
    public private(set) var data: [[NSDictionary]] = []
    
    /// The index selected by the user to see thes details of the event.

    private var selectedIndex: IndexPath!
    
    /**
     Sort events by dates.
     
     - returns: The data to set in the tableView.
     
     - parameter json: json of the response of get events request.
     
     - remark: With DateFormatter version.
     */
    
/*    private func sortEvents(json: [NSDictionary]) -> [[NSDictionary]] {
        var ret: [[NSDictionary]] = []
        var idx = 0
        while idx < json.count {
            if idx + 1 < json.count, let date = (json[idx]["dateStart"] as! String).utcToDate(), let next = (json[idx + 1]["dateStart"] as! String).utcToDate(), date.compare(next) == ComparisonResult.orderedDescending {
                json[idx].setValue(json[idx + 1]["dateStart"] as! String, forKey: "dateStart")
                json[idx + 1].setValue(json[idx]["dateStart"] as! String, forKey: "dateStart")
                idx = -1
            }
            idx += 1
        }
        ret.append([json.first!])
        var previous = (json.first!["dateStart"] as! String).utcToDate()!
        _ = json.dropFirst()
        for idx in 0..<json.count {
            if let date = (json[idx]["dateStart"] as! String).utcToDate() {
                if Calendar.current.isDate(date, equalTo: previous, toGranularity: .month) {
                    ret[ret.count - 1].append(json[idx])
                }
                else {
                    ret.append([json[idx]])
                    previous = date
                }
            }
        }
        return ret
    }*/
    
    /**
     Sort events by dates.
     
     - returns: The data to set in the tableView.
     
     - parameter json: json of the response of get events request.
     
     - remark: without DateFormatter version.
     */
    
    private func sortEvents(json: [NSDictionary]) -> [[NSDictionary]] {
        var ret: [[NSDictionary]] = []
        var idx = 0
        while idx < json.count {
            if let date = json[idx]["dateStart"] as? String, json.count > idx + 1, let next = json[idx + 1]["dateStart"] as? String, date > next {
                json[idx].setValue(next, forKey: "dateStart")
                json[idx + 1].setValue(date, forKey: "dateStart")
                idx = -1
            }
            idx += 1
        }
        ret.append([json.first!])
        var previousComponents: [String] = (json.first!["dateStart"] as! String).components(separatedBy: CharacterSet(charactersIn: "-T"))
        _ = json.dropFirst()
        for idx in 0..<json.count {
            if let components = (json[idx]["dateStart"] as? String)?.components(separatedBy: CharacterSet(charactersIn: "-T")), components.count > 3 {
                if previousComponents[0] == components[0] && previousComponents[1] == components[1] {
                    ret[ret.count - 1].append(json[idx])
                }
                else {
                    ret.append([json[idx]])
                }
                previousComponents = components
            }
        }
        return ret
    }
    
    /// Called at pull to refresh.
    
    @objc internal func refresh() {
        if let url = URL(string: "http://res.cloudinary.com/nomadeducation/raw/upload/v1510821111/events_uqwefr.json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                if let unwrappedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as! [NSDictionary]
                        DispatchQueue.main.async {
                            if !json.isEmpty {
                                self.data = self.sortEvents(json: json)
                            }
                            UIView.animate(withDuration: 0.5) {
                                self.tableView.alpha = 1
                            }
                            self.tableView.reloadData()
                        }
                    }
                    catch let error {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    /**
     Initialization of th view.
     
     - returns: Nothing.
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alpha = 0
        clearsSelectionOnViewWillAppear = true
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Tirez pour rafraichir")
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.estimatedRowHeight = 166
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (data[section].first!["dateStart"] as? String)?.utcToString(to: "MMMM yyyy")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.event = data[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "HomeToDetail", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDetail", let dst = segue.destination as? DetailViewController {
            dst.data = data[selectedIndex.section][selectedIndex.row]
        }
    }

}

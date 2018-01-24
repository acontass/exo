//
//  DetailViewController.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import UIKit
import EventKit

/// The detailed view of an event.

class DetailViewController: UIViewController {
    
    /// Title label at top of the view.
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Location label of the view.
    
    @IBOutlet weak var locationLabel: UILabel!
    
    /// Date label of the view.
    
    @IBOutlet weak var dateLabel: UILabel!
    
    /// Content text view of this view.
    
    @IBOutlet weak var contentTextView: UITextView!
    
    /// The data of the event to display.
    
    public var data: NSDictionary!
    
    /// Called before the view appears, used to hide the navigation bar.
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /// Initialization of the view.

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = data["title"] as? String
        locationLabel.text = ""
        if let address = data["address"] as? NSDictionary {
            let addressKeys = ["streetAddress", ", ", "zipCode", " ", "cityName", ", ", "countryName"]
            for key in addressKeys {
                if key == ", " || key == " " {
                    locationLabel.text = locationLabel.text! + key
                }
                else if let value = address[key] as? String {
                    locationLabel.text = locationLabel.text! + value
                }
            }
        }
        dateLabel.text = (data["dateStart"] as? String ?? "").utcToString(to: "EEEE, MMM d, yyyy")
        contentTextView.text = (data["content"] as? String)?.htmlString
    }
    
    /// Action called when back button at top left of the view is touched.
    
    @IBAction func backTouched() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Action called when share button at top right of the view is touched.
    
    @IBAction func shareTouched() {
        let activityVC = UIActivityViewController(activityItems: [titleLabel.text ?? "", contentTextView.text], applicationActivities: nil)
        activityVC.setValue("test", forKey: "subject")
        self.present(activityVC, animated: true, completion: nil)
    }
    
    /// Action called when location button of the view is touched.
    
    @IBAction func locationTouched() {
        performSegue(withIdentifier: "DetailToMap", sender: self)
    }

    /// Action called when "Add to calendar" button at bottom of the view is touched.
    
    @IBAction func addToCalendarTouched() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = self.titleLabel.text
                    event.startDate = (self.data["dateStart"] as? String ?? "").utcToDate() ?? Date()
                    event.endDate = (self.data["dateEnd"] as? String ?? "").utcToDate() ?? Date()
                    event.notes = self.titleLabel.text
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    }
                    catch let error {
                        let alert = Tools.createAlert(title: nil, message: error.localizedDescription, buttons: "Ok", completion: nil)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    let alert = Tools.createAlert(title: nil, message: "Added to your calendar.", buttons: "Ok", completion: nil)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = Tools.createAlert(title: nil, message: "Error.", buttons: "Cancel", completion: nil)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    /// Used to share data on MapViewController.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToMap", let dst = segue.destination as? MapViewController {
            dst.address = locationLabel.text
            dst.titleStr = titleLabel.text
        }
    }
}

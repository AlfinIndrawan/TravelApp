//
//  ViewController.swift
//  TravelApp
//
//  Created by Alfin on 11/02/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()

  }
}
extension ViewController: MKMapViewDelegate {

}

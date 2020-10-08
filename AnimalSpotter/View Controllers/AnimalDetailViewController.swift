//
//  AnimalDetailViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalDetailViewController: UIViewController {
    
    var apiController: APIController?
    var animalName: String?
    
    // MARK: - Properties
    
    @IBOutlet weak var timeSeenLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }
    
    func getDetails() {
        guard let apiController = apiController,
              let animalName = animalName else { return }
        apiController.fetchDetails(for: animalName) { (result) in
            switch result {
            case .success(let animal):
                DispatchQueue.main.async {
                    self.updateViews(with: animal)
                }
                apiController.fetchImage(at: animal.imageURL) { (result) in
                    if let image = try? result.get() {
                        DispatchQueue.main.async {
                            self.animalImageView.image = image
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching animal details \(error)")
            }
        }
    }
    
    func updateViews(with animal: Animal) {
        title = animal.name
        descriptionLabel.text = animal.description
        coordinatesLabel.text = "lat: \(animal.latitude), long: \(animal.longitude)"
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        timeSeenLabel.text = df.string(from: animal.timeSeen)
    }
}

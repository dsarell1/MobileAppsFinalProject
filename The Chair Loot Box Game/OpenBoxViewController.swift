//
//  OpenBoxViewController.swift
//  The Chair Loot Box Game
//
//  Created by Dylan Sarell on 12/12/23.
//

import UIKit

let allChairs = ["gaminChair", "gaminChair", "gaminChair", "greenChair", "greenChair", "greenChair", "greenChair", "greenChair", "kidChair", "kidChair", "kidChair", "kidChair", "kidChair", "kidChair", "kingChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "metalChair", "officeChair", "officeChair", "officeChair", "rockinChair", "rockinChair", "spiderChair", "spiderChair", "spiderChair", "spongebobChair", "bedroomChair", "bedroomChair", "bedroomChair", "bedroomChair", "barberChair", "campingChair", "campingChair", "campingChair", "campingChair", "comfyOfficeChair", "comfyOfficeChair", "comfyOfficeChair", "comfyOfficeChair", "lawnChair", "lawnChair", "lawnChair", "lawnChair", "lawnChair", "oldSchoolChair", "oldSchoolChair", "oldSchoolChair", "plasticChair", "plasticChair", "plasticChair", "plasticChair", "plasticChair", "plasticChair", "rockChair", "rockChair", "rockChair", "rockChair", "rockChair", "rockChair", "rockChair", "ChairAlien", "ChairAlien", "ChairAlien", "ChairAlien", "ChairAlien", "ChairAlien2", "ChairAlien2", "ChairAlien2", "ChairAlien2", "ChairAlien3"]

class OpenBoxViewController: UIViewController {

    @IBOutlet weak var chairTypeLabel: UILabel!
    
    @IBOutlet weak var chairImage: UIImageView!
    var isDuplicate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomChair()

        // Do any additional setup after loading the view.
    }
    func randomChair() {
        let randomChairType = allChairs.randomElement()!
        chairTypeLabel.text = "Congrats You Got A \(randomChairType)"
        chairImage.image = UIImage(named: randomChairType)
        
        for chair in myChairs {
            if chair == randomChairType {
                isDuplicate = true
            }
        }
        if !isDuplicate {
            myChairs.append(randomChairType)
            UserDefaults.standard.setValue(myChairs, forKey: "ChairCollection")
        }
        else {
            isDuplicate = false
        }
    }
}

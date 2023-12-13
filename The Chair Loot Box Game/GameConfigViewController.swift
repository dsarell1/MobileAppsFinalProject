//
//  GameConfigViewController.swift
//  The Chair Loot Box Game
//
//  Created by Dylan Sarell on 12/12/23.
//

import UIKit

class GameConfigViewController: UIViewController {

    
    @IBOutlet weak var alienSpawnRateLabel: UILabel!
    @IBOutlet weak var chairSpeedLabel: UILabel!
    @IBOutlet weak var blasterSpeedLabel: UILabel!
    
    
    @IBOutlet weak var spawnRate: UISlider!
    @IBOutlet weak var chairSpeed: UISlider!
    @IBOutlet weak var blasterSpeed: UISlider!
    
    @IBAction func AlienSpawnRateSlider(_ sender: UISlider) {
        
        let rate = sender.value
        self.alienSpawnRateLabel.text = "Alien Spawn Rate: " + String(sender.value)
        UserDefaults.standard.setValue(rate, forKey: "AlienSpawnRate")
        UserDefaults.standard.setValue(false, forKey: "DefaultMode")
    }
    
    @IBAction func AlienChairSpeedSlider(_ sender: UISlider) {
        let cSpeed = sender.value
        self.chairSpeedLabel.text = "Alien Chair Speed: " + String(sender.value)
        UserDefaults.standard.setValue(cSpeed, forKey: "ChairAnimationDur")
        UserDefaults.standard.setValue(false, forKey: "DefaultMode")
    }
    @IBAction func blasterFireSpeedSlider(_ sender: UISlider) {
        let bSpeed = sender.value
        self.blasterSpeedLabel.text = "Blaster Fire Speed: " + String(sender.value)
        UserDefaults.standard.setValue(bSpeed, forKey: "FireAnimationDur")
        UserDefaults.standard.setValue(false, forKey: "DefaultMode")
    }
    
    @IBAction func DefaultsButton(_ sender: UIButton) {
        spawnRate.value = 1.0
        self.alienSpawnRateLabel.text = "Alien Spawn Rate: " + String(spawnRate.value)
        UserDefaults.standard.setValue(spawnRate.value, forKey: "AlienSpawnRate")
        chairSpeed.value = 6.0
        self.chairSpeedLabel.text = "Alien Chair Speed: " + String(chairSpeed.value)
        UserDefaults.standard.setValue(chairSpeed.value, forKey: "ChairAnimationDur")
        blasterSpeed.value = 0.3
        self.blasterSpeedLabel.text = "Blaster Fire Speed: " + String(blasterSpeed.value)
        UserDefaults.standard.setValue(blasterSpeed.value, forKey: "FireAnimationDur")
        UserDefaults.standard.setValue(true, forKey: "DefaultMode")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let alienRate = UserDefaults.standard.string(forKey: "AlienSpawnRate") {
            spawnRate.value = Float(alienRate) ?? 1.0
            self.alienSpawnRateLabel.text = "Alien Spawn Rate: " + String(spawnRate.value)
        } else {
            spawnRate.value = 1.0
            self.alienSpawnRateLabel.text = "Alien Spawn Rate: " + String(spawnRate.value)
        }
        if let chairDur = UserDefaults.standard.string(forKey: "ChairAnimationDur") {
            chairSpeed.value = Float(chairDur) ?? 6.0
            self.chairSpeedLabel.text = "Alien Chair Speed: " + String(chairSpeed.value)
        } else {
            chairSpeed.value = 6.0
            self.chairSpeedLabel.text = "Alien Chair Speed: " + String(chairSpeed.value)
        }
        if let fireDur = UserDefaults.standard.string(forKey: "FireAnimationDur") {
            blasterSpeed.value = Float(fireDur) ?? 0.3
            self.blasterSpeedLabel.text = "Blaster Fire Speed: " + String(blasterSpeed.value)
        } else {
            blasterSpeed.value = 0.3
            self.blasterSpeedLabel.text = "Blaster Fire Speed: " + String(blasterSpeed.value)
        }

    }

}

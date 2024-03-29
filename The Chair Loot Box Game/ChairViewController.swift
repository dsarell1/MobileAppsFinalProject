//
//  ChairViewController.swift
//  The Chair Loot Box Game
//
//  Created by Dylan Sarell on 12/11/23.
//

import UIKit


class ChairViewController: UIViewController {
    
    let lootBoxPrice = 100000

    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lootBox: UIImageView!
    
    
    @IBAction func buyButton(_ sender: UIButton) {
        openLootBox()
    }
    
    var money = 0 {
        didSet {
            self.totalScore.text = "Total Money: \(self.money)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let totalMoney = UserDefaults.standard.string(forKey: "LootBoxMoney") {
            self.money = Int(totalMoney) ?? 0
            print(self.money)
        }
        if let chairs = UserDefaults.standard.object(forKey: "ChairCollection") as? [String] {
            myChairs = chairs
        }
        if let mode = UserDefaults.standard.string(forKey: "DefaultMode") {
            if Int(mode) == 1 {
                defaultMode = true
            }
            else if Int(mode) == 0 {
                defaultMode = false
            }
        } else {
            UserDefaults.standard.setValue(true, forKey: "DefaultMode")
        }
    }
    func setup() {
        costLabel.text = "Cost: \(self.lootBoxPrice) Moneyz"
        
    }
    
    func openLootBox() {
        if self.money >= self.lootBoxPrice {
            self.performSegue(withIdentifier: "OpenBox", sender: self)
            self.money -= self.lootBoxPrice
            UserDefaults.standard.setValue(self.money, forKey: "LootBoxMoney")
        }
    }

}

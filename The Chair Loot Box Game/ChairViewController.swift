//
//  ChairViewController.swift
//  The Chair Loot Box Game
//
//  Created by Guest User on 12/11/23.
//

import UIKit




class ChairViewController: UIViewController {

    @IBOutlet weak var totalScore: UILabel!
    var money = 0 {
        didSet {
            self.totalScore.text = "Total Money: \(self.money)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let totalMoney = UserDefaults.standard.string(forKey: "LootBoxMoney") {
            self.money = Int(totalMoney) ?? 0
            print(self.money)
        }
    }
    func openLootBox() {
        
    }

}

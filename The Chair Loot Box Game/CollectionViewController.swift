//
//  CollectionViewController.swift
//  The Chair Loot Box Game
//
//  Created by Dylan Sarell on 12/11/23.
//

import UIKit

var myChairs: [String] = []


class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var chairCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chairCollection.delegate = self
        chairCollection.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let chairs = UserDefaults.standard.object(forKey: "ChairCollection") as? [String] {
            myChairs = chairs
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myChairs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chairCollection.dequeueReusableCell(withReuseIdentifier: "chairCell", for: indexPath) as! ChairCell
        
        cell.chairImageView.image = UIImage(named: myChairs[indexPath.row])
        cell.chairName.text = myChairs[indexPath.row]
        
        return cell
    }
}

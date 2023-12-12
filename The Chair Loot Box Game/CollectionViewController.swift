//
//  CollectionViewController.swift
//  The Chair Loot Box Game
//
//  Created by Guest User on 12/11/23.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let chairs = ["gaminChair", "greenChair", "kidChair", "kingChair", "metalChair", "officeChair", "rockinChair", "spiderChair", "spongebobChair"]

    @IBOutlet weak var chairCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chairCollection.delegate = self
        chairCollection.dataSource = self

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chairs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chairCollection.dequeueReusableCell(withReuseIdentifier: "chairCell", for: indexPath) as! ChairCell
        
        cell.chairImageView.image = UIImage(named: chairs[indexPath.row])
        cell.chairName.text = chairs[indexPath.row]
        
        return cell
    }
}

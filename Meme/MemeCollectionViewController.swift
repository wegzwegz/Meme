//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Waged Baioumy on 05.01.22.
//


import Foundation
import UIKit

class MemeCollectionViewController : UIViewController {
    
    
    // MARK: Properties
    @IBOutlet var memeCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memesHere: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        print(appDelegate.memes)
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tableView viewWillAppear")
        memeCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        // layout.itemSize = CGSize(width: 120, height: 200)
        let flowLayout = UICollectionViewFlowLayout()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        memeCollectionView.collectionViewLayout = flowLayout
        memeCollectionView.register(MemeCollectionViewCell.nib(), forCellWithReuseIdentifier: MemeCollectionViewCell.identifier)
        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
    }
    
    func configureNav(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus") , style: .done, target: self, action: #selector(createMeme(sender:)))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    @objc func createMeme(sender: UIBarButtonItem){
        print("open meme editor!")
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController else{
            print("failed to initiate VC!")
            return
        }
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MemeCollectionViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me in collection!")
        let meme = memesHere[indexPath.row]
        print(meme.topText)
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController else{
            print("failed to initiate VC!")
            return
        }
        present(vc, animated: true)
        NotificationCenter.default.post(name: Notification.Name("MeMe"), object: meme)
    }
}
extension MemeCollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memesHere.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.identifier, for: indexPath) as! MemeCollectionViewCell
        
        let meme = memesHere[indexPath.row]
        cell.configure(with: meme.memedImage)
        return cell
    }
}

extension MemeCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) ->
    CGSize {
        // layout.itemSize = CGSize(width: 120, height: 200)
        let flowLayout = UICollectionViewFlowLayout()
        let space:CGFloat = 3.0
       
        var dimension:CGFloat
    
    
        if(UIDevice.current.orientation.isPortrait)
        {
           // do something for Portrait mode
             dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        else
        {
           // do something for Landscape mode
             dimension = (view.frame.size.height - (2 * space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        return CGSize(width: dimension, height: dimension)
    }
}

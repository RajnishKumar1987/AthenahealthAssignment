//
//  ContentListViewController.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import UIKit

class ContentListViewController: UIViewController {
    
    var viewModel : ContentListViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfig()
    }
    
    func doInitialConfig() {
        loadData()
    }
    
    func loadData() {
        self.showLoader(onViewController: self)
        viewModel.loadContentList { [weak self] (result) in
            switch result{
            case .success:
                self?.collectionView.reloadData()
                self?.removeLoader(fromViewController: self!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "contentDetails", let cell = sender as? ContentCollectionViewCell {
            if  let detailsVC = segue.destination as? ContentDetailsViewController, let indexPath = collectionView.indexPath(for: cell), let model =  viewModel.getContentCellModel(for: indexPath) {
                detailsVC.viewModel = ContentDetailsViewModel(with: model.id ?? "")
            }
        }
    }
}

extension ContentListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getCellCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContentCollectionViewCell
        cell.configureCell(with: viewModel.getContentCellModel(for: indexPath))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width - 30)/2, height: (collectionView.frame.width/2) + 20)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }
}

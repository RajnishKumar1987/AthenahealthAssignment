//
//  NewReleasesViewController.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import UIKit

class NewReleasesViewController: UIViewController {

    var contentListViewController: ContentListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newReleases" {
            
            if  let listVC = segue.destination as? ContentListViewController{
                listVC.viewModel = ContentListViewModel(with: .newRelease)
            }
        }
        
    }
    

}

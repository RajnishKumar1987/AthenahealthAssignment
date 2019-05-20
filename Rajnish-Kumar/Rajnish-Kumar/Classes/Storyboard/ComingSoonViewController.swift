//
//  ComingSoonViewController.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import UIKit

class ComingSoonViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "comingSoon" {
                        if  let listVC = segue.destination as? ContentListViewController{
                listVC.viewModel = ContentListViewModel(with: .comingSoon)
                listVC.title = "fddfg"
            }
        }
    }
    
}

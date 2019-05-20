//
//  DetailsViewController.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import UIKit
import SDWebImage

class ContentDetailsViewController: UIViewController {
    
    var viewModel: ContentDetailsViewModel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblGeners: UILabel!
    @IBOutlet weak var lblRecordedLabel: UILabel!
    @IBOutlet weak var copyRight: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ContentDetailsViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        doInitialConfig()
    }
    
    func doInitialConfig()  {
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.navigationBar.isHidden = true
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadData() {
        showLoader(onViewController: self)
        viewModel.loadContentDetails {[weak self] (result) in
            switch result{
            case .success:
                self?.updateUI()
            case .failure(let error):
                print(error)
                self?.removeLoader(fromViewController: self!)
            }
        }
    }
    
    func updateUI() {
      
        self.imageView.sd_setImage(with: URL(string: viewModel.dataModel.artworkUrl ?? ""), placeholderImage: UIImage.init(named: "placeholder"))
        lblTitle.text = viewModel.dataModel.title
        lblArtist.text = viewModel.dataModel.artists
        lblGeners.text = viewModel.dataModel.genres
        lblRecordedLabel.text = viewModel.dataModel.recordedLabel
        lblReleaseDate.text = viewModel.dataModel.releaseDate
        copyRight.text = viewModel.dataModel.copyRight
        tableView.reloadData()
        self.removeLoader(fromViewController: self)
    }
    
    func expendDetailsContainerView(height: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.detailsContainerView.frame = CGRect(x: self.detailsContainerView.frame.origin.x, y: self.detailsContainerView.frame.origin.y, width: self.detailsContainerView.frame.width, height: self.detailsContainerView.frame.height + height)
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y+height, width: self.tableView.frame.width, height: self.tableView.frame.height)
        })
    }
    
    @objc func finishVideo()
    {
        selectedIndex = nil
        tableView.reloadData()
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        sender.isSelected ? expendDetailsContainerView(height: -200) : expendDetailsContainerView(height: 200)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ContentDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModel.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackTableViewCell
        cell.configureCell(with: viewModel.dataModel.tracks[indexPath.item])
        if indexPath == selectedIndex {
            cell.isSelected = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trackModel = viewModel.dataModel.tracks[indexPath.item]
        if trackModel.hasPreview {
            let playerItem = PlayerItemMetaData()
            playerItem.playbackURL = trackModel.previewUrl
            playerItem.title  = trackModel.title
            
            if selectedIndex == indexPath{
                selectedIndex = nil
                PlayerManager.shared.avPlayer.pause()
            }else{
                selectedIndex = indexPath
                PlayerManager.shared.initilizePlayerWith(item: playerItem)

            }
           self.tableView.reloadData()
            
        }
       
    }
    
}

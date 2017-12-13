//
//  MainViewController.swift
//  HereCandiddatesHW
//
//  Created by Perry on 12/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

class MainViewController: HViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var toggleListButton: UIButton!
    @IBOutlet weak var cabsListTableView: UITableView!
    @IBOutlet weak var tableMarginTopConstraint: NSLayoutConstraint!

    var cabsList: [CabOrderInfo]?

    override func viewDidLoad() {
        super.viewDidLoad()

        cabsListTableView.getRoundedCornered()
        cabsListTableView.layer.borderWidth = 1
        cabsListTableView.layer.borderColor = UIColor.black.cgColor

        toggleListButton.setTitle("hide results".localized(), for: UIControlState.normal)
        toggleListButton.onClick { [weak self] _ in
            //guard let strongSelf = self else { return }
            self?.toggleListAppearance()
        }
    }
    
    func toggleListAppearance() {
        if 0 == tableMarginTopConstraint.constant {
            toggleListButton.setTitle("show results".localized(), for: UIControlState.normal)
            let newHeight = UIScreen.main.bounds.height - (toggleListButton.bounds.height + toggleListButton.bounds.origin.y) - 100
            tableMarginTopConstraint.constant = newHeight
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: UIViewAnimationOptions.curveEaseOut, animations: { [weak self] in
                self?.cabsListTableView.layoutIfNeeded()
            }, completion: nil)
        } else {
            toggleListButton.setTitle("hide results".localized(), for: UIControlState.normal)
            tableMarginTopConstraint.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6.0, options:
                UIViewAnimationOptions.curveEaseOut, animations: { [weak self] in
                    self?.cabsListTableView.layoutIfNeeded()
                }, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cabsList = DataManager.shared.cabsList
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(onDataRefreshed(notification:)), name: NSNotification.Name.DataRefreshed, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onDataRefreshed(notification: Notification) {
        if DataManager.shared.cabsList.count != cabsList?.count {
            cabsList = DataManager.shared.cabsList
            cabsListTableView.reloadData() // insert / delete
        } else {
            cabsListTableView.visibleCells.forEach( { ($0 as? CabTableViewCell)?.refreshUi() } )
        }
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cab = cabsList?[indexPath.row] {
            ToastMessage.show(messageText: (cab.eta - PerrFuncs.currentTimstamp).toTimeString(format: "mm:ss"))
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CabTableViewCell = tableView.dequeueReusableCell(withIdentifier: CabTableViewCell.Identifier, for: indexPath) as! CabTableViewCell// Using force unwrap here on purpose, if the app crashes it's a development issue (partial implementation etc.), so in cases like that it should crash.

        if let cab = cabsList?[indexPath.row] {
            cell.configure(data: cab)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CabTableViewCell.CellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cabsList?.count).or(0)
    }
}

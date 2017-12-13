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

    lazy var cabsList: [CabOrderInfo] = DataManager.shared.cabsList

    override func viewDidLoad() {
        super.viewDidLoad()

        toggleListButton.setTitle("show result".localized(), for: UIControlState.normal)

        toggleListButton.onClick { [weak self] _ in
            //guard let strongSelf = self else { return }
            self?.toggleListAppearance()
        }
    }
    
    func toggleListAppearance() {
        if 0 == tableMarginTopConstraint.constant {
            toggleListButton.setTitle("hide result".localized(), for: UIControlState.normal)
            tableMarginTopConstraint.constant = toggleListButton.bounds.height + toggleListButton.bounds.origin.y
        } else {
            toggleListButton.setTitle("show result".localized(), for: UIControlState.normal)
            tableMarginTopConstraint.constant = 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CabTableViewCell = tableView.dequeueReusableCell(withIdentifier: CabTableViewCell.Identifier, for: indexPath) as! CabTableViewCell// Using force unwrap here on purpose, if the app crashes it's a development issue (partial implementation etc.), so in cases like that it should crash.

        let c = cabsList[indexPath.row] // "get taxi" at index... 😉
        cell.configure(data: c)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CabTableViewCell.CellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cabsList.count
    }
}

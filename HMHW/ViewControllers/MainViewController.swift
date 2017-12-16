//
//  MainViewController.swift
//  HereCandiddatesHW
//
//  Created by Perry on 12/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

class MainViewController: HViewController {

    @IBOutlet weak var toggleListButton: UIButton!
    @IBOutlet weak var cabsListTableView: UITableView!
    @IBOutlet weak var tableMarginTopConstraint: NSLayoutConstraint!

    lazy var collapsedSectionState: [Int:Bool] = [:]
    lazy var cabsCollection: [Int:[CabOrderInfo]] = [:]

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

        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(onDataRefreshed(notification:)), name: NSNotification.Name.DataRefreshed, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    func key(forTimestamp timestamp: TimeInterval) -> Int {
        let elapsedSeconds = timestamp.elapsedSeconds
        guard elapsedSeconds > 0 else { return 0 }
        return elapsedSeconds.toMinutes()
    }
    

    func reloadData() {
        let _cabsList: [CabOrderInfo] = Array(DataManager.shared.cabsList)

        cabsCollection.removeAll()

        for cabInfo in _cabsList {
            cabsCollection[key(forTimestamp: cabInfo.eta)] = (cabsCollection[key(forTimestamp: cabInfo.eta)] ?? []) // create new array if needed
            cabsCollection[key(forTimestamp: cabInfo.eta)]?.append(cabInfo)
        }

        cabsListTableView.reloadData() // insert / delete
    }

    @objc func onDataRefreshed(notification: Notification) {
        let counts = cabsCollection.values.flatMap( { $0.count } )
        var size = 0
        counts.forEach( { size = size + $0 } )
        if DataManager.shared.cabsList.count != size {
            reloadData()
        } else {
            reloadData()
            //cabsListTableView.visibleCells.forEach( { ($0 as? CabTableViewCell)?.refreshUi() } )
        }
    }
}


extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cabs = cabsCollection[indexPath.section] {
            let cab = cabs[indexPath.row]
            ToastMessage.show(messageText: (cab.eta - PerrFuncs.currentTimstamp).toTimeString(format: "mm:ss"))
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CabTableViewCell = tableView.dequeueReusableCell(withIdentifier: CabTableViewCell.Identifier, for: indexPath) as! CabTableViewCell// Using force unwrap here on purpose, if the app crashes it's a development issue (partial implementation etc.), so in cases like that it should crash.
        
        if let cabs = cabsCollection[indexPath.section] {
            let cab = cabs[indexPath.row]
            cell.configure(data: cab)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cabsCollection.filter( { $0.value.count > 0 } ).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        guard let cabs = cabsCollection[indexPath.section] else { return 0 }
        
        return (collapsedSectionState[indexPath.section]).or(false) ? 0 : CabTableViewCell.CellHeight // UITableViewAutomaticDimension?
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let cabInfo = cabsCollection[section]?.first else { return "" }
        let eta = cabInfo.eta.elapsedSeconds.toMinutes()

        return "\(eta > 0 ? "\(eta) minutes" : "seconds")"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cabsCollection[section]?.count).or(0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewHeader: CollapsibleTableViewHeader = (tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.Identifier) as? CollapsibleTableViewHeader).or(CollapsibleTableViewHeader())

        tableViewHeader.onClick({ [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.collapsedSectionState[section] = !(strongSelf.collapsedSectionState[section] ?? false)
            strongSelf.reloadData()
        })

        return tableViewHeader
    }
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    static let Identifier = "CollapsibleTableViewHeaderIdentifier"
}

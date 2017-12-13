//
//  ViewController.swift
//  HereCandiddatesHW
//
//  Created by Perry on 12/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

class SplashViewController: HViewController {
    @IBOutlet weak var mainSplashImageView: UIImageView!

    lazy var mainViewController: MainViewController = MainViewController.instantiate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainViewController.modalTransitionStyle = .crossDissolve
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        PerrFuncs.runOnUiThread(afterDelay: 3) { [unowned self] in // Using 'unowned' for better performance (instead of using weak), plus, there is no way this 'self' will be released somehow.
            self.mainSplashImageView.animateScaleAndFadeOut(scaleSize: 30, { [unowned self] _ in
                self.present(self.mainViewController, animated: true, completion: nil)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

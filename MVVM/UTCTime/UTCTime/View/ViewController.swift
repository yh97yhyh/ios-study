//
//  ViewController.swift
//  UTCTime
//
//  Created by MZ01-KYONGH on 2022/05/06.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dateTimeLabel.text = self.viewModel.dateTimeString
            }
        }
        viewModel.reload()
    }
    
    
    @IBAction func onYesterday(_ sender: Any) {
        viewModel.moveDay(day: -1)
    }
    
    @IBAction func onNow(_ sender: Any) {
        viewModel.reload()
    }
    
    @IBAction func onTomorrow(_ sender: Any) {
        viewModel.moveDay(day: 1)
    }
    
}


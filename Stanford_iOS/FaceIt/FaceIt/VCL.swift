//
//  VCL.swift
//  FaceIt
//
//  Created by MZ01-KYONGH on 2021/11/18.
//

import UIKit

private var faceMVCinstanceCount = 0
func getFaceMVCinstanceCount() -> Int { faceMVCinstanceCount += 1; return faceMVCinstanceCount }
private var emotionsMVCinstanceCount = 0
func getEmotionsMVCinstanceCount() -> Int { emotionsMVCinstanceCount += 1; return emotionsMVCinstanceCount }

var lastLog = NSDate()
var logPrefix = ""

func bumpLogDepth() {
    if lastLog.timeIntervalSinceNow < -1.0 {
        logPrefix += "__"
        lastLog = NSDate()
    }
}

// we haven't covered extensions as yet
// but it's basically a way to add methods to a given class

extension FaceViewController
{
    func logVCL(msg: String) {
        bumpLogDepth()
        print("\(logPrefix)Face \(instance) " + msg) //error: use of unresolved identifier 'instance'
    }

    override func awakeFromNib() {
        logVCL(msg: "awakeFromNib()")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logVCL(msg: "viewDidLoad()")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL(msg: "viewWillAppear(animated = \(animated))")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logVCL(msg: "viewDidAppear(animated = \(animated))")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL(msg: "viewWillDisappear(animated = \(animated))")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL(msg: "viewDidDisappear(animated = \(animated))")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL(msg: "viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL(msg: "viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logVCL(msg: "viewWillTransitionToSize")
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logVCL(msg: "animatingAlongsideTransition")
            }, completion: { context -> Void in
                self.logVCL(msg: "doneAnimatingAlongsideTransition")
        })
    }
}

extension EmotionsViewController
{
    func logVCL(msg: String) {
        bumpLogDepth()
        print("\(logPrefix)Emotions \(instance) " + msg) //error: use of unresolved identifier 'instance'
    }

    override func awakeFromNib() {
        logVCL(msg: "awakeFromNib()")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logVCL(msg: "viewDidLoad()")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL(msg: "viewWillAppear(animated = \(animated))")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logVCL(msg: "viewDidAppear(animated = \(animated))")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL(msg: "viewWillDisappear(animated = \(animated))")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL(msg: "viewDidDisappear(animated = \(animated))")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL(msg: "viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL(msg: "viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logVCL(msg: "viewWillTransitionToSize")
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logVCL(msg: "animatingAlongsideTransition")
            }, completion: { context -> Void in
                self.logVCL(msg: "doneAnimatingAlongsideTransition")
        })
    }
}

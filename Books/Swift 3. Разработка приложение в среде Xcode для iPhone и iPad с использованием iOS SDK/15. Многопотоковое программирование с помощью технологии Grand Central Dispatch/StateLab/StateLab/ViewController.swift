//
//  ViewController.swift
//  StateLab
//
//  Created by Artsiom Sakratar on 24.01.21.
//

import UIKit

class ViewController: UIViewController {
    
    private var label: UILabel!
    private var smiley: UIImage!
    private var smileyView: UIImageView!
    private var segmentedControl: UISegmentedControl!
    private var index = 0
    private var animate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let bounds = view.bounds
        let labelFrame = CGRect(origin: CGPoint(x: bounds.origin.x, y: bounds.midY - 50), size: CGSize(width: bounds.size.width, height: 100))
        label = UILabel(frame: labelFrame)
        label.font = UIFont(name: "Helvetica", size: 70)
        label.text = "Bazinga!"
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        let smileyFrame = CGRect(x: bounds.midX - 42, y: bounds.midY/2, width: 84, height: 84)
        smileyView = UIImageView(frame: smileyFrame)
        smileyView.contentMode = UIView.ContentMode.center
        let smileyPath = Bundle.main.path(forResource: "smiley", ofType: "png")!
        smiley = UIImage(contentsOfFile: smileyPath)
        smileyView.image = smiley
        segmentedControl = UISegmentedControl(items: ["One", "Two", "Three", "Four"])
        segmentedControl.frame = CGRect(x: bounds.origin.x + 20, y: 50, width: bounds.size.width - 40, height: 30)
        segmentedControl.addTarget(self, action: #selector(ViewController.selectionChanged(_:)), for: UIControl.Event.valueChanged)
        view.addSubview(segmentedControl)
        view.addSubview(smileyView)
        view.addSubview(label)
        index = UserDefaults.standard.integer(forKey: "index")
        segmentedControl.selectedSegmentIndex = index
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ViewController.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        center.addObserver(self, selector: #selector(ViewController.applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func rotateLabelDown() {
        UIView.animate(withDuration: 0.5, animations: {
            self.label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { (Bool) -> Void in
            self.rotateLabelUp()
        })
    }
    
    func rotateLabelUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.label.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: { (Bool) -> Void in
            if self.animate {
                self.rotateLabelDown()
            }
        })
    }
    
    @objc func applicationWillResignActive() {
        print("VC: \(#function)")
        animate = false
    }
    
    @objc func applicationDidBecomeActive() {
        print("VC: \(#function)")
        animate = true
        rotateLabelDown()
    }
    
    @objc func applicationDidEnterBackground() {
        print("VC: \(#function)")
        self.smiley = nil
        self.smileyView.image = nil
        UserDefaults.standard.set(self.index, forKey: "index")
        
        let app = UIApplication.shared
        var taskId = UIBackgroundTaskIdentifier.invalid
        let id = app.beginBackgroundTask() {
            print("Background task ran out of time and was terminated.")
            app.endBackgroundTask(taskId)
        }
        taskId = id
        
        if taskId == UIBackgroundTaskIdentifier.invalid {
            print("Failed to start background task!")
            return
        }
        
        DispatchQueue.global(qos: .default).async {
            print("Starting background task with " + "\(app.backgroundTimeRemaining) seconds remaining")
            self.smiley = nil
            self.smileyView.image = nil
            
            Thread.sleep(forTimeInterval: 25)
            
            print("Finishing background task with " + "\(app.backgroundTimeRemaining) seconds remaining")
            app.endBackgroundTask(taskId)
        }
    }
    
    @objc func applicationWillEnterForeground() {
        print("VC: \(#function)")
        let smileyPath = Bundle.main.path(forResource: "smiley", ofType: "png")!
        smiley = UIImage(contentsOfFile: smileyPath)
        smileyView.image = smiley
    }
    
    @objc func selectionChanged(_ sender: UISegmentedControl) {
        index = segmentedControl.selectedSegmentIndex;
    }
    
}


//
//  ViewController.swift
//  networkMonitoring
//
//  Created by Badr Ibrahim on 06.12.18.
//  Copyright © 2018 Badr Ibrahim. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController, UIGestureRecognizerDelegate {

  
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    let monitor = NWPathMonitor()
    
    var label : UILabel!
    
    var gesture = UITapGestureRecognizer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRect(origin: view.bounds.origin, size: CGSize(width: 300, height: 600)))
        label.text = "Starting off..."
        label.textColor = UIColor.yellow
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.4
        label.layer.shadowOffset = CGSize(width: 2, height: 1)
        label.layer.masksToBounds = false
        label.center = self.view.center
        view.addSubview(label)
        
        gesture.numberOfTapsRequired = 1
        gesture.addTarget(self, action: #selector(labelTapped))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("satisfied")
                DispatchQueue.main.sync(){
                    self.updateLabel(label: self.statusLabel, text: "Satisfied")
                    self.updateColor(color: UIColor(displayP3Red: 0, green: 80/255, blue: 0, alpha: 1), subView: self.subview)
                }
            } else if path.status == .requiresConnection {
                print("Connection is required")
                DispatchQueue.main.sync(){
                    self.updateLabel(label: self.statusLabel, text: "Requires Connection")
                    self.updateColor(color: UIColor(displayP3Red: 106/255, green: 27/255, blue: 221/255, alpha: 1) , subView: self.subview)
                }
            } else {
                print("Not satisfied")
                DispatchQueue.main.sync(){
                    self.updateLabel(label: self.statusLabel, text: "Not Satisfied")
                    self.updateColor(color: .red, subView: self.subview)
                }
            }
            
            DispatchQueue.main.sync(){ self.labelTapped()}
        }
        
        let queue = DispatchQueue(label: "queue")
        monitor.start(queue: queue)

    }

    func updateLabel(label: UILabel, text: String) {
        
        DispatchQueue.main.async {
            label.text = text
            UIView.animate(withDuration: 0.5, animations: {
                label.alpha = 1
            })
        }
    }


    func updateColor(color: UIColor, subView: UIView){
        
        subView.layer.backgroundColor = color.cgColor
        UIView.animate(withDuration: 1.5, animations: {
            subView.alpha = 1
            
        })
        hideSubView(sview: subView)
    }
    
    
    func hideSubView(sview: UIView) {
        sleep(3)
        UIView.animate(withDuration: 3, animations: {
            sview.alpha = 0
        })
    }
    
    @objc func labelTapped(){
        //Do Something
        self.label.text = self.statusLabel.text
        self.label.textColor = self.subview.backgroundColor
        self.label.alpha = 1
        UIView.animate(withDuration: 3, animations: {self.label.alpha = 0})
    }
}


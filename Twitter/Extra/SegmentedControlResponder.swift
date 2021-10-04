//
//  Responder.swift
//  Twitter
//
//  Created by Micaella Morales on 3/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class SegmentedControlResponder: NSObject {
    
    var buttonBar: UIView!
    
    func setButtonBar(buttonBar: UIView) {
        self.buttonBar = buttonBar
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (sender.frame.width / CGFloat(sender.numberOfSegments)) * CGFloat(sender.selectedSegmentIndex)
          }
    }
}

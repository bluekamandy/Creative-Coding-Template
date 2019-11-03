//
//  UpdateWorkSpace.swift
//  Face Off Template
//
//  Created by MASOOD KAMANDY on 10/22/19.
//  Copyright © 2019 Masood Kamandy. All rights reserved.
//

import Foundation
import C4

class UpdateCanvasController: CanvasController {
    
    public var frameRate = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas.backgroundColor = black
        
        // Initialize updating display. FPS can be 1 - 60 (iPhone or iPad) or 1-120 (iPad Pro)
        createDisplayLink(fps: frameRate)
    }
    
    override open func setup() {
        
    }
    
    open func draw() {
        
    }
    
    // MARK: DISPLAY LINK
    // Creating Link to Display for Refreshing 60 fps
    
    func createDisplayLink(fps: Int) {
        let displaylink = CADisplayLink(target: self,
                                        selector: #selector(step))
        
        displaylink.preferredFramesPerSecond = fps
        
        displaylink.add(to: .current,
                        forMode: .defaultRunLoopMode)
    }
         
    @objc func step(displaylink: CADisplayLink) {
        draw()
    }
}

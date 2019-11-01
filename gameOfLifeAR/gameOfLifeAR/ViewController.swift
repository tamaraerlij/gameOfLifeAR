//
//  ViewController.swift
//  gameOfLifeAR
//
//  Created by Tamara Erlij on 01/11/19.
//  Copyright © 2019 Tamara Erlij. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate{
    
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    private var isSpawned = false
    private var cube: CubeOfLife?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
             sceneView.delegate = self
             
             // Show statistics such as fps and timing information
             sceneView.showsStatistics = true
             
             // Set the scene to the view
             sceneView.scene = SCNScene()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          
          // Pause the view's session
          sceneView.session.pause()
      }
      
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if cube?.isBuilt ?? false {
            cube?.tick()
        } else {
            cube?.build()
        }
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !isSpawned {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // Create plane
                let planeWidth = CGFloat(planeAnchor.extent.x)
                let planeHeight = CGFloat(planeAnchor.extent.z)
                
                let plane = SCNPlane(width: planeWidth, height: planeHeight)
                
                let planeNode = SCNNode()
                planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
                plane.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.75)
                planeNode.geometry = plane
                
                // Create Cube of Life
                cube = CubeOfLife(n: 10, width: planeWidth / 2, height: planeWidth / 2, nHeight: 10)
                cube?.position = planeNode.position
                
                planeNode.addChildNode(cube!)
                
                node.addChildNode(planeNode)
                isSpawned.toggle()
            }
        }
    }
}

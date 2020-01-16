//  Created by Edoardo de Cal on 10/16/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVKit
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var timer = Timer()
    var infoView: InfoView?
    let cameraRelativePosition = SCNVector3(0, 0, -0.1)
    
    let buttonCreateCube: CustomButton = {
        let button = CustomButton()
        button.setTitle("Crea cubo", for: .normal)
        button.addTarget(self, action: #selector(buttonCubeTapped), for: .touchUpInside)
        return button
    }()
    
    let buttonCreatePyramid: CustomButton = {
        let button = CustomButton()
        button.setTitle("Crea piramide", for: .normal)
        button.addTarget(self, action: #selector(buttonPyramidTapped), for: .touchUpInside)
        return button
    }()
    
    let buttonCreateParallelepiped: CustomButton = {
        let button = CustomButton()
        button.setTitle("Crea parallelepipedo", for: .normal)
        button.addTarget(self, action: #selector(buttonParallelepipedTapped), for: .touchUpInside)
        return button
    }()
    
    let buttonReset: CustomButton = {
        let button = CustomButton()
        button.isHidden = true
        button.setTitle("🗑", for: .normal)
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    
    let segmentedControl: UISegmentedControl = {
        let items = ["AR" , "Image"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    var buttonDraw = ButtonDraw()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    var trackerNodeShowed = false
    var trackerNode: SCNNode?
    var foundSurface = false
    var tracking = true
    var nodeFigure = SCNNode()
    var count = 0
    var selectedFigure: Figure?
    
    var cube = Figure(name: "cube", imageTexture: UIImage(named: "codice"), numBlocks: 27, nameFile: "Cube")
    var pyramid = Figure(name: "pyramid", imageTexture: UIImage(named: "donbosco.jpg"), numBlocks: 14, nameFile: "Pyramid")
    var parallelepiped = Figure(name: "parallelepiped", imageTexture: UIImage(named: "QrCodeSalesiani.png"), numBlocks: 36, nameFile: "Parallelepiped")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = false
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        sceneView.scene = scene
        setupView()
    }
    
    func setupView() {
        addTrashButton()
        addButtonDraw()
        setupStackView()
        addInfoView()
        addSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWorldTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: - AR
    func setupWorldTracking() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        draw()
        guard tracking else { return }
        let hitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), types: .featurePoint)
        guard let result = hitTest.first else { return }
        let translation = SCNMatrix4(result.worldTransform)
        let position = SCNVector3Make(translation.m41, translation.m42, translation.m43)
        createTrackerNode()
        self.trackerNode?.position = position
    }
    
    func draw() {
        DispatchQueue.main.async {
            if self.buttonDraw.isHighlighted {
                let sphere = SCNNode()
                sphere.geometry = SCNSphere(radius: 0.0035)
                sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.random()
                Service.addChildNode(sphere, toNode: self.sceneView.scene.rootNode, inView: self.sceneView, cameraRelativePosition: self.cameraRelativePosition)
            }
        }
    }
    
    func createTrackerNode() {
        if trackerNodeShowed == false {
            let plane = SCNPlane(width: 1.5, height: 1.5)
            plane.firstMaterial?.diffuse.contents = UIImage(named: "Tracker.png")
            plane.firstMaterial?.isDoubleSided = true
            trackerNode = SCNNode(geometry: plane)
            trackerNode?.eulerAngles.x = -.pi * 0.5
            self.sceneView.scene.rootNode.addChildNode(self.trackerNode!)
            foundSurface = true
            trackerNodeShowed = true
        }
    }
    
    func addObject(position: SCNVector3, sceneView: ARSCNView, node: SCNNode, objectPath: String){
        node.position = position
        node.eulerAngles.y = (trackerNode?.eulerAngles.y)!
        node.eulerAngles.z = (trackerNode?.eulerAngles.y)!
        guard let constellationsScene = SCNScene(named: objectPath)
            else {
                print("Unable to Generate" + objectPath)
                return
        }
        let wrapperNode = SCNNode()
        for child in constellationsScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        node.addChildNode(wrapperNode)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    @objc func addBlock() {
        count += 1
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if count <= selectedFigure?.numBlocks ?? 0 && node.name == ("box\(count)") {
                let box = SCNBox(width: 0.23, height: 0.23, length: 0.23, chamferRadius: 0)
                let boxNode = SCNNode(geometry: box)
                let material = SCNMaterial()
                material.diffuse.contents = selectedFigure?.imageTexture
                material.isDoubleSided = true
                box.materials = [material]
                boxNode.position = node.worldPosition
                sceneView.scene.rootNode.addChildNode(boxNode)
                node.removeFromParentNode()
            }
        }
    }
    
    func creaFigura() {
        if tracking {
            guard foundSurface else { return }
            let trackingPosition = trackerNode!.position
            guard let nameFile = selectedFigure?.nameFile else { return }
            addObject(position: trackingPosition, sceneView: sceneView, node: nodeFigure, objectPath: "art.scnassets/\(nameFile).scn")
            timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(addBlock), userInfo: nil, repeats: true)
            setRemoveForImageTracking()
            buttonReset.isHidden = false
            segmentedControl.isHidden = true
            buttonDraw.isHidden = false
        }
    }
    
    func setRemoveForImageTracking() {
        infoView?.isHidden = true
        buttonCreatePyramid.isHidden = true
        buttonCreateCube.isHidden = true
        buttonCreateParallelepiped.isHidden = true
        tracking = false
        trackerNode?.removeFromParentNode()
    }
    
    @objc func reset() {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        trackerNodeShowed = false
        tracking = true
        count = 0
        timer.invalidate()
        segmentedControl.isHidden = false
        buttonCreatePyramid.isHidden = false
        buttonCreateCube.isHidden = false
        buttonCreateParallelepiped.isHidden = false
        buttonReset.isHidden = true
        buttonDraw.isHidden = true
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
    
    //MARK: - UI
    func addSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(buttonCreateCube)
        stackView.addArrangedSubview(buttonCreateParallelepiped)
        stackView.addArrangedSubview(buttonCreatePyramid)
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    }
    
    func addButtonDraw() {
        buttonDraw = ButtonDraw()
        buttonDraw.isHidden = true
        view.addSubview(buttonDraw)
        buttonDraw.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonDraw.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    }
    
    func addInfoView() {
        infoView = InfoView()
        infoView?.bounce(damping: 2, option: [.curveEaseIn, .repeat])
        guard let infoView = infoView else { return }
        view.addSubview(infoView)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }

    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            reset()
            setupWorldTracking()
        case 1:
            setupImageTracking()
            setRemoveForImageTracking()
        default:
            break
        }
    }
    
    func addTrashButton() {
        view.addSubview(buttonReset)
        buttonReset.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        buttonReset.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        buttonReset.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func buttonPyramidTapped() {
        selectedFigure = pyramid
        creaFigura()
    }
    
    @objc func buttonCubeTapped() {
        selectedFigure = cube
        creaFigura()
    }
    
    @objc func buttonParallelepipedTapped() {
        selectedFigure = parallelepiped
        creaFigura()
    }
    
    //MARK: - TrackingImages
    var session: ARSession {
        return sceneView.session
    }
    
    func setupImageTracking() {
        let configuration = ARImageTrackingConfiguration()
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARResources", bundle: Bundle.main) else {
            print("Could not load images")
            return
        }
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            let planeNode = SCNNode(geometry: plane)
            let sceneLittleCube = SCNScene(named: "art.scnassets/LittleCube.scn")!
            let littleCube = sceneLittleCube.rootNode.childNodes.first!
            littleCube.position = SCNVector3Zero
            planeNode.addChildNode(littleCube)
            node.addChildNode(planeNode)
        }
        return node
    }
}

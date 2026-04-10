//
//  MarsSceneView.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import SwiftUI
import SceneKit

struct MarsSceneView: UIViewRepresentable {
    @Binding var rotationAngle: Float
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = true
        sceneView.defaultCameraController.interactionMode = .orbitTurntable
        sceneView.autoenablesDefaultLighting = false
        sceneView.scene = SCNScene()
        sceneView.scene?.background.contents = UIColor.clear
        
        guard let url = Bundle.main.url(forResource: "Mars", withExtension: "usdz"),
              let scene = try? SCNScene(url: url, options: nil) else {
            return sceneView
        }
        
        sceneView.scene = scene
        sceneView.scene?.background.contents = UIColor.clear
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // Сохраняем источники света в coordinator
        setupLighting(in: sceneView.scene, coordinator: context.coordinator)
        
        if let marsNode = sceneView.scene?.rootNode.childNodes.first {
            context.coordinator.marsNode = marsNode
            marsNode.castsShadow = true
            marsNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
        }
        
        return sceneView
    }
    
    private func setupLighting(in scene: SCNScene?, coordinator: Coordinator) {
        guard let scene = scene else { return }
        
        // Основной направленный свет (будет вращаться вместе с планетой)
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.color = UIColor.white
        directionalLight.intensity = 1500
        directionalLight.castsShadow = true // Включаем тени для объема
        
        // Настройка теней
        directionalLight.shadowMode = .deferred
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.6)
        directionalLight.shadowRadius = 2.0
        directionalLight.shadowMapSize = CGSize(width: 2048, height: 2048)
        
        let directionalNode = SCNNode()
        directionalNode.light = directionalLight
        directionalNode.eulerAngles = SCNVector3(-Float.pi / 3, Float.pi / 3, 0)
        scene.rootNode.addChildNode(directionalNode)
        coordinator.directionalLightNode = directionalNode
        
        // Ambient свет (равномерный, не вращается)
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor(white: 0.4, alpha: 1.0)
        ambientLight.intensity = 200
        
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)
        
        // Заполняющий свет (не вращается)
        let fillLight = SCNLight()
        fillLight.type = .omni
        fillLight.color = UIColor(white: 0.6, alpha: 1.0)
        fillLight.intensity = 300
        
        let fillNode = SCNNode()
        fillNode.light = fillLight
        fillNode.position = SCNVector3(2, 2, 3)
        scene.rootNode.addChildNode(fillNode)
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.5
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Поворачиваем планету
        context.coordinator.marsNode?.eulerAngles.y = rotationAngle
        
        // Поворачиваем направленный свет синхронно с планетой
        // Это создаст эффект, что свет остается фиксированным относительно планеты
        if let lightNode = context.coordinator.directionalLightNode {
            
            lightNode.eulerAngles = SCNVector3(
                -Float.pi / 3,
                Float.pi / 3 + rotationAngle,
                0
            )
        }
        
        SCNTransaction.commit()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var marsNode: SCNNode?
        var directionalLightNode: SCNNode?
    }
}

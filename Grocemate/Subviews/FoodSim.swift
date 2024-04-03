//
//  FoodSim.swift
//  Grocemate
//
//  Created by Giorgio Latour on 4/3/24.
//

import CoreMotion
import SpriteKit

class FoodSim: SKScene, SKPhysicsContactDelegate {
    var motionManager: CMMotionManager?

    override func didMove(to view: SKView) {
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()

        backgroundColor = .systemBackground

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        let images = ["carrot", "cheese-wedge", "chestnut",
                      "cookie", "croissant", "dumpling",
                      "fish-cake-with-swirl", "fortune-cookie",
                      "fried-shrimp", "green-salad", "lemon",
                      "potato", "rice-ball", "rice-cracker",
                      "strawberry", "stuffed-flatbread", "tangerine",
                      "tomato", "waffle", "watermelon"]

        for (index, imageName) in Array(zip(images.indices, images)) {
            var xCoord = (UIScreen.main.bounds.width / CGFloat(images.count + 2)) * CGFloat(index)
            // Do not want the x coordinate to be zero so change to 10 if it is.
            xCoord = max(60.0, min(xCoord, UIScreen.main.bounds.width))
            let yCoord = UIScreen.main.bounds.height - 80 + CGFloat.random(in: -40..<20)

            let foodDimX: CGFloat = 60
            let foodDimY: CGFloat = 60

            let texture = SKTexture(imageNamed: imageName)
            let foodNode = SKSpriteNode(texture: texture, size: CGSize(width: foodDimX, height: foodDimY))
            foodNode.position = CGPoint(x: xCoord, y: yCoord)
            foodNode.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: foodDimX, height: foodDimY))

            addChild(foodNode)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        guard let accelerometerData = motionManager?.accelerometerData else { return }

        physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 15, dy: accelerometerData.acceleration.y * 15)
    }
}

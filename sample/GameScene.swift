//
//  GameScene.swift
//  sample
//
//  Created by ウエキチ on 2018/09/15.
//  Copyright © 2018年 ウエキチ. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // 衝突する物体の種類を用意する
    let category_player:UInt32  = 1 << 1   // 0001
    let category_marsh:UInt32   = 1 << 2   // 0010
    let category_ground:UInt32  = 1 << 3   // 0100
    let category_other:UInt32   = 1 << 4   // 1000
    // タイマーを用意する
    var myTimer = Timer()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.8, green: 0.96, blue: 1, alpha: 1)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // 物理衝突の情報を自分で受け取る //コードエラー
        self.physicsWorld.contactDelegate = self
        // 物理空間の外枠の種類は、その他
        self.physicsBody?.categoryBitMask = category_other
        // タイマーをスタートする（1.0秒ごとにtimerUpdateを繰り返し実行）
        myTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                         target: self,
                                                         selector: #selector(timerUpdate),
                                                         userInfo: nil,
                                                         repeats: true)
    }
    //#selector(self.timerUpdate),
    
    // タイマーで 1 秒ごとに実行される処理
    @objc func timerUpdate() {
        // マシュマロのスプライトを作る
        let marsh = SKSpriteNode(imageNamed: "marsh1.png")
        marsh.physicsBody = SKPhysicsBody(circleOfRadius: 50)   // 物理ボディは半径50の円
        marsh.physicsBody?.restitution = 0.6    // 跳ね返り係数を0.6にして弾みやすくする
        
        marsh.physicsBody?.categoryBitMask = category_marsh // 種類は、マシュマロ
        // マシュマロが衝突するものは、プレイヤー、マシュマロ、地面、その他
        marsh.physicsBody?.collisionBitMask = category_player | category_marsh | category_ground | category_other
        // マシュマロが衝突した時に反応する物は、プレイヤーと地面
        marsh.physicsBody?.contactTestBitMask = category_player | category_ground
        
        // 横方向にランダム、縦方向に1000（画面の上の方）の位置に登場させる
        marsh.position = CGPoint(x: Int(arc4random_uniform(750)), y: 1000)
        self.addChild(marsh)
        
        // マシュマロが登場したときに、衝撃を与えて、斜め上方向に飛び出させる //修正Int()
        let vec = CGVector(dx: Int(arc4random_uniform(200)) - 100, dy: 100)
        marsh.physicsBody?.applyImpulse(vec)
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

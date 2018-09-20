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
    // 地面を用意する
    let groundSprite = SKSpriteNode(imageNamed: "ground.png")
    // 障害物の準備をする
    var pinCount = 5
    var pinVX:[CGFloat] = []
    var pinSprite:[SKSpriteNode] = []
    // タイマーを用意する
    var myTimer = Timer()
    // プレイヤーを用意する
    let playerSprite = SKSpriteNode(imageNamed: "player1.png")
    // スコア表示を用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.8, green: 0.96, blue: 1, alpha: 1)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // 物理衝突の情報を自分で受け取る //コードエラー
        self.physicsWorld.contactDelegate = self
        // 物理空間の外枠の種類は、その他
        self.physicsBody?.categoryBitMask = category_other
        
        // スコアを表示する
        scoreLabel.text = "SCORE:0"
        scoreLabel.fontSize = 50
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x:40, y:1250)
        self.addChild(scoreLabel)
        
        // 地面を表示する
        groundSprite.physicsBody = SKPhysicsBody(rectangleOf: groundSprite.size)
        groundSprite.physicsBody?.isDynamic = false                   // 重力の影響を受けない
        groundSprite.physicsBody?.categoryBitMask = category_ground // 種類は、地面
        groundSprite.position = CGPoint(x: 375, y: 75)
        self.addChild(groundSprite)
        
        // プレイヤーを表示する
        playerSprite.position = CGPoint(x:350, y:200)
        playerSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)    // 物理ボディは半径50の円
        playerSprite.physicsBody?.isDynamic = false
        self.addChild(playerSprite)
        playerSprite.physicsBody?.categoryBitMask = category_player     // 種類は、プレイヤー
        // プレイヤーにパラパラアニメをするアクションをつける //修正
        let playerAnime = SKAction.animate(with:
            [SKTexture(imageNamed: "player1.png"),SKTexture(imageNamed: "player2.png")],
            timePerFrame: 0.2)
        let actionA = SKAction.repeatForever(playerAnime)
        playerSprite.run(actionA)
        
        // 途中の障害物を表示する
        for i in 0...pinCount { // 0〜pinCountまで繰り返す
            // 障害物のスプライトを作る
            let pin = SKSpriteNode(imageNamed: "pin.png")
            pin.physicsBody = SKPhysicsBody(circleOfRadius: 25)     // 物理ボディは半径25の円
            pin.physicsBody?.isDynamic = false                        // 重力の影響を受けない
            pin.physicsBody?.categoryBitMask = category_other       // 種類は、その他
            
            // ランダムな位置に登場させる
            let rx = Int(arc4random_uniform(750))
            let ry = i * 100 + 500
            pin.position = CGPoint(x: rx, y: ry)
            self.addChild(pin)
            
            // 作った障害物を配列に追加する
            pinSprite.append(pin)
            // 移動スピードもランダムに作って配列に追加する
            pinVX.append(CGFloat(arc4random() % 20) - 10)
        }
        
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
        for touch: AnyObject in touches {
            // ラベル人をタッチした位置に横移動する
            playerSprite.position.x = touch.location(in: self).x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // 障害物を移動させる
        for i in 0...pinCount {// 0〜pinCountまで繰り返す
            pinSprite[i].position.x += pinVX[i]
            // もし、画面の右より外に出たら左に移動する
            if 750 < pinSprite[i].position.x {
                pinSprite[i].position.x = 1
            }
            // もし、画面の左より外に出たら右に移動する
            if pinSprite[i].position.x < 0 {
                pinSprite[i].position.x = 749
            }
        }
    }
    
    // 衝突したときの処理
    func didBeginContact(contact: SKPhysicsContact) {
        // bodyAとbodyBの衝突は、どちらがどちらかわからないのでチェックする
        // もし、bodyAがマシュマロだったら
        if contact.bodyA.node?.physicsBody?.categoryBitMask == category_marsh {
            // 衝突したbodyBがプレイヤーだったら、食べる
            if contact.bodyB.node == playerSprite {
                catchMarsh()
            }
            // 衝突したbodyBが地面だったら、ミスにする
            if contact.bodyB.node == groundSprite {
                
            }
            // マシュマロのbodyAは消す
            contact.bodyA.node!.removeFromParent()
        }
        // もし、bodyBがマシュマロだったら
        if contact.bodyB.node?.physicsBody?.categoryBitMask == category_marsh {
            // 衝突したbodyAがプレイヤーだったら、食べる
            if contact.bodyA.node == playerSprite {
                catchMarsh()
            }
            // 衝突したbodyAが地面だったら、ミスにする
            if contact.bodyA.node == groundSprite {
                
            }
            // マシュマロのbodyBは消す
            contact.bodyB.node!.removeFromParent()
        }
    }
    
    // マシュマロキャッチしたときの処理
    func catchMarsh() {
        // スコアを追加する
        score += 10
        scoreLabel.text = "SCORE: \(score)"
        
        // 食べたところにハートを作る
        let heartSprite = SKSpriteNode(imageNamed: "heart.png")
        heartSprite.position = playerSprite.position
        self.addChild(heartSprite)
        
        // 【ハートに少しずつ大きく上に上がって消えるアクションをつける】
        // ハートを少しずつ大きくするアクション
        let action1 = SKAction.scale(to: 2.0, duration: 0.4)
        // ハートを上に100移動するアクション
        let action2 = SKAction.moveBy(x: 0, y: 100, duration: 0.4)
        // action1とaction2を同時に行う
        let actionG = SKAction.group([action1, action2])
        // ハートを削除するアクション
        let action3 = SKAction.removeFromParent()
        // actionGとaction3を順番に行う
        let actionS = SKAction.sequence([actionG, action3])
        // ハートにアクションをつける
        heartSprite.run(actionS)
    }
}

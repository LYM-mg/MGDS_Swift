//
//  emmitParticles.swift
//  Liveyktest1
//
//  Created by yons on 16/9/21.
//  Copyright © 2016年 xiaobo. All rights reserved.
//

func emmitParticles(from point: CGPoint, emitter: CAEmitterLayer , in rootView:UIView) {
    let originPoint = CGPoint(x: rootView.bounds.maxX, y: rootView.bounds.maxY)
    let newOriginPoint = CGPoint(x: originPoint.x / 2, y: originPoint.y / 2)
    
    let pos = CGPoint(x: newOriginPoint.x + point.x, y: point.y)
    let image = #imageLiteral(resourceName: "tspark")
    
    emitter.emitterPosition = pos
    emitter.renderMode = kCAEmitterLayerBackToFront
    
    let rocket = CAEmitterCell()
    
    rocket.emissionLongitude = CGFloat(M_PI_2)
    rocket.emissionLatitude = 0
    rocket.lifetime = 1.6
    rocket.birthRate = 1
    rocket.velocity = 40
    rocket.velocityRange = 100
    rocket.yAcceleration = -250
    rocket.emissionRange = CGFloat(M_PI_4)
    rocket.color = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.8).cgColor
    rocket.redRange = 0.5
    rocket.greenRange = 0.5
    rocket.blueRange = 0.5
    
    rocket.name = "rocket"
    
    let flare = CAEmitterCell()
    flare.contents = image.cgImage
    flare.emissionLongitude = 4 * CGFloat(M_PI_2)
    flare.scale = 0.4
    flare.velocity = 100;
    flare.birthRate = 45;
    flare.lifetime = 1.5;
    flare.yAcceleration = -350;
    flare.emissionRange = CGFloat(M_PI / 7)
    flare.alphaSpeed = -0.7;
    flare.scaleSpeed = -0.1;
    flare.scaleRange = 0.1;
    flare.beginTime = 0.01;
    flare.duration = 0.7;
    
    //The particles that make up the explosion
    let firework = CAEmitterCell()
    firework.contents = image.cgImage;
    firework.birthRate = 9999;
    firework.scale = 0.6;
    firework.velocity = 130;
    firework.lifetime = 2;
    firework.alphaSpeed = -0.2;
    firework.yAcceleration = -80;
    firework.beginTime = 1.5;
    firework.duration = 0.1;
    firework.emissionRange = CGFloat(M_PI * 2)
    firework.scaleSpeed = -0.1
    firework.spin = 2;
    
    //Name the cell so that it can be animated later using keypath
    firework.name = "firework"
    
    //preSpark is an invisible particle used to later emit the spark
    let preSpark = CAEmitterCell()
    preSpark.birthRate = 80
    preSpark.velocity = firework.velocity * 0.70
    preSpark.lifetime = 1.7
    preSpark.yAcceleration = firework.yAcceleration * 0.85
    preSpark.beginTime = firework.beginTime - 0.2
    preSpark.emissionRange = firework.emissionRange
    preSpark.greenSpeed = 100
    preSpark.blueSpeed = 100
    preSpark.redSpeed = 100
    
    //Name the cell so that it can be animated later using keypath
    preSpark.name = "preSpark"
    
    //The 'sparkle' at the end of a firework
    let spark = CAEmitterCell()
    spark.contents = image.cgImage
    spark.lifetime = 0.05;
    spark.yAcceleration = -250;
    spark.beginTime = 0.8;
    spark.scale = 0.4;
    spark.birthRate = 10;
    
    preSpark.emitterCells = [spark]
    rocket.emitterCells = [flare, firework, preSpark]
    emitter.emitterCells = [rocket]
    
    rootView.setNeedsDisplay()
}


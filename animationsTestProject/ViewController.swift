//
//  ViewController.swift
//  animationsTestProject
//
//  Created by Cristian Leonel Gibert on 6/27/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

let animLayer = CALayer() // the layer that is going to be animated
let cornerRadiusAnim = CABasicAnimation(keyPath:"cornerRadius") // the corner radius reducing animation
let widthAnim = CABasicAnimation(keyPath:"bounds.size.width") // the width animation
let backgroundColorAnim = CABasicAnimation(keyPath: "backgroundColor") // the background color animation
let groupAnim = CAAnimationGroup() // the combination of the corner radius animation and width animation
let animDuration = NSTimeInterval(0.3) // the duration of one 'segment' of the animation
var layerSize = CGFloat(100) // the width & height of the layer (when it's a square)
let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds") // the bounds animation
var magicButtonPositionY = CGFloat()
var magicButtonPositionX = CGFloat()

class ViewController: UIViewController {

	@IBOutlet weak var magicButtton: UIButton!
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		layerSize = CGRectGetHeight(self.magicButtton.bounds)
		
		// increase the corner radius
		self.changeCornerRadius()
		
		// decreases the width
		self.decreaseWidthSize()
		
		// change the background color
		self.changeBackgroundColor()
		
		// adds animations to a group animation
		groupAnim.delegate = self
		groupAnim.setValue("animations", forKey: "groupAnim")
		groupAnim.animations = [cornerRadiusAnim, widthAnim, backgroundColorAnim]
		groupAnim.duration = animDuration
		
		magicButtonPositionY = CGRectGetMidY(self.magicButtton.frame)
		magicButtonPositionX = CGRectGetMidX(self.magicButtton.frame)
	}
	
	// use this function to perform some action after the animations
	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let name = anim.valueForKey("groupAnim") as? String {
			if name == "animations" {
				let imageView = UIImageView.init(image: UIImage(named:"check_button"))
				self.addButtonImageWithAnimation(imageView)
				self.scaleImageButton(imageView)
				self.expandButton()
			}
		}
	}
	
	private func expandButton() {
		keyFrameAnimation.delegate = self
		keyFrameAnimation.duration = 0.7
		keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
		let initalBounds = NSValue(CGRect: self.magicButtton.bounds)
		let secondBounds = NSValue(CGRect: CGRect(x: magicButtonPositionX, y: magicButtonPositionY, width: 75, height: 75))
		let finalBounds = NSValue(CGRect: CGRect(x: magicButtonPositionX, y: magicButtonPositionY, width: 1500, height: 1500))
		keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
		keyFrameAnimation.keyTimes = [0, 0.5, 1]
		keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
		self.magicButtton.layer.addAnimation(keyFrameAnimation, forKey: "bounds")
	}
	
	private func changeCornerRadius() {
		cornerRadiusAnim.duration = animDuration
		cornerRadiusAnim.fromValue = self.magicButtton.layer.cornerRadius
		cornerRadiusAnim.toValue = self.magicButtton.bounds.size.height*0.5
	}
	
	private func decreaseWidthSize() {
		widthAnim.duration = animDuration
		widthAnim.fromValue = self.magicButtton.frame.size.width
		widthAnim.toValue = layerSize
	}
	
	private func changeBackgroundColor() {
		backgroundColorAnim.duration = animDuration
		backgroundColorAnim.fromValue = self.magicButtton.backgroundColor
		backgroundColorAnim.toValue = UIColor.greenColor().CGColor
	}
	
	private func addButtonImageWithAnimation(image: UIImageView) {
		image.layer.position = CGPoint(x: self.magicButtton.frame.size.width/2, y: self.magicButtton.frame.size.height/2)
		image.alpha = 1
		self.magicButtton.titleLabel?.alpha = 0
		self.magicButtton.layer.addSublayer(image.layer)
	}
	
	private func scaleImageButton(image: UIImageView) {
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.duration = animDuration
		scale.fromValue = 5
		scale.toValue = 1
		image.layer.addAnimation(scale, forKey: nil)
	}
	
	
	@IBAction func magicButtonPressed(sender: AnyObject) {
		self.magicButtton.backgroundColor = UIColor.greenColor()
		self.magicButtton.frame.size.height = layerSize
		self.magicButtton.frame.size.width = layerSize
		self.magicButtton.layer.anchorPoint = CGPointMake(0.5, 0.5)
		self.magicButtton.layer.position = CGPoint(x: magicButtonPositionX, y: magicButtonPositionY)
		self.magicButtton.layer.cornerRadius = layerSize*0.5
		self.magicButtton.layer.addAnimation(groupAnim, forKey: nil)
	}	
}









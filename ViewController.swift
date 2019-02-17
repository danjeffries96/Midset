//
//  ViewController.swift
//  MS
//
//  Created by Dan Jeffries on 3/14/17.
//  Copyright © 2017 Dan Jeffries. All rights reserved.
//

import UIKit

//  A simple ViewController class to calculate a midset:
//  this midpoint between two coordinates for a student
//  in a marching band ensemble.

class ViewController: UIViewController {
  
  @IBOutlet weak var VectorView: UIView!
  @IBOutlet weak var OutputLabel: UILabel!
  
  @IBOutlet weak var Hash: UISegmentedControl!
  
  @IBOutlet weak var Side1: UISegmentedControl!
  @IBOutlet weak var LRSteps1: UITextField!
  @IBOutlet weak var InsideOutside1: UISegmentedControl!
  @IBOutlet weak var YardText1: UITextField!
  @IBOutlet weak var FBSteps1: UITextField!
  @IBOutlet weak var FrontBehind1: UISegmentedControl!
  @IBOutlet weak var FBRef1: UISegmentedControl!
  
  @IBOutlet weak var FBSteps2: UITextField!
  @IBOutlet weak var FrontBehind2: UISegmentedControl!
  @IBOutlet weak var FBRef2: UISegmentedControl!
  @IBOutlet weak var Side2: UISegmentedControl!
  @IBOutlet weak var LRSteps2: UITextField!
  @IBOutlet weak var InsideOutside2: UISegmentedControl!
  @IBOutlet weak var YardText2: UITextField!
  @IBOutlet weak var MTQSet: UISegmentedControl!
  
  @IBOutlet weak var Calculate: UIButton!
 
  
  
  //  Calculate midset when
  //  button is pressed.
  @IBAction func CalculateAction(_ sender: UIButton) {

    let side1: Int = Side1.selectedSegmentIndex + 1
    let lrstepsstring1: String = LRSteps1.text!
    let lrsteps1: Double = Double(lrstepsstring1)!
  
    let insideoutside1: Int = InsideOutside1.selectedSegmentIndex
  
    let yardstring1: String = YardText1.text!
    let yl1: Int = Int(yardstring1)!
    
    let fbstepsstring1: String = FBSteps1.text!
    let fbsteps1: Double = Double(fbstepsstring1)!
    let frontbehind1: Int = FrontBehind1.selectedSegmentIndex
    let fbref1: Int = FBRef1.selectedSegmentIndex
    
    
    let side2: Int = Side2.selectedSegmentIndex + 1
    let lrstepsstring2: String = LRSteps2.text!
    let lrsteps2: Double = Double(lrstepsstring2)!
    
    let insideoutside2: Int = InsideOutside2.selectedSegmentIndex
    
    let yardstring2: String = YardText2.text!
    let yl2: Int = Int(yardstring2)!
    
    let fbstepsstring2: String = FBSteps2.text!
    let fbsteps2: Double = Double(fbstepsstring2)!
    let frontbehind2: Int = FrontBehind2.selectedSegmentIndex
    let fbref2: Int = FBRef2.selectedSegmentIndex
    
    
    //  Modulus function for doubles
    func mod(n: Double, m: Double) -> Double
    {
      var n = n
      while n >= m
      {
        n -= m
      }

      return n
    }
    
    //  Trims digits after the decimal from a Double
    func trimDigits(d: Double) -> Double {
      
      let rounded = round(1000*d)/1000
      
      var doubleString = String(rounded)
      
      var i = 0
      for c in doubleString.characters {
        if (c == ".") {
          break
        }
        i += 1
      }
      
      var offset = 4
      
      while (doubleString.characters.count < i + offset) {
        offset -= 1
      }

      let index = doubleString.index(doubleString.startIndex, offsetBy: i + offset)

      
      if (i != 0) {
        return Double(doubleString.substring(to: index))!
      } else {
        return d
      }
    }
  
    //  Convert description of left-to-right position to
    //  number of steps from side 1, 0 yardline
    func lr2steps(side: Int, insideout: Int, inoutsteps: Double, yl: Int) -> Double
    {
      var steps: Double = 0
      
      if side == 1
      {
        steps += (8.0/5.0 * Double(yl))
        
        if insideout == 0
        {
          steps += inoutsteps
        }
          
        else if insideout == 1
        {
          steps -= inoutsteps
        }
      }
        
      else if side == 2
      {
        steps += 80
        
        steps += 8.0/5.0 * Double(50 - yl)
        
        if insideout == 0
        {
          steps -= inoutsteps
        }
          
        else if insideout == 1
        {
          steps += inoutsteps
        }
      }
      
      steps = trimDigits(d: steps)
      
      return steps
    }
    
    //  Convert steps to string description of left to right
    func steps2lr(steps: Double) -> String
    {
      var steps = steps
      var side: Int = 0
      var yl: Int = 0
      var insideout: String = " "
      var inoutsteps: Double = 0
      
      if steps == 80
      {
        return "On the 50"
      }
        
      else if steps < 80
      {
        side = 1
        
        if (mod(n: steps, m: 8) > 4)
        {
          insideout = "outside"
          yl = Int(steps)/8 * 5
          
          inoutsteps = 8 - (mod(n: steps, m: 8))
        }
          
        else
        {
          insideout = "inside"
          yl = Int(steps)/8 * 5
          inoutsteps = mod(n: steps, m: 8)
        }
      }
        
      else if steps > 80
      {
        side = 2
        steps -= 80
        
        if (mod(n: steps, m: 8) > 4)
        {
          insideout = "inside"
          yl = 50 - (Int(steps)/8 + 1) * 5
          inoutsteps = 8 - mod(n: steps, m: 8)
        }
          
        else
        {
          insideout = "outside"
          yl = 50 - Int(steps)/8 * 5
          inoutsteps = mod(n: steps, m: 8)
        }
      }
      
      inoutsteps = trimDigits(d: inoutsteps)
      
      //if on the yardline
      if inoutsteps == 0 {
        return "On \(yl) on S\(side)"
      }
      else {
        return "\(inoutsteps) \(insideout) \(yl) on S\(side)"
      }
    }
    
    //  Convert description of front-to-back to number of steps from
    //  the front sideline
    func fb2steps(ref: Int, frontbehind: Int, fbsteps: Double) -> Double
    {
      var steps: Double = 0
      
      if frontbehind == 0
      {
        steps -= fbsteps
      }
      else if frontbehind == 1
      {
        steps += fbsteps
      }
      
      if ref == 1
      {
        if (Hash.selectedSegmentIndex == 0) {
          steps += 32
        } else {
          steps += 28
        }
      }
      else if ref == 2
      {
        if (Hash.selectedSegmentIndex == 0) {
          steps += 52
        } else {
          steps += 56
        }
      }
      else if ref == 3
      {
        steps += 84
      }
      
      steps = trimDigits(d: steps)
      
      return steps
    }
    
    //  Convert number of steps from front sideline
    //  to string description of front-to-back
    func steps2fb(steps: Double) -> String
    {
      var ref: String = ""
      var frontbehind: String = ""
      var fbsteps: Double = 0
      
      if (Hash.selectedSegmentIndex == 0) {
        if (steps > 84)
        {
          ref = "back sideline"  
          frontbehind = "behind"
          fbsteps = steps - 84  
        }
        else if ((steps > 68)&&(steps <= 84))
        {
          ref = "back sideline"  
          frontbehind = "in front of"  
          fbsteps = 84 - steps  
        }
          
        else if ((steps > 52)&&(steps <= 68))
        {
          ref = "back hash"  
          frontbehind = "behind"  
          fbsteps = steps - 52  
        }
          
        else if ((steps > 42)&&(steps <= 52))
        {
          ref = "back hash"  
          frontbehind = "in front of"  
          fbsteps = 52 - steps  
        }
          
        else if ((steps > 32)&&(steps <= 42))
        {
          ref = "front hash"  
          frontbehind = "behind"  
          fbsteps = steps - 32  
        }
          
        else if ((steps > 16)&&(steps <= 32))
        {
          ref = "front hash"  
          frontbehind = "in front of"  
          fbsteps = 32 - steps  
        }
          
        else if ((steps >= 0)&&(steps <= 16))
        {
          ref = "front sideline"  
          frontbehind = "behind"  
          fbsteps = steps  
        }
        
        else if (steps < 0)
        {
          ref = "front sideline"
          frontbehind = "in front of"
          fbsteps = steps*(-1)
        }
      } else {
        if (steps > 84)
        {
          ref = "back sideline"
          frontbehind = "behind"
          fbsteps = steps - 84
        }
        else if ((steps > 70)&&(steps <= 84))
        {
          ref = "back sideline"
          frontbehind = "in front of"
          fbsteps = 84 - steps
        }
          
        else if ((steps > 56)&&(steps <= 70))
        {
          ref = "back hash"
          frontbehind = "behind"
          fbsteps = steps - 56
        }
          
        else if ((steps > 42)&&(steps <= 56))
        {
          ref = "back hash"
          frontbehind = "in front of"
          fbsteps = 56 - steps
        }
          
        else if ((steps > 28)&&(steps <= 42))
        {
          ref = "front hash"
          frontbehind = "behind"
          fbsteps = steps - 28
        }
          
        else if ((steps > 14)&&(steps <= 28))
        {
          ref = "front hash"
          frontbehind = "in front of"
          fbsteps = 28 - steps
        }
          
        else if ((steps >= 0)&&(steps <= 14))
        {
          ref = "front sideline"
          frontbehind = "behind"
          fbsteps = steps
        }
          
        else if (steps < 0)
        {
          ref = "front sideline"
          frontbehind = "in front of"
          fbsteps = steps*(-1)
        }
      }
      
      
      fbsteps = trimDigits(d: fbsteps)
      if (fbsteps == 0) {
        return "\non \(ref)"
      }
      else {
        return "\n\(fbsteps) \(frontbehind) \(ref)"
      }
    }
    
    
    //  Draws a vector to scale
    func drawVector(xcomponent: Double, ycomponent: Double) {
      
      //  Returns points of arrowhead
      func getArrowPoints(point: CGPoint, angle: Double) -> [CGPoint] {
        var arrowPoints = [CGPoint]()
        
        let scale = (angle < 0 || angle > 180 ? 8.0 : -8.0)
        
        let xpoint1 = Double(point.x) - scale*cos(angle - 15)
        let ypoint1 = Double(point.y) + scale*sin(angle - 15)
        
        arrowPoints.append(CGPoint(x: xpoint1, y: ypoint1))
        
        let xpoint2 = Double(point.x) - scale*cos(angle + 15)
        let ypoint2 = Double(point.y) + scale*sin(angle + 15)
        
        arrowPoints.append(CGPoint(x: xpoint2, y: ypoint2))
        
        return arrowPoints
      }
      
      //  Create UILabel for vector components
      func createLabel(component: Double, bottomLeft: CGPoint, lwidth: CGFloat) {
        let newLabel = UILabel(
          frame: CGRect(x: bottomLeft.x, y: bottomLeft.y, width: lwidth, height: 20.0)
        )
        newLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        newLabel.textColor = .white
        newLabel.textAlignment = .center
        newLabel.text = String(component)
        
        
        VectorView.addSubview(newLabel)
      }
      
      
      let bp = UIBezierPath()
      let components = UIBezierPath()
      let line = CAShapeLayer()
      let componentlines = CAShapeLayer()
      
      let xmin = Double(VectorView.bounds.minX)
      let xmax = Double(VectorView.bounds.maxX)
      let ymin = Double(VectorView.bounds.minY)
      let ymax = Double(VectorView.bounds.maxY)
      
      let width = (xmax - xmin)
      let height = (ymax - ymin)
      
      
      //scaling by hypotenuse
      let hyp = sqrt((xcomponent * xcomponent)
                      + (ycomponent * ycomponent))
      var scale = 0.0
      if (hyp != 0) {
        scale = 80.0 / hyp
      }
      let xScaled = scale * xcomponent
      let yScaled = scale * ycomponent
      
      //defining coordinates for start and end points
      let xstart = xmin + (width / 2) - (xScaled / 2)
      let xend = xstart + xScaled
      
      let ystart = ymin + (height / 2) + (yScaled / 2)
      let yend = ystart - yScaled
      
      //creating start and end points
      let startPoint = CGPoint(x: xstart, y: ystart)
      let endPoint = CGPoint(x: xend, y: yend)
      
      
      bp.move(to: startPoint)
      bp.addLine(to: endPoint)
      
      
      //drawing x and y components
      if (xcomponent != 0 && ycomponent != 0) {
        components.move(to: startPoint)
        components.addLine(to: CGPoint(x: xend, y: ystart))
        components.move(to: CGPoint(x: xend, y: ystart))
        components.addLine(to: endPoint)
        
        componentlines.path = components.cgPath
        componentlines.strokeColor = UIColor.gray.cgColor
        componentlines.lineWidth = 1.5
        
      }

      //defining arrowhead points
      if (hyp != 0)
      {
        var angle = (xcomponent == 0 ? Double.pi/2 : atan(ycomponent / xcomponent))
        if (xcomponent < 0 || ycomponent < 0) {
          if (xcomponent > 0 && ycomponent < 0) {
            angle += 2*Double.pi
          } else {
            angle += Double.pi
          }
        }

        let arrowPoints = getArrowPoints(point: endPoint, angle: angle)
        let ap1 = arrowPoints[0]
        let ap2 = arrowPoints[1]
       
        bp.move(to: endPoint)
        bp.addLine(to: ap1)
        bp.move(to: endPoint)
        bp.addLine(to: ap2)

      }
      
      
      line.path = bp.cgPath
      line.strokeColor = UIColor.white.cgColor
      line.lineWidth = 2
      
      
      
      //clearing VectorView of previous drawings
      if (VectorView.layer.sublayers?.count != nil)
      {
        for sublayer : CALayer in VectorView.layer.sublayers! {
          sublayer.removeFromSuperlayer()
          }
      }
      
      //deciding width for ycomponent label
      let yComponentWidth = 8.0 * Double(String(abs(ycomponent)).characters.count)
      let yHeightPosition = CGFloat(ystart - (ystart - yend)/2 - 10)
      
      //creating vector component labels
      createLabel(component: abs(xcomponent), bottomLeft: CGPoint(x: xmin, y: ymax - 20), lwidth: CGFloat(width))
      createLabel(component: abs(ycomponent), bottomLeft: CGPoint(x: CGFloat(xmax - yComponentWidth), y: yHeightPosition), lwidth: CGFloat(yComponentWidth))
      
      VectorView.layer.addSublayer(line)
      VectorView.layer.addSublayer(componentlines)
    }
    
    
    
    let x1: Double = lr2steps(side: side1, insideout: insideoutside1, inoutsteps: lrsteps1, yl: yl1)
    let x2: Double = lr2steps(side: side2, insideout: insideoutside2, inoutsteps: lrsteps2, yl: yl2)
    
    let y1: Double = fb2steps(ref: fbref1, frontbehind: frontbehind1, fbsteps: fbsteps1)
    let y2: Double = fb2steps(ref: fbref2, frontbehind: frontbehind2, fbsteps: fbsteps2)
   
    OutputLabel.adjustsFontSizeToFitWidth = true

    //displaying midset/thirdsets/quartersets
    if (MTQSet.selectedSegmentIndex == 0) {
      let xmidset = trimDigits(d: (x1 + x2)/2)
      let ymidset = trimDigits(d: (y1 + y2)/2)
      
      OutputLabel.text = String(steps2lr(steps: xmidset)) + String(steps2fb(steps: ymidset))
      
    } else if (MTQSet.selectedSegmentIndex == 1) {
      let xthirdset = trimDigits(d: x1 + (x1 - x2)/3)
      let x2thirdset = trimDigits(d: x1 + 2*(x1 - x2)/3)
      
      let ythirdset = trimDigits(d: y1 + (y1 - y2)/3)
      let y2thirdset = trimDigits(d: y1 + 2*(y1 - y2)/3)
      
      OutputLabel.text = "1/3: " + String(steps2lr(steps: xthirdset))
          + String(steps2fb(steps: ythirdset))
          + "\n\n2/3: " + String(steps2lr(steps: x2thirdset))
          + String(steps2fb(steps: y2thirdset))
    } else if (MTQSet.selectedSegmentIndex == 2) {
      let xqset = trimDigits(d: x1 + (x1 - x2)/4)
      let x3qset = trimDigits(d: x1 + 3*(x1 - x2)/4)
      let xmidset = trimDigits(d: (x1 + x2)/2)
      let ymidset = trimDigits(d: (y1 + y2)/2)
      let yqset = trimDigits(d: y1 + (y1 - y2)/4)
      let y3qset = trimDigits(d: y1 + 3*(y1 - y2)/4)
      
      
      OutputLabel.text = "1/4: " + String(steps2lr(steps: xqset))
        + String(steps2fb(steps: yqset))
        + "\n\n2/4: " + String(steps2lr(steps: xmidset))
        + String(steps2fb(steps: ymidset))
        + "\n\n3/4: " + String(steps2lr(steps: x3qset))
        + String(steps2fb(steps: y3qset))
      
    }
    
    
    //drawing vector with opposite ycomponent so
    //vector will show performers viewpoint
    drawVector(xcomponent: (x2 - x1), ycomponent: -(y2 - y1))
    
    
  }
  
  
  //  Clears UITextField when editing begins
  @IBAction func clearText(_ sender: UITextField) {
    
    sender.text = ""
    
  }
  
  //  Sets background to image with filename "file".
  func setBackground(file: String) {
    
    let bg = UIImageView(frame: self.view.bounds)
    bg.image = UIImage(named: file)
    bg.contentMode = UIViewContentMode.scaleAspectFill
    self.view.insertSubview(bg, at: 0)
    
  }
  
  //  Sets all the UITextField keyboards to a new type
  func setKeyboardType(type: UIKeyboardType) {
    
    for view in view.subviews as [UIView] {
      if let textfield = view as? UITextField {
        textfield.keyboardType = .decimalPad
      }
    }
    
  }
  
  //  Closes keyboard if screen is tapped
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()


    //init UI settings
    setBackground(file: "turfdark")
    setKeyboardType(type: UIKeyboardType.numberPad)
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  


}


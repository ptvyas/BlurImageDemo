//
//  ViewController.swift
//  BlurImageDemo
//
//  Created by iMac on 09/06/20.
//  Copyright © 2020 Piyush Vyas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var process: UISlider!
    
    
    //MARK:- Variable
    var imgProcess : UIImage = UIImage(named: "img")!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imgMain.layer.borderColor = UIColor.red.cgColor
        self.imgMain.layer.borderWidth = 2.0
        self.imgMain.layer.masksToBounds = true
        
        self.process.maximumValue = 10.0
        self.process.minimumValue = 0.0
        self.process.value = 10 //2.5
        
        self.ProcessChange( self.process)
    }

    //MARK:- Button action
    @IBAction func ProcessChange(_ sender: UISlider) {
        /*if let img = addBlurTo(self.imgPrcess, value: CGFloat(process?.value ?? 0.1)) {
            self.lblValue.text = (process?.value ?? 0.1).description
            self.imgMain.image = img
        }*/
        
        let value = (process?.value ?? 0.1)
        self.lblValue.text = value.description
        self.imgMain.image = self.imgProcess.blurred(radius: CGFloat(value))
    }
    
    //MARK:-
    //TODO:- Simple
    func addBlurTo(_ image: UIImage, value : CGFloat) -> UIImage? {
        guard let ciImg = CIImage(image: image) else { return image }
        let blur = CIFilter(name: "CIGaussianBlur")
        blur?.setValue(ciImg, forKey: kCIInputImageKey)
        
        //blur?.setValue(5.0, forKey: kCIInputRadiusKey)
        //blur?.setValue(2.50, forKey: kCIInputRadiusKey)
        blur?.setValue(value, forKey: kCIInputRadiusKey)
        
        if let outputImg = blur?.outputImage {
            return UIImage(ciImage: outputImg)
        }
        return image
    }
    
    //TODO:- Lib.
}

extension UIImage {
    //Source: https://gist.github.com/mxcl/76f40027b1ef515e4e6b41292b54fe92
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
}


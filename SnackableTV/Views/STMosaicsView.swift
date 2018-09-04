//
//  STMosaicsView.swift
//  MosaicTiles
//
//  Created by Austin Chen on 2017-05-08.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

struct TilesPerLayer {
    let (rows, columns): (Int, Int)
    let spaces: CGPoint
    let size: CGSize
    let tileColor: UIColor
    let images: [UIImage]
}

struct RectPerImage {
    let originOffset: CGPoint
    let widthOffset: CGFloat
}

class STMosaicsView: UIView {
    @IBOutlet var contentView: UIView!
    
    var layerViews: [UIView] = []
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "STMosaicsView", bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add the missing contrainst between xib contentView to self
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.setNeedsUpdateConstraints()
        
        // self.translatesAutoresizingMaskIntoConstraints = true
        layerViews = self.setupTiles()
        layerViews.forEach{ contentView.addSubview($0) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }
    
    func setupTiles() -> [UIView] {
        let numberOfImages = 18
    
        var imgArray: [UIImage] = []
        var imgRectArray: [RectPerImage] = []
        for i in 0..<numberOfImages {
            let n = String(format: "splash_%d", i)
            guard let img = UIImage(named: n) else { continue }
            imgArray.append(img)
            
            let rdmInt = Int(arc4random_uniform(10))
            print("rdm: \(rdmInt)")
            
            let rdmDim = CGFloat(rdmInt * 10)
            let rpi = RectPerImage(originOffset: CGPoint(x: rdmDim, y: rdmDim), widthOffset: rdmDim)
            imgRectArray.append(rpi)
        }
        
        var layerViews: [UIView] = []
        
        let ratio: CGFloat = 3.0 / 2.0
        
        let width1: CGFloat = UIScreen.main.bounds.width / 1.5
        let height1: CGFloat = width1 * ratio
        
        let width2: CGFloat = UIScreen.main.bounds.width / 3.0
        let height2: CGFloat = width2 * ratio
        
        let layer1 = TilesPerLayer(rows: 4, columns: 2,
                                   spaces: CGPoint(x: 60, y: 100),
                                   size: CGSize(width: width1, height: height1),
                                   tileColor: UIColor.red,
                                   images: [])
        
        let layer2 = TilesPerLayer(rows: 5, columns: 2,
                                   spaces: CGPoint(x: 20, y: 260),
                                   size: CGSize(width: width2, height: height2),
                                   tileColor: UIColor.blue,
                                   images: [])
        
        let layers = [layer1, layer2]
        
        var i = 0
        var imgIdx = 0
        for (layerIdx, tilePerLayer) in layers.enumerated() {
            let layerView = UIView()
            for r in 0..<tilePerLayer.rows {
                for c in 0..<tilePerLayer.columns {
                    let view = UIImageView()
                    view.backgroundColor = tilePerLayer.tileColor
                    view.image = imgArray[imgIdx]
                    layerView.addSubview(view)
                    
                    
                    var f = view.frame
                    f.size = tilePerLayer.size
                    
                    if c % 2 == 0 { // odd columss
                        f.origin.y = CGFloat(r) * (tilePerLayer.size.height + tilePerLayer.spaces.y)
                    } else { // even columns
                        var offsetY: CGFloat = 100
                        if layerIdx == 1 {
                            offsetY = 240
                        }
                        f.origin.y = CGFloat(r) * (tilePerLayer.size.height + tilePerLayer.spaces.y) + offsetY
                    }
                    
                    if r % 2 == 0 { // odd rows
                        f.origin.x = CGFloat(c) * (tilePerLayer.size.width + tilePerLayer.spaces.x) - 10
                    } else {
                        f.origin.x = CGFloat(c) * (tilePerLayer.size.width + tilePerLayer.spaces.x) + 10
                    }
                    view.frame = f
                    
                    
                    imgIdx += 1
                }
            }
            
            layerViews.append(layerView)
            
            //
            let lWidth = CGFloat(tilePerLayer.columns) * tilePerLayer.size.width +
                CGFloat(tilePerLayer.columns - 1) * tilePerLayer.spaces.x
            let lHeight = CGFloat(tilePerLayer.rows) * tilePerLayer.size.height +
                CGFloat(tilePerLayer.rows - 1) * tilePerLayer.spaces.y
            var f = layerView.frame
            f.size = CGSize(width: lWidth, height: lHeight)
            f.origin = CGPoint(x: (UIScreen.main.bounds.width - lWidth) / 2.0,
                               y: (UIScreen.main.bounds.height - lHeight) / 2.0)
            layerView.frame = f
            
            i += 1
        }
        
        return layerViews 
    }
    
}

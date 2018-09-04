//
//  STTabsHeaderView.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STTabsHeaderViewDelegate: class {
    func didSelectTab(atIndex idx: Int)
}

protocol STTabsHeaderViewType {
    var tabTitles: [String] {get set}
    weak var delegate: STTabsHeaderViewDelegate? {get set}
    
    var leftTabScrollDistance: CGFloat {get}
    var rightTabScrollDistance: CGFloat {get}
    func animateTabOffsetX(_ x: CGFloat)
    func setTabs(deltaOffsetX x: CGFloat, direction: STCardScrollDirection)
    func animateScroll(direction: STCardScrollDirection)
}

class STTabsHeaderView: UIView {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // constants
    let cellWidth: CGFloat = 150 // UIScreen.main.bounds.width / 5.0 // custom set
    
    var tabTitles: [String] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    fileprivate var selectedIndex: Int = 0
    
    var tabMinX: CGFloat = 0
    var allowBounce: Bool = false
    weak var delegate: STTabsHeaderViewDelegate?
    
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
        let nib = UINib(nibName: "STTabsHeaderView", bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add the missing contrainst between xib contentView to self
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.setNeedsUpdateConstraints()

        // self.translatesAutoresizingMaskIntoConstraints = true
        
        // set up datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "STTabHeaderCollectionViewCell", bundle: Bundle(for: type(of: self))),
                                forCellWithReuseIdentifier: "kTabHeaderCollectionCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    // MARK: instance methods
    
    var tabOffsetX: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        set {
            // check newValue is within content size
            var n: CGFloat = 0.0
            
            if !allowBounce {
                if tabOffsetX < newValue { // scroll left
                    n = min(newValue, self.collectionView.contentSize.width - self.bounds.size.width)
                } else { // scroll right
                    n = max(newValue, 0.0)
                }
            }
            
            // set content offset
            var point = self.collectionView.contentOffset
            point.x = n
            self.collectionView.contentOffset = point
        }
    }
}

extension STTabsHeaderView {
    
    var currentTabMidX: CGFloat {
        return tabMinX + viewBoundHalfWidth
    }
    
    var minScrollableMaxX: CGFloat {
        return self.bounds.width
    }
    
    var minScrollableMidX: CGFloat {
        return viewBoundHalfWidth
    }
    
    var maxScrollableMinX: CGFloat {
        return self.collectionView.contentSize.width - self.bounds.width
    }
    
    var maxScrollableMidX: CGFloat {
        return self.collectionView.contentSize.width - viewBoundHalfWidth
    }
    
    var viewBoundHalfWidth: CGFloat {
        return self.bounds.width * 0.5
    }
}

fileprivate let kAnimateDuration = 0.4

extension STTabsHeaderView: STTabsHeaderViewType {

    func animateTabOffsetX(_ x: CGFloat) {
        self.animateTabOffsetX(x, completion: nil)
    }
    
    func animateTabOffsetX(_ x: CGFloat,
                           completion: ((Bool) -> ())? = nil ) {
        UIView.animate(withDuration: kAnimateDuration, delay: 0, options: .curveEaseOut, animations: {
            self.tabOffsetX = x
        }, completion: { (finished) in
            self.tabMinX = self.tabOffsetX
            
            guard let c = completion else { return }
            c(finished)
        })
    }
    
    func resetSelectedIndex() {
        selectedIndex = 0
        self.collectionView.reloadData()
        self.collectionView.contentOffset = CGPoint()
    }
    
    var leftTabScrollDistance: CGFloat {
        guard selectedIndex - 1 >= 0 else { return 0 }
        
        let leftTabMidX = CGFloat(selectedIndex - 1) * cellWidth + cellWidth * 0.5
        let scrollToX = min(maxScrollableMidX, currentTabMidX)
        if scrollToX > leftTabMidX {
            return scrollToX - leftTabMidX
        } else {
            return 0 // should not scroll
        }
    }
    
    var rightTabScrollDistance: CGFloat {
        guard selectedIndex + 1 < tabTitles.count else { return 0 }
        
        let rightTabMidX = CGFloat(selectedIndex + 1) * cellWidth + cellWidth * 0.5
        let scrollToX = max(minScrollableMidX, currentTabMidX)
        if scrollToX < rightTabMidX {
            return rightTabMidX - scrollToX
        } else {
            return 0 // should not scroll
        }
    }
    
    func setTabs(deltaOffsetX x: CGFloat, direction: STCardScrollDirection) {
        if (direction == .scrollLeft && x >= self.rightTabScrollDistance) ||
            (direction == .scrollRight && x >= self.leftTabScrollDistance)
        {
            return // dont over scroll
        }
        
        let d: CGFloat = direction == .scrollLeft ? 1 : -1
        self.tabOffsetX = self.tabMinX + x * d
    }
    
    func animateScroll(direction: STCardScrollDirection) {
        let idx = direction == .scrollLeft ? selectedIndex + 1 : selectedIndex - 1
        self.animateScroll(toIndex: idx)
    }
    
    func animateScroll(toIndex idx: Int) {
        guard idx >= 0, idx < tabTitles.count // check bound
            else { return }
        
        guard idx != selectedIndex // check redundancy
            else { return }
        
        let tabsInBetweenCount = abs(idx - selectedIndex) - 1
        
        if idx > selectedIndex {
            // animate scroll left
            let neightborX = min(self.maxScrollableMinX, tabMinX + rightTabScrollDistance)
            let totalD = min(self.maxScrollableMinX, neightborX + CGFloat(tabsInBetweenCount) * cellWidth)
            
            self.animateTabOffsetX(totalD)
            /*
            self.isUserInteractionEnabled = false
            self.animateTabOffsetX(totalD, completion: { (_) in
                self.selectedIndex = idx
                self.collectionView.reloadData() // adding BOlD text focus
                self.isUserInteractionEnabled = true
            })
            */
        } else {
            // animate scroll right
            let neightborX = max(0, tabMinX - leftTabScrollDistance)
            let totalD = max(0, neightborX - CGFloat(tabsInBetweenCount) * cellWidth)
            
            self.animateTabOffsetX(totalD)
        }
        self.selectedIndex = idx
        self.collectionView.reloadData() // adding BOlD text focus
    }
}

extension STTabsHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth, height: self.bounds.size.height);
    }
}

extension STTabsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.setContentOffset(CGPoint(x: 25*self.tabTitles.count*150,y :0), animated: false)

        return tabTitles.count*50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "kTabHeaderCollectionCell", for: indexPath) as! STTabHeaderCollectionViewCell
        item.tag = indexPath.row
        
        // hight light selected cell
        if selectedIndex == indexPath.row {
            item.headerTitleLabel.font = UIFont.montserratFont(ofSize: 17.0, weight: UIFontWeightMedium)
            item.headerTitleLabel.textColor = UIColor.white
        } else {
            item.headerTitleLabel.font = UIFont.montserratFont(ofSize: 17.0, weight: UIFontWeightLight)
            item.headerTitleLabel.textColor = UIColor(white: 1, alpha: 0.6)
        }
        item.headerTitleLabel.text = self.tabTitles[indexPath.row%self.tabTitles.count]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.animateScroll(toIndex: indexPath.row)
        self.delegate?.didSelectTab(atIndex: indexPath.row%self.tabTitles.count)
    }
}

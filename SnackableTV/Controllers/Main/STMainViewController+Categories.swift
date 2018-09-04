//
//  STMainViewController+Categories.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

struct STCategoryItem {
    let title: String
    let viewController: STCardViewController
    let collectionId: Int64
}

typealias STTopCategoryItem = (name: String, items: [STCategoryItem])

//let sharedCategoryItems: [ (name: String, items: [STCategoryItem]) ] = [
//    (
//        name: "Feed",
//        items: [
//            STCategoryItem(title: "My Snackable", viewController:
//                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stTableVC") as! STCardViewController, tempCollectionId: 1716),
//            STCategoryItem(title: "Comedy", viewController:
//                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stTableVC") as! STCardViewController, tempCollectionId: 1715),
//            STCategoryItem(title: "Lifestyle", viewController:
//                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stTableVC") as! STCardViewController, tempCollectionId: 1714),
//            STCategoryItem(title: "Entertainment", viewController:
//                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stTableVC") as! STCardViewController, tempCollectionId: 1711),
//            STCategoryItem(title: "News", viewController:
//                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stTableVC") as! STCardViewController, tempCollectionId: 1712)
//        ]
//    ),
//    
//    (
//        name: "Series",
//        items: [STCategoryItem(title: "All Series", viewController:
//            UIStoryboard(name: "Series", bundle: nil).instantiateViewController(withIdentifier: "stSeriesVC") as! STCardViewController, tempCollectionId: 1705),
//        STCategoryItem(title: "Most Recent Episodes", viewController:
//            UIStoryboard(name: "Series", bundle: nil).instantiateViewController(withIdentifier: "stSeriesVC") as! STCardViewController, tempCollectionId: 1718),
//
//        ]
//    ),
//    
//    (
//        name: "Watch History",
//        items: [STCategoryItem(title: "", viewController:
//            UIStoryboard(name: "WatchHistory", bundle: nil).instantiateViewController(withIdentifier: "stWHTableVC") as! STCardViewController, tempCollectionId: -1)]
//    )
//]

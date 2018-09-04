/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

//
//  PTAdBannerView.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 2/14/13.
//

#import <UIKit/UIKit.h>
#import "PTAdAsset.h"
#import "PTMediaPlayer.h"

/**
 * The PTAdBannerView class is a utility class to display a banner asset. The application must create a new instance
 * of this class, set the banner asset, and add it to a view. The impression and click tracking for the banner is internally
 * managed by this class. 
 */
@interface PTAdBannerView : UIView <UIWebViewDelegate>

/** @name Properties */
/**
 * The PTAdAsset instance used to intialize the banner view
 */
@property (nonatomic, readonly) PTAdAsset *banner;

/** @name Properties */
/**
 * PTAdBannerView internally uses a UIWebView to display the banner asset. The application can register itself as a
 * delegate to this web view
 */
@property (nonatomic, assign) id<UIWebViewDelegate> delegate;

/** @name Properties */
/**
 * The PTMediaPlayer instance is required for notifying clicks within the banner view
 */
@property (nonatomic, assign) PTMediaPlayer *player;

/**
 * Initializes a new PTAdBannerView instance with an ad asset instance
 *
 * @param asset A PTAdAsset banner instance that this view will display
 */
- (id)initWithAsset:(PTAdAsset *)asset;

@end

/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
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
//  PTMediaPlayerView.h
//  MediaPlayer
//
//  Created by Catalin Dobre on 4/15/12.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 * PTMediaPlayerView class manages the view component of the PMP framework
 */
@interface PTMediaPlayerView : UIView

/** @name Properties */
/**
 * Returns the internal player instance of PMP framework
 *
 * IMPORTANT: Developers must use caution while calling any methods on this instance due to potential
 * conflicts with the SDK. It is strongly recommended that the internal player instance be only used for
 * reading specific AVPlayer properties and all methods that change the state of playback
 * or configuration of the player be handled through the PTMediaPlayer instance.
 *
 * Note: This property is only available after the PTMediaPlayer is initialized
 */
@property (nonatomic, readonly, strong) AVPlayer *player;

/** @name Properties */
/**
 * Returns the video gravity property of the player.
 */
@property (nonatomic, strong) NSString *videoGravity;

@end

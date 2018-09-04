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
//  PTQoSProvider.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 1/14/13.
//

#import <Foundation/Foundation.h>

@class PTMediaPlayer;
@class PTPlaybackInformation;
@class PTDeviceInformation;

/**
 * PTQoSProvider holds the essential qos metrics for both playback and device.
 */
@interface PTQoSProvider : NSObject

/** @name playbackInformation */
/**
 * Returns the QOS information related to the playback.
 * This property is not observable.
 */
@property (nonatomic, readonly) PTPlaybackInformation *playbackInformation;

/** @name deviceInformation */
/**
 * Returns the QOS information related to the device.
 * This property is not observable.
 */
@property (nonatomic, readonly) PTDeviceInformation *deviceInformation;


/** @name  initWithPlayer */
/**
 * Use this initializer to create a PTQoSProvider linked the provided player.
 */
- (id) initWithPlayer:(PTMediaPlayer *)player;

@end

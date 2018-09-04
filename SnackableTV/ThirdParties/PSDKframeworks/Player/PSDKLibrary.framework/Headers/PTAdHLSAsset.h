//
//  PlaylistAd.h
//  AuditudeAdAPI
//
//  Created by Venkat Jonnadula on 2/23/12.
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

#import <Foundation/Foundation.h>
#import "PTAdAsset.h"
#import "PTNotification.h"

@protocol PTAdHLSAssetLoaderDelegate <NSObject>

@required

/**
 * Notifies the delegate that the current hls asset has finished loading the manifests (master and variants)
 */
- (void)loadComplete:(id)playlistAd;

/**
 * Notifies the delegate that the current hls asset failed to load manifests
 */
- (void)loadFailed:(id)playlistAd;

@optional
/**
 * Notifies the delegate that the current hls asset failed to load manifests
 */
- (void)loadFailed:(id)playlistAd withError:(PTNotification *)notification;

@end

/**
 * The PTAdHLSAsset instance represents an HLS asset for a break.
 */
@interface PTAdHLSAsset : PTAdAsset

/** @name Properties */
/**
 * Collection of different bitrate streams in the HLS playlist.
 */
@property (nonatomic, retain) NSArray *streams;

/** @name Properties */
/**
 * Readonly value of HLS version of the current variant playlist.
 */
@property (nonatomic, readonly) int hlsVersion;

/** @name Properties */
/**
 * Readonly value of Target Duration of the current variant playlist.
 */
@property (nonatomic, readonly) int targetDuration;

/** @name Properties */
/**
 * Boolean indicating if there is a stream with audio only content available.
 * By default the value is NO.
 */
@property (nonatomic, readonly) BOOL hasAudioOnlyStream;

/** Load Stream **/
/**
 * Loads the manifests (master and variants) for the ad notifying the delegate when the load is completed or failed
 */
- (void)loadWithDelegate:(id<PTAdHLSAssetLoaderDelegate>)del;

/** Load Stream **/
/**
 * Cancels the manifest load. The delegate is not called after this method completes execution
 */
- (void)cancel;

@end

/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
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

#import "PTMediaPlayerItem.h"
#import "PTAd.h"

/**
 * A protocol describing the methods that an ad hanler object must implement to play custom ads.
 * Only Adobe certified custom ad handlers will work at this time.
 */
@protocol PTCustomAdPlaybackHandler <NSObject>

/**
 * A function called on player initialization to configure the ad handler with the current PTMediaPlayerItem instance.
 */
- (void)configure:(PTMediaPlayerItem *)item;

/**
 * Return whether a given PTAd instance can be handled by this ad handler
 */
- (BOOL)canHandleAd:(PTAd *)ad;

/**
 * Initialize the playback of the PTAd instance
 */
- (void)initAd:(PTAd *)ad;

/**
 * Start playback of the PTAd instance
 */
- (void)startAd;

/**
 * Pause playback of the PTAd instance
 */
- (void)pauseAd;

/**
 * Resume playback fo the PTAd instance
 */
- (void)resumeAd;

/**
 * Stop playback of the PTAd instance
 */
- (void)stopAd;

/**
 * Stop playback and deallocate all resources
 */
- (void)dispose;

@end

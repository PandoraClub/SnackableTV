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
//  PTAdResolver.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 1/20/13.
//

#import <Foundation/Foundation.h>

#import "PTMetadata.h"
#import "PTAdAvailInfo.h"
#import "PTTimeline.h"
#import "PTMediaPlayerItem.h"

/**
 * PTAdResolverDelegate protocol provides delegate calls for a PTAdResolver class.
 *
 * The ad resolver instance must use these class to notify the delegate on success and failure of an ad call.
 * Failure to do so may result in stalling of playback.
 */
@protocol PTAdResolverDelegate <NSObject>

@required

/** @name Ad Management */
/**
 * Invoked when the PTAdResolver instance has successfully completed resolving ads for an avail.
 *
 * The PTTimeline instance provides information about the breaks and ads obtained from the ad server
 */
- (void)adResolutionComplete:(PTTimeline *)timeline;

/** @name Ad Management */
/**
 * Invoked when the PTAdResolver instance has failed to resolve ads for an avail.
 *
 * The playerErrors array provides information about any errors that caused the failure to resolve ads
 * Each entry in the array is an instance of PTNotification class with a code and description.
 */
- (void)adResolutionFailedWithErrors:(NSArray *)playerErrors;

@end


/**
 * PTAdResolver protocol provides calls to request ads from an ad server
 */
@protocol PTAdResolver <NSObject>

@property (nonatomic, readonly) PTTimeline *timeline;

/** @name Ad Management */
/**
 * Initiate a PTAdResolver instance with a media player item
 */
- (id)initWithDelegate:(id <PTAdResolverDelegate>)delegate mediaItem:(PTMediaPlayerItem *)mediaItem;

/** @name Ad Management */
/**
 * Initiates a call to request ads from the server.
 *
 * PTAdAvailInfo instance provides information for the ad call such as the request type (pre, mid or post), duration of
 * the avail, time of the avail, and any runtime metadata.
 *
 * Returns YES if the request is handled by this instance. NO otherwise.
 */
- (BOOL)resolveAds:(PTAdAvailInfo *)availInfo;

/** @name Ad Management */
/**
 * Initiates a call to request ads from the server for a group of ad avails.
 *
 * PTAdAvailInfo instance provides information for the ad call such as the request type (pre, mid or post), duration of
 * the avail, time of the avail, and any runtime metadata.
 *
 * Returns YES if the request is handled by this instance. NO otherwise.
 */
- (BOOL)resolveAdsForAvails:(NSArray *)availInfoList;

/** @name Ad Management */
/**
 * Cancels any calls to resolve ads.
 *
 * The PTAdResolver instance is expected cancel all pending ad requests and not invoke any delegate methods.
 */
- (void)cancel;

@end
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
//  PTAdBreak.h
//
//  Created by Catalin Dobre on 3/25/12.
//

#import <AVFoundation/AVFoundation.h>

#import "PTAd.h"

/**
 * These enumeration values define the type of an ad break instance.
 */
typedef NS_ENUM(NSInteger, PTAdBreakType)
{
	/** A preroll ad break: plays before the main content. */
    PTAdBreakTypePreroll = 0,

    /** A midroll ad break: plays during the main content. */
    PTAdBreakTypeMidroll,
    
    /** A postroll ad break: plays at the end of the main content. */
    PTAdBreakTypePostroll
};

/**
 * The PTAdBreak instance represents a continous sequence of ads spliced into the content
 */
@interface PTAdBreak : NSObject

/** @name Properties */
/**
 * Returns the index of the ad break within the timeline starting with 0. For LIVE streams, this value will be 0 on each ad break.
 */
@property (nonatomic, assign) NSInteger index;

/** @name Properties */
/**
 * Returns a CMTimeRange describing the start time of the break relative to the original content and the duration of the ad break.
 */
@property (nonatomic, assign) CMTimeRange relativeRange;

/** @name Properties */
/**
 * Returns a CMTimeRange describing the absolute start time of the break (content with ads spliced) and the duration of the break.
 */
@property (nonatomic, assign) CMTimeRange range;

/** @name Properties */
/**
 * Returns an array of ads to be played within this break
 */
@property (nonatomic, readonly) NSMutableArray *ads;

/** @name Properties */
/**
 * Returns a boolean indicating whether this break has been watched or not. An ad break is marked as watched by default
 * when any ad within the ad break begins to play.
 */
@property (nonatomic, readonly) BOOL isWatched;

/** @name Properties */
/**
 * Returns the data of the break.
 */
@property (retain, nonatomic) NSDictionary *data;

/** @name Properties */
/**
 * Specifies the type of the ad break (pre, mid or post).
 */
@property (nonatomic, readonly) PTAdBreakType type;

/**
 * Adds a PTAd instance to the list of ads contained within the break.
 */
- (void)addAd:(PTAd *)ptAd;

@end

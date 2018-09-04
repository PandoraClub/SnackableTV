//
//  PTAdPolicySelector.h
//  PSDKLibrary
//
//  Created by Venkat Jonnadula on 3/12/14.
//  Copyright (c) 2014 Adobe Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAdBreak.h"
#import "PTAdMetadata.h"

/**
 * These enumeration values define what policy to apply when an ad break is encountered during playback.
 */
typedef NS_ENUM(NSInteger, PTAdBreakPolicyType)
{
	/** Specifies that the ad break must be skipped. */
    PTAdBreakPolicyTypeSkip = 0,
    
    /** Specifies that the ad break must be played. */
	PTAdBreakPolicyTypePlay
};

/**
 * These enumeration values define what policy to apply when the user seeks into an ad break.
 */
typedef NS_ENUM(NSInteger, PTAdPolicyType)
{
    /** Specifies that the ad in the ad break must be played from the position seeked to. */
	PTAdPolicyTypePlay = 0,
    
    /** Specifies that the ad in the ad break must be played from the beginning. */
    PTAdPolicyTypePlayFromAdBegin,
    
    /** Specifies that the ad break itself must be played from the beginning. */
    PTAdPolicyTypePlayFromAdBreakBegin,
    
    /** Specifies that the playback should begin from the next ad in the ad break. */
	PTAdPolicyTypeSkipToNextAdInBreak,
    
    /** Specifies that the ad break should be skipped and playback should resume from the end of the ad break */
    PTAdPolicyTypeSkipAdBreak
};

/**
 * These enumeration values define whether an ad policy is being applied during a normal playback mode or a seek.
 */
typedef NS_ENUM(NSInteger, PTAdPolicyMode)
{
    /** Ad Policy associated with a normal playback mode */
    PTAdPolicyModePlay = 0,
    
    /** Ad policy associated with a event occuring during or immediately after seek */
    PTAdPolicyModeSeek
};

/**
 * The context provided for enforcing each ad behavior
 */
@interface PTAdPolicyInfo : NSObject

/** @name Property */
/**
 * An array of PTAdBreak instances.
 * If the user hits an ad break during normal playback, the array consists of a single ad break
 * If the user seeks over one or more ad breaks, this array contains all the ad breaks that are skipped (includes watched ad breaks)
 */
@property (nonatomic, readonly) NSArray *adBreaks;

/** @name Property */
/**
 * A PTAd instance that is relevant for this policy.
 */
@property (nonatomic, readonly) PTAd *ad;

/** @name Property */
/**
 * The current time of the video playback (includes dynamically spliced ads)
 */
@property (nonatomic, readonly) CMTime currentTime;

/** @name Property */
/**
 * The requested seek time (includes dynamically spliced ads)
 */
@property (nonatomic, readonly) CMTime seekToTime;

/** @name Property */
/**
 * The current playback rate of the video
 */
@property (nonatomic, readonly) float rate;

/** @name Property */
/**
 * The policy mode in which the ad behavior is requsted
 */
@property (nonatomic, readonly) PTAdPolicyMode mode;

@end

/**
 * An Ad Policy selector protocol for enforcing ad behaviors. Applications can confirm to this protocol by
 * implementing all the required methods or extend the existing default policy selector class to customize specific
 * behaviors.
 */
@protocol PTAdPolicySelector <NSObject>

@required

/** @name Policy Selection */
/**
 * Policy to define when to mark an ad break as watched.
 * The value can be one of the options defined in the PTAdBreakIsWatched enumeration with PTAdBreakIsWatchedOnBegin as default.
 * Modes: PTAdBreakAsWatchedOnBegin, PTAdBreakAsWatchedOnEnd, PTAdBreakAsWatchedNever
 */
- (PTAdBreakAsWatched)selectWatchedPolicyForAdBreak:(PTAdPolicyInfo *)info;

/** @name Policy Selection */
/**
 * Selects the ad break policy for next ad break.
 *
 * @param adPolicyInfo Context for selecting the right policy.
 * @return a valid PTAdBreakPolicyType value.
 */
- (PTAdBreakPolicyType)selectPolicyForAdBreak:(PTAdPolicyInfo *)info;

/** @name Policy Selection */
/**
 * Selects the ad breaks to be played when the user seeks over one or more ad breaks
 * Default behavior is to seek to the ad breaks that is closest to the requested seek time.
 * If that ad break is already watched, seek is performed to the requested time immediately.
 *
 * @param adPolicyInfo Context for selecting the right policy.
 * @return an array of PTAdBreak instances to be played.
 */
- (NSArray *)selectAdBreaksToPlay:(PTAdPolicyInfo *)info;

/** @name Policy Selection */
/**
 * Selects the ad policy when the user seeks into the middle of an ad
 *
 * @param adPolicyInfo Context for selecting the right policy.
 * @return a valid PTAdPolicyType value.
 */
- (PTAdPolicyType)selectPolicyForSeekIntoAd:(PTAdPolicyInfo *)info;

@end




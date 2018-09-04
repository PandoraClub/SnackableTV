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
//  PTMediaPlayerClientFactory.h
//  MediaPlayer
//
//  Created by - on 1/23/14.
//

#import <Foundation/Foundation.h>
#import "PTAdPolicySelector.h"
#import "PTAVAssetResourceLoaderDelegate.h"
#import "PTCustomAdPlaybackHandler.h"

/**
 * PTMediaPlayerClientFactory protocol describes the method that a custom media player client factory should implement in order to provide the available PTOpportunityResolver, PTContentResolver and PTAdPolicySelector instances.
 */

@protocol PTMediaPlayerClientFactory <NSObject>

@required

/** @name retrieveOpportunityResolvers */
/**
 * Returns the currently available PTOpportunityResolver classes
 */
- (NSArray *)retrieveOpportunityResolvers;

/** @name retrieveContentResolvers */
/**
 * Returns the currently available PTContentResolver classes
 */
- (NSArray *)retrieveContentResolvers;

@optional

/** @name PTAdPolicySelector */
/**
 * Returns the ad policy selector instance used for enforcing ad behaviors within PSDK
 * If applications do not specifcy an instance, PSDK creates a default policy selector
 */
- (id<PTAdPolicySelector>)retrieveAdPolicySelector;

/** @name PTAVAssetResourceLoaderDelegate */
/**
 * Returns the custom resource loader instance (PTAVAssetResourceLoader) used by the player. 
 * The player will use the registered AVAsset resource loader when assistance is required of the application to
 * load a resource. See AVFoundation's AVAssetResourceDelegate.
 */
- (id<PTAVAssetResourceLoaderDelegate>)retrievePTAVAssetResourceLoader;

/** @name PTCustomAdPlaybackHandler */
/**
 * Returns an array of custom ad playback handlers associated with the specified
 * media player item.
 *
 * @return  an array containing the registered ad playback handlers or an empty
 *          array if none was found.
 */
- (NSArray *)retrieveCustomAdPlaybackHandlers;

@end
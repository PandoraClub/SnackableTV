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
//  PTContentResolver.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 3/18/14.
//

#import <Foundation/Foundation.h>

@class PTPlacementOpportunity;
@class PTMediaPlayerItem; 
@class PTMediaError;
@class PTTimedMetadata;
@class PTTimeline;

/**
 * PTContentResolverDelegate protocol describes the methods that the custom content resolver (PTContentResolver) should use to communicate the delegate the status of the resolving of content.
 */

@protocol PTContentResolverDelegate <NSObject>
@required
- (void)didStartResolvingContentWithOpportunities:(NSArray * /*PTPlacementOpportunity*/)opportunities;
- (void)didFinishResolvingContentWithOpportunities:(NSArray * /*PTPlacementOpportunity*/)opportunities withTimeline:(PTTimeline *)timeline;
- (void)didFailResolvingContentWithOpportunities:(NSArray * /*PTPlacementOpportunity*/)opportunities withErrors:(NSArray * /*PTMediaError*/)errors;
@end

/**
 * PTContentResolver protocol describes the methods that are required for a customized content resolver
 */

@protocol PTContentResolver <NSObject>

@required

/** @name shouldHandleOpportunity */
/**
 * Content resolver returns YES/NO if it should handle the following placement opportunity.
 */
- (BOOL)shouldHandleOpportunity:(PTPlacementOpportunity *)opportunity;

/** @name configWithPlayerItem */
/**
 * Invoked by the PSDK every time the content resolver needs to be initialized due to a item or delegate change.
 */
- (void)configWithPlayerItem:(PTMediaPlayerItem *)item delegate:(id<PTContentResolverDelegate>) delegate;

/** @name process */
/**
 * Invoked everytime that the player requires the content resolver to process a set of placement opportunities. Only if the content resolver returned YES to handle a timed metadata in shouldHandleOpportunity. The content resolver MUST call the PTContentResolverDelegate methods to its delegate accordingly (didStartResolvingContentWithOpportunities, didFinishResolvingContentWithOpportunities)
 */
- (void)process:(NSArray *)opportunities;

@optional

/** @name timeout */
/**
 * Invoked if the PSDK decides that the PTContentResolver is taking too much time to answer back for this timed metadata.
 */
- (void)cancel:(NSArray *)opportunities;

@end

/**
 * PTContentResolver class should be used to extend the functionality of a basic content resolver. Custom content resolver should override the following methods:
 * - (BOOL)shouldHandleOpportunity:(PTPlacementOpportunity *)opportunity;
 * - (void)process:(NSArray *)opportunities;
 */

@interface PTContentResolver : NSObject <PTContentResolver>

@property (readonly) id<PTContentResolverDelegate> delegate;
@property (readonly) PTMediaPlayerItem *playerItem;

/** @name shouldHandleOpportunity */
/**
 * Content resolver returns YES/NO if it should handle the following placement opportunity.
 */
- (BOOL)shouldHandleOpportunity:(PTPlacementOpportunity *)opportunity;

/** @name configWithPlayerItem */
/**
 * Invoked by the PSDK every time the content resolver needs to be initialized due to a item or delegate change.
 */
- (void)configWithPlayerItem:(PTMediaPlayerItem *)item delegate:(id<PTContentResolverDelegate>) delegate;

/** @name process */
/**
 * Invoked everytime that the player requires the content resolver to process a set of placement opportunities. Only if the content resolver returned YES to handle a timed metadata in shouldHandleOpportunity. The content resolver MUST call the PTContentResolverDelegate methods to its delegate accordingly (didStartResolvingContentWithOpportunities, didFinishResolvingContentWithOpportunities)
 */
- (void)process:(NSArray *)opportunities;


/** @name timeout */
/**
 * Invoked if the PSDK decides that the PTContentResolver is taking too much time to answer back for this timed metadata.
 */
- (void)cancel:(NSArray *)opportunities;

@end


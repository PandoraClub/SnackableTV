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
//  PTOpportunityResolver.h
//  MediaPlayer
//
//  Created by - on 1/23/14.
//

#import <Foundation/Foundation.h>

/**
 * PTOpportunityResolverDelegate protocol describes the methods that the custom opportunity resolver (PTOpportunityResolver) should use to communicate the delegate the status of the resolving of the opportunity.
 */

@class PTPlacementOpportunity;
@class PTMediaPlayerItem; 
@class PTMediaError;
@class PTTimedMetadata;

@protocol PTOpportunityResolverDelegate <NSObject>
@required
- (void)didStartProcessingOpportunityWithTimedMetadata:(PTTimedMetadata *)timedMetadata;
- (void)didFinishProcessingTimedMetadata:(PTTimedMetadata *)metadata withOpportunity:(PTPlacementOpportunity *)opportunity;
- (void)didFailResolvingTimedMetadata:(PTTimedMetadata *)metadata withError:(PTMediaError *)error;
@end

/**
 * PTOpportunityResolver protocol describes the methods that are required for a customized opportunity resolver.
 */

@protocol PTOpportunityResolver <NSObject>

@required

/** @name shouldHandleOpportunity */
/**
 * Opportunity resolver returns YES/NO if it should handle the following metadata.
 */
- (BOOL)shouldHandleOpportunity:(PTTimedMetadata *)timedMetadata;

/** @name configWithPlayerItem */
/**
 * Invoked by the PSDK every time the resolver needs to be initialized due to a item or delegate change.
 */
- (void)configWithPlayerItem:(PTMediaPlayerItem *)item delegate:(id<PTOpportunityResolverDelegate>) delegate;

/** @name process */
/**
 * Invoked everytime that the player requires the opportunity resolver to process an oportunity. Only if the opportunity resolver returned YES to handle a timed metadata in
 * shouldHandleOpportunity.
 */
- (void)process:(PTTimedMetadata *)timedMetadata;

/** @name cleanup */
/* Invoked by the PSDK every time the resolver needs to be initialized due to a item or delegate change.
 */
- (void)cleanup;

@optional

/** @name timeout */
/**
 * Invoked if the PSDK decides that the PTOpportunityResolver is taking too much time to answer back for this timed metadata.
 */
- (void)timeout:(PTTimedMetadata *)timedMetadata;

@end

/**
 * PTOpportunityResolver protocol describes the methods that are required for a customized opportunity resolver.
 */

/**
 * PTOpportunityResolver class should be used to extend the functionality of a basic opportunity resolver. Custom opportunity resolver should override the following methods:
 * - (BOOL)shouldHandleOpportunity:(PTTimedMetadata *)timedMetadata
 * - (void)process:(PTTimedMetadata *)timedMetadata
 */

@interface PTOpportunityResolver : NSObject <PTOpportunityResolver>

@property (readonly) id<PTOpportunityResolverDelegate> delegate;
@property (readonly) PTMediaPlayerItem *playerItem;

/** @name shouldHandleOpportunity */
/**
 * Opportunity Resolver returns YES/NO if it should handle the following metadata.
 */
- (BOOL)shouldHandleOpportunity:(PTTimedMetadata *)timedMetadata;

/** @name configWithPlayerItem */
/**
 * Invoked by the PSDK every time the resolver needs to be initialized due to a item or delegate change.
 */
- (void)configWithPlayerItem:(PTMediaPlayerItem *)item delegate:(id<PTOpportunityResolverDelegate>) delegate;

/** @name process */
/**
 * Invoked everytime that the player requires the opportunity resolver to process an oportunity. Only if the opportunity resolver returned YES to handle a timed metadata in
 * shouldHandleOpportunity.
 */
- (void)process:(PTTimedMetadata *)timedMetadata;

/** @name cleanup */
/* Invoked by the PSDK every time the resolver needs to be initialized due to a item or delegate change.
 */
- (void)cleanup;


/** @name timeout */
/**
 * Invoked if the PSDK decides that the PTOpportunityResolver is taking too much time to answer back for this timed metadata.
 */
- (void)timeout:(PTTimedMetadata *)timedMetadata;

@end


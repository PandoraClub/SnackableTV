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
//  AdCuePoint.h
//  AuditudeHLSAdLib
//
//  Created by Andrei Ionescu on 4/3/12.
//

#import <Foundation/Foundation.h>

@class PTPlacementOpportunity;
@class PTMetadata;

/**
 * PTAdAvailInfo describes an ad opportunity within the stream
 */
@interface PTAdAvailInfo : NSObject

/** @name Properties */
/**
 * Returns the id of the avail
 */
@property (nonatomic, retain) NSString *id;

/** @name Properties */
/**
 * Returns the duration of the avail in seconds
 */
@property (nonatomic) double duration;

/** @name Properties */
/**
 * Returns the timestamp associated with this instance
 */
@property (nonatomic) double time;

/** @name Properties */
/**
 * Returns any additional attributes associated with this instance
 */
@property (nonatomic, retain) NSMutableDictionary *attributes;

/** @name Properties */
/**
 * Returns any additional metadata associated with this instance
 */
@property (nonatomic, retain) PTMetadata *metadata;

/** @name Init */
/**
 * Returns true if the ad opportunity is supported by the SDK and false otherwise
 */
+ (BOOL)isAdAvailTag:(NSString *)availString;

/** @name Init */
/**
 * Initializes a new instance from a string containing the ad opportunity description
 */
- (id)initWithAvailString:(NSString *)availString;

/** @name Init */
/**
 * Initializes a new instance from a PTPlacementOpportunity containing the ad opportunity description
 */
- (id)initWithPlacementOpportunity:(PTPlacementOpportunity *)placementOpportunity;

/** Data */
/**
 * Returns a string representation of all the attributes and properties of the avail instance
 */
- (NSString *)getString;

@end
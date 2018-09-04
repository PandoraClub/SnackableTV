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
//  PTABRControlParameters.h
//  MediaPlayer
//
//  Created by Prerna Vij on 12/19/12.
//

#import <Foundation/Foundation.h>
#import "PTMetadata.h"

extern NSString *const PTABRResolvingMetadataKey;

/**
 * Encapsulates all ABR control parameters. Currently supported parameters are:
 *  - minimum bit-rate
 *  - maximum bit-rate
 *  - initial bit-rate
 */
@interface PTABRControlParameters : PTMetadata

/** @name Properties */
/**
 * Value of the initial bit-rate (expressed in bps). The profile
 * with the closest (equal or less) bit-rate value is selected for preload.
 */
@property (assign, nonatomic) int initialBitRate;

/** @name Properties */
/**
 * Value of the minimum bit-rate (expressed in bps). All profiles with
 * a bit-rate lower than this value are ignored.
 */
@property (assign, nonatomic) int minBitRate;

/** @name Properties */
/**
 * Value of the maximum bit-rate (expressed in bps). All profiles with
 * a bit-rate greater than this value are ignored.
 */
@property (assign, nonatomic) int maxBitRate;

/** @name Initialization */
/**
 * Initializes a new instance with the specified initial, minimum and maximum bitrate settings
 */
- (id)initWithABRControlParameters:(int)initialBitRate minBitRate:(int)minBitRate maxBitRate:(int)maxBitRate;

@end

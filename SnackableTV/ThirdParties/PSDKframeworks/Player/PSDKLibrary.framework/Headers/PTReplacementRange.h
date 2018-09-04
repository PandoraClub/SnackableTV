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
//  PTReplacementRange.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 07/24/14.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 * PTReplacementRange represents a time range with a different replacement time duration.
 */
@interface PTReplacementRange : NSObject

/** @name Properties */
/**
 * The replacement range
 */
@property (nonatomic, assign) CMTimeRange range;

/** @name Properties */
/**
 * The replacement duration
 */
@property (nonatomic, assign) CMTime replacementDuration;


/** @name Initialization */
/**
 * Initializes a new instance.
 */
- (id)init;

/** @name Initialization */
/**
 * Initializes a new instance with the specified range.
 */
- (id)initWithRange:(CMTimeRange)range;

/** @name Initialization */
/**
 * Initializes a new instance with the specified range and replacement duration.
 */
- (id)initWithRange:(CMTimeRange)range replacementDuration:(CMTime)duration;

/**
 * Returns an autoreleased instance of PTReplacementRange
 */
+ (id)replacementRangeWithRange:(CMTimeRange)range;

/**
 * Returns an autoreleased instance of PTReplacementRange
 */
+ (id)replacementRangeWithRange:(CMTimeRange)range replacementDuration:(CMTime)duration;


@end

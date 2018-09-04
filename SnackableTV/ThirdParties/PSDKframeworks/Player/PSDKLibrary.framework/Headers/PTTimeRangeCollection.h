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
//  PTTimeRangeCollection.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 07/24/14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PTTimeRangeCollectionType)
{
    PTTimeRangeCollectionTypeMarkRanges = 0,
    PTTimeRangeCollectionTypeDeleteRanges,
    PTTimeRangeCollectionTypeReplaceRanges
};

/*
 * PTTimeRangeCollection serves as means to pass on to the PSDK a set of timerange specifications. The behavior of these custom ranges are defined by the type of the PTTimeRangeCollection 
 * (PTTimeRangeCollectionType).
 */
@interface PTTimeRangeCollection : NSObject

/** @name Properties */
/**
 * Defines the type of the PTTimeRangeCollection:
 *   PTTimeRangeCollectionTypeMarkRanges: Used to mark specific sections of the main content as ad-related content periods.
 *   PTTimeRangeCollectionTypeDeleteRanges: Used to delete specific sections of a VOD content.
 *   PTTimeRangeCollectionTypeReplaceRanges: Used to replace specific sections of a VOD content with alternate content (Ads, etc.). Only compatible with custom ranges ad signaling mode.
 */
@property (nonatomic, assign) PTTimeRangeCollectionType type;

/** @name Properties */
/**
 * Custom set of time ranges.
 * The NSArray is of type CMTimeRange or PTReplacementTimeRange objects. All the objects on the NSArray have to be instances of the same class.
 */
@property (nonatomic, retain) NSArray/*<CMTimeRange(NSValue)/PTReplacementTimeRange>*/ *ranges;


/** @name Initialization */
/**
 * Initializes a new instance.
 */
- (id)init;

/** @name Initialization */
/**
 * Initializes a new instance with the specified type and ranges≥.
 */
- (id)initWithRanges:(NSArray *)ranges type:(PTTimeRangeCollectionType)type;

@end

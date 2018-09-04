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
//  PTAdAsset.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 1/21/13.
//

#import <Foundation/Foundation.h>
#import "PTAdClick.h"

@class PTAd;

/**
 * The PTAdAsset instance represents an asset to be displayed.
 */
@interface PTAdAsset : NSObject

/** @name Properties */
/**
 * Returns the PTAd instance that this asset belongs to
 */
@property (nonatomic, assign) PTAd *ad;

/** @name Properties */
/**
 * Returns the id of the asset.
 */
@property (nonatomic, retain) NSString *id;

/** @name Properties */
/**
 * Returns the format of the asset.
 */
@property (nonatomic, retain) NSString *format;

/** @name Properties */
/**
 * Returns the source of the asset.
 */
@property (nonatomic, retain) NSString *source;

/** @name Properties */
/**
 * Returns the resourceType of the asset (static, iframe or html).
 */
@property (nonatomic, retain) NSString *resourceType;

/** @name Properties */
/**
 * Returns the mimeType of the asset.
 */
@property (nonatomic, retain) NSString *creativeType;

/** @name Properties */
/**
 * Returns an array of media files (creative formats) for this asset
 */
@property (nonatomic, retain) NSMutableArray *mediaFiles;

/** @name Properties */
/**
 * Returns the click instance associated with this asset
 */
@property (nonatomic, retain) PTAdClick *click;

/** @name Properties */
/**
 * Returns the behavior data of the asset.
 */
@property (nonatomic, retain) NSDictionary *behaviorData;

/** @name Properties */
/**
 * Returns the width of the asset.
 */
@property (nonatomic) int width;

/** @name Properties */
/**
 * Returns the height of the asset.
 */
@property (nonatomic) int height;

/** @name Properties */
/**
 * Returns the duration of the asset.
 */
@property (nonatomic) double duration;

/** @name Properties */
/**
 * Returns the data of the asset.
 */
@property (retain, nonatomic) NSDictionary *data;

/** @name Properties */
/**
 * Returns the ad parameters string (from VAST) for the asset.
 */
@property (retain, nonatomic) NSString *adParameters;

@end

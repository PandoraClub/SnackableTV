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
//  PTDRMMetadataInfo.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 5/2/13.

#import <Foundation/Foundation.h>
#import "PTMediaPlayerItem.h"

@class DRMMetadata;

/**
 * Key used for extracting the PTDRMMetadataInfo from notifications user info.
 */
extern NSString *const PTDRMMetadataKey;

/**
 * PTDRMMetadataInfo class represents a specific drm metadata instance.
 */
@interface PTDRMMetadataInfo : NSObject

/**
 * Associated DRMMetadata object.
 * This property is not observable.
 */
@property (readonly, nonatomic) DRMMetadata *drmMetadata;

@end

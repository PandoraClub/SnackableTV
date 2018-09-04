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
//  PTMediaProfile.h
//  MediaPlayer
//
//  Created by Prerna Vij on 1/16/13.
//

#import <Foundation/Foundation.h>

/**
 * PTMediaProfile class represents the profile of a single stream
 * in the variant playlist. 
 */
@interface PTMediaProfile : NSObject

/** @name Properties */
/**
 * Absolute url for the stream.
 */
@property (readonly, retain) NSString *url;

/** @name Properties */
/**
 * Stream codecs, as provided in the master variant.
 */
@property (readonly, retain) NSString *codecs;

/** @name Properties */
/**
 * Stream bandwidth value.
 */
@property (readonly, assign) long bandwidth;

/** @name Properties */
/**
 * Other stream related information, in key value format.
 */
@property (readonly, retain) NSDictionary *attributes;

@end

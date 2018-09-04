//
//  PTTimedMetadata.h
//  PSDKLibrary
//
//  Created by Prerna Vij on 4/30/13.
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

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>
#import "PTMetadata.h"

/**
 * Name of the key used to retrieve the latest TimedMetadata object from
 * PTTimedMetadataChangedNotification userinfo dictionary.
 */
extern NSString *const PTTimedMetadataKey;

/**
 * The name of the key used to retrieve the entire data string
 * with the tag when data is not in key value attributes format.
 */
extern NSString *const PTDataKey;

/**
 * The name of the key used to retrieve the last seen #EXT-X-PROGRAM-DATE-TIME tag as a PTTimedMetadata instance.
 * Set currently only for live/linear streams.
 */
extern NSString *const PTProgramDateTimeMetadataKey;

/**
 * PTTimedMetadata class represents a custom HLS tag in the stream.
 */
@interface PTTimedMetadata : PTMetadata

/**
 * Lists the enumeration types for Timed Metadata
 */
typedef NS_ENUM(NSInteger,PTTimedMetadataType)
{
	/** Timed Metadata of type TAG. */
	PTTimedMetadataTypeTAG = 0,
	
	/** Timed Metadata of type ID3. */
    PTTimedMetadataTypeID3
};

/**
 * Type of PTTimedMetadata. Possible values are TAG, ID3.
 * Types: TAG(Default), ID3
 */
@property (nonatomic, assign) PTTimedMetadataType type;

/**
 * The local time (relative to the start of the main content) at which the 
 * associated segment of current tag will begin play.
 */
@property (nonatomic, assign) CMTime time;

/**
 * A unique identifier for a PTTimedMetadata tag. 
 * The value is extracted from the tag attributes, if an "id" attribute exists.
 * Else, the value is a unique random string.
 */
@property (nonatomic, retain) NSString *metadataId;

/**
 * Name of the tag itself.
 * For example: #EXT-OATCLS-SCTE35, #EXT-CUSTOM-TAG
 */
@property (nonatomic, retain) NSString *name;

/**
 * Raw string value of the tag.
 * For example: for #EXT-OATCLS-SCTE35:ababab, content is the string value 
 * "ababab"
 */
@property (nonatomic, retain) NSString *content;
@end

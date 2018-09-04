/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
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
//  PTNetworkConfiguration.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 03/12/15.
//

#import <Foundation/Foundation.h>
#import "PTMetadata.h"

/**
 * The name of the key associated with this metadata type.
 * Used to retrieve the PTMetadata instance from a metadata collection.
 */
extern NSString *const PTNetworkConfigurationMetadataKey;

/*
 * Constant to generate a unique timestamp value for a Custom HTTP header.
 */
extern NSString *const PTNetworkConfigurationCustomHeaderTimestamp;

/*
 * Constant to supply options while creating an AVURLAsset instance. Refer to initWithURL method on AVURLAsset class.
 */
extern NSString *const PTNetworkConfigurationAVAssetOptions;

/**
 * PTNetworkConfiguration class provides methods that should be configured for custom network configurations.
 */
@interface PTNetworkConfiguration : PTMetadata

/**
 * Adds a custom header to be used on all requests. 
 * Limitation: This custom header will only be used on m3u8 files requests.
 *
 * @param headerName The value for the header name. headerName must be on a predetermined whitelist.
 * @param headerArgs Array of NSString containing the header args. Must match expected arguments for that specific header.
 * (Use PTNetworkConfigurationCustomHeaderTimestamp for a unique timestamp).
 */
- (void)addCustomHeader:(NSString *)headerName args:(NSArray *)headerArgs;

/**
 * Returns a dictionary with all the custom headers.
 */
- (NSDictionary *)getCustomHeaders;

/**
 * Adds a url parameter to every content segment request with the given key and value
  */
- (void)appendSegmentUrlParameterWithKey:(NSString *)key value:(NSString *)value;

/**
 * Adds a url parameter to every content segment request with the given key and the value
 * of the cookie from the manifest request matching the given name
 */
- (void)appendSegmentUrlParameterWithKey:(NSString *)key valueFromCookieWithName:(NSString *)name;

@end

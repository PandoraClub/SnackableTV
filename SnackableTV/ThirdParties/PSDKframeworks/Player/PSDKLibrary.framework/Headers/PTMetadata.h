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
//  PTMetadata.h
//
//  Created by Catalin Dobre on 3/25/12.
//

#import <Foundation/Foundation.h>


/**
 * Set this key on the metadata for streams providing cookies on the master manifest response that
 * need to be included with the segment and key requests (on same domain).
 * Works on iOS 8.0+ only due to platform API limitation.
 * An additional request is made to the master manifest to read the response cookies.
 *
 * Usage:
 *         PTMetadata *metadata = [[[PTMetadata alloc] init] autorelease]; // Non-ARC
 *         [metadata setValue:[NSNumber numberWithBool:YES] forKey:kSyncCookiesWithAVAsset];
 */
extern NSString * const kSyncCookiesWithAVAsset;

/**
 * PTMetadata is the base class for configuring all available metadata for the Player. Individual components
 * extend this class to provide additional accessors for key-value metadata.
 */
@interface PTMetadata : NSObject

/**
 * Sets the specified value for the key.
 *
 * @param value The valyefor the key. Any existing value for the key is replaced by the new value
 * @param key The name of the key to be set.
 */
- (void)setValue:(id)value forKey:(NSString *)key;

/**
 * Returns the value of the specified key.
 *
 * The key must be a non empty value.
 *
 * @param key The name of the key whose value  is to be returned.
 * @return The value for the specified key or nil if there is no corresponding value for the key
 */
- (id)valueForKey:(NSString *)key;

/**
 * Returns all the keys as an NSArray instance (includes metadata keys and value keys)
 *
 * @return A new array containing the keys, or an empty array if this instance has no entries.
 */
- (NSArray *)allKeys;

/**
 * Returns the value of the specified metadata key.
 *
 * The key must be non empty value.
 *
 * @param key The name of the metadata key whose value  is to be returned.
 * @return The PTMetadata instance for the specified key or nil if there is no corresponding value for the key
 */
- (PTMetadata *)metadataForKey:(NSString *)key;

/**
 * Sets the specified metadata for the key.
 *
 * @param metadata The PTMetadata instance for the key. Any existing value for the key is replaced by the new value
 * @param key The name of the metadata key to be set.
 */
- (void)setMetadata:(PTMetadata *)metadata forKey:(NSString *)key;

@end

//
//  PTBlackoutMetadata.h
//  PSDKLibrary
//
//  Created by Prerna Vij on 8/5/14.
//  Copyright (c) 2014 Adobe Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTMetadata.h"

/**
 * The name of the key associated with this metadata type.
 * Used to retrieve the PTBlackoutMetadata instance from a metadata collection.
 */
extern NSString *const PTBlackoutMetadataKey;


@interface PTBlackoutMetadata : PTMetadata

/**
 * Initialize PTBlackoutMetadata with nonSeekableRanges.
 *
 */
- (id)initWithNonSeekableRanges:(NSArray *)nonSeekableRanges;

/**
 * Collection of CMTimeRanges that PSDK doesn't 
 * allow to seek into.
 *
 */
@property (nonatomic, retain) NSArray *nonSeekableRanges;


@end

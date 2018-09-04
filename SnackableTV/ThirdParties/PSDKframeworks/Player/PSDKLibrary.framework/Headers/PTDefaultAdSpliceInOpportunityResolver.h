/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2016 Adobe Systems Incorporated
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
//  PTDefaultAdSpliceInOpportunityResolver.h
//
//  Created by Venkat Jonnadula on 3/26/16.
//  Copyright © 2016 Adobe Systems Inc. All rights reserved.
//

#import "PTOpportunityResolver.h"

/*
 * PTDefaultAdSpliceInOpportunityResolver class provides default behavior for supporting early return from an ad break.
 */
@interface PTDefaultAdSpliceInOpportunityResolver : PTOpportunityResolver

/** @name Create */
/**
 * Class method that returns an instance of PTDefaultAdSpliceInOpportunityResolver with a tag that indicates
 * Primetime TVSDK to exit from an ad break early. That tag must not include the colons.
 *
 * Ex:
 * PTDefaultMediaPlayerClientFactory *clientFactory = self.player.mediaPlayerClientFactory;
 * [clientFactory registerOpportunityResolver:[PTDefaultAdSpliceInOpportunityResolver adSpliceInOpportunityResolverWithTag:@"EXT-X-CUE-IN"]];
 */
+ (PTDefaultAdSpliceInOpportunityResolver *)adSpliceInOpportunityResolverWithTag:(NSString *)tag;

@end

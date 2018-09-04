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
//  PTDefaultAdOpportunityResolver.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 3/3/14.
//

#import "PTOpportunityResolver.h"

/*
 * PTDefaultAdOpportunityResolver class provides default opportunity resolver supported through Primetime Player SDK.
 * Applications can extend this class to override the default behavior.
 */
@interface PTDefaultAdOpportunityResolver : PTOpportunityResolver

/** @name preparePlacementOpportunity */
/**
 * Override this method to customize the default Placement opportunity. 
 * This method is used by the default placement opportunity resolver to get the placement opportunity before
 * sending the opportunity back to the delegate.
 */
- (PTPlacementOpportunity *)preparePlacementOpportunity:(PTTimedMetadata *)timedMetadata;

@end


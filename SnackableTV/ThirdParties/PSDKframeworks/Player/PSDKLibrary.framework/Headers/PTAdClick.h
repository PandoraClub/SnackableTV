//
//  PTAdClick.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 1/21/13.
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

#import <Foundation/Foundation.h>

/**
 * The PTAdClick class represents a click instance associated with an asset. This instance contains information
 * about the click-through url and the title that can used to provide additional information to the user.
 */
@interface PTAdClick : NSObject

/** @name Properties */
/**
 * Returns the id for this instance
 */
@property (nonatomic, retain) NSString *clickId;

/** @name Properties */
/**
 * Returns the click-through url to be opened when the user taps on the asset
 */
@property (nonatomic, retain) NSString *source;

/** @name Properties */
/**
 * Returns the title to be displayed to the user
 */
@property (nonatomic, retain) NSString *title;

@end

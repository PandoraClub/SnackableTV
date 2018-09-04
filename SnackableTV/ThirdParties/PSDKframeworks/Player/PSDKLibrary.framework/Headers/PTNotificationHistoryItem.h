//
//  PTNotificationHistoryItem.h
//
//  Created by Jesus Figueroa on 2/20/13.
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

#import <Foundation/Foundation.h>
#import "PTNotification.h"

/**
 * PTNotificationHistoryItem class.
 *
 * Defines an entry in the list of PTNotificationHistory and holds the notification together with its timestamp
 */

@interface PTNotificationHistoryItem : NSObject

/** @name Properties */
/**
 * Instance of the notification. The data of the PTNotificationHistoryItem.
 */
@property (nonatomic, readonly) PTNotification *notification;

/** @name Properties */
/**
 * Unique index value that is automatically incremented as events are being added to the PTNotificationHistory.
 * This value is useful for logging.
 */
@property (nonatomic, readonly) long long eventIndex;

/** @name Properties */
/**
 * A millisecond accurate time stamp value representing the system time associated to the instant when the entry is added to the PTNotificationHistory.
 */
@property (nonatomic, readonly) long long timeStamp;

@end
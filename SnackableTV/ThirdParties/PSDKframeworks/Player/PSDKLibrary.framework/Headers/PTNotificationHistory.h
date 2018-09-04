//
//  PTNotificationHistory.h
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
 * PTNotificationHistory class.
 *
 * The functionality of the PTNotificationHistory class it to provide access to a notifications events history list.
 * Each notification of the PTNotificationHistory class is represented by an instance of PTNotification.
 */

@interface PTNotificationHistory : NSObject

/**
 * Inserts the notification to the PTNotificationHistory.
 * If PTNotificationHistory current size is greater than its current capacity older notifications will be removed from the list.
 */
- (void) addNotification:(PTNotification *)notification;

/**
 * Clears the content of the PTNotificationHistory
 */
- (void) clearNotificationList;

/** @name Properties */
/**
 * NSArray of PTNotificationHistoryItem elements.
 * Method to retrive the notifications history.
 * This property IS NOT observable.
 */
@property (nonatomic, readonly) NSArray *notificationItems;

/** @name Properties */
/**
 * Returns the actual number of notifications in the PTNotificationHistory
 */
@property (nonatomic, readonly) NSInteger size;

/** @name Properties */
/**
 * Used for set/retrieve the current capacity of notifications.
 * If a capacity greater than its current size is set, the oldest notifications will be deleted in order to accomodate to the new capacity.
 * Default capacity is 1000.
 */
@property (nonatomic, assign) NSInteger capacity;

@end
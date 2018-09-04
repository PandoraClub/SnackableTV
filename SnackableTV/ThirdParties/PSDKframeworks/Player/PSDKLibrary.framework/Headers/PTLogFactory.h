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
//  PTLogFactory.h
//
//  Created by Jesus Figueroa on 4/19/13.
//

#import <Foundation/Foundation.h>
#import "PTLogEntry.h"

/**
 * PTLogger protocol.
 *
 * Protocol describing the methods required to implement a custom logger for PSDK.
 */
@protocol PTLogger <NSObject>
@required
- (void) logEntry:(PTLogEntry *)message;
@end


/**
 * PTLogFactory class.
 *
 * The functionality of the PTLogFactory class it to provide access to log messages provided by the PSDK.
 * Each log message of registered by the PTLogFactory class is represented by an instance of PTLogEntry.
 */
@interface PTLogFactory : NSObject

+ (PTLogFactory *)sharedInstance;

/**
 * Returns YES if there is at least 1 Logger registered for logs.
 */
+ (BOOL)isEnabled;

/**
 * Inserts the PTLogger to the registered loggers.
 */
- (void)addLogger:(id<PTLogger>)logger;

/**
 * Removes the PTLogger from the registered loggers.
 */
- (void)removeLogger:(id<PTLogger>)logger;

/**
 * Inserts the notification to the PTNotificationHistory.
 * If PTNotificationHistory current size is greater than its current capacity older notifications will be removed from the list.
 */
- (void)removeAllLoggers;

/**
 * Sends the logMessage to all the loggers added to the PTLogFactory
 */
- (void)logMessage:(PTLogEntry *)message;

@end

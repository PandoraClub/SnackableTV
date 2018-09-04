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
//  PTLogEntry.h
//
//  Created by Jesus Figueroa on 4/19/13.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark Enumeration values

/**
 * These enumeration values define the type of a log entry instance.
 */
typedef NS_ENUM(NSInteger, PTLogEntryType)
{
	/** A log entry of info type */
    PTLogEntryTypeInfo = 0,
	
	/** A log entry of debug type */
    PTLogEntryTypeDebug,
	
	/** A log entry of event type */
    PTLogEntryTypeEvent,
	
	/** A log entry of warning type */
    PTLogEntryTypeWarning,
	
	/** A log entry of error type */
    PTLogEntryTypeError,
};

extern float const kPTLOG_PROGRESS_START;
extern float const kPTLOG_PROGRESS_END;

#pragma mark -
#pragma mark PTLogEntry

/**
 * PTLogEntry class represents an instance of a log message.
 */

@interface PTLogEntry : NSObject

/**
 * Simple tag for the log entry. This tag can be used for filtering purposes
 * and/or to detect progress of a log.
 */
@property (nonatomic, readonly) NSString *tag;

/**
 * Filters. This is an array of strings (filters) that can be used for filtering purposes.
 */
@property (nonatomic, readonly) NSArray *filters;

/**
 * long long
 * A millisecond accurate time stamp value representing the system time associated to the instant when the entry is added to the PTNotificationHistory.
 */
@property (nonatomic, readonly) NSDate *timeStamp;

/**
 * Log message
 */
@property (nonatomic, readonly) NSString *message;

/**
 * Type of the message.
 * Types: PTLogEntryTypeInfo, PTLogEntryTypeDebug, PTLogEntryTypeEvent, PTLogEntryTypeWarning
 *        PTLogEntryTypeError.
 */
@property (nonatomic, readonly) PTLogEntryType type;

/**
 * A float value from [0.0 - 1.0] indicating the progress of a log message
 * of type event (You can log the beggining, progress and end of an event of the same messageId).
 */
@property (nonatomic, readonly) float progress;


/** @name Creating message log*/
/**
 * Creates a new PTLogEntry instance with specified properties.
 *
 * @param tag 
 * @param message The log message
 * @param type The type of the log message
 * @param progress The progress of the event
 */
- (id) initLogWithTag:(NSString *)tag
              message:(NSString *)message
                 type:(PTLogEntryType)type
             progress:(float)progress;

/** @name Creating message log*/
/**
 * Creates a new PTLogEntry instance with specified properties.
 *
 * @param tag 
 * @param filters 
 * @param message The log message
 * @param type The type of the log message
 * @param progress The progress of the event
 */
- (id) initLogWithTag:(NSString *)tag
              filters:(NSArray *)filters
              message:(NSString *)message
                 type:(PTLogEntryType)type
             progress:(float)progress;


@end

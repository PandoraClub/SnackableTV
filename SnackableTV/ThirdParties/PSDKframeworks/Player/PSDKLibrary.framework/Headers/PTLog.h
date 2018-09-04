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
//  PTLog.h
//
//  Created by Jesus Figueroa on 4/19/13.
//

#import <Foundation/Foundation.h>
#import "PTLogEntry.h"
#import "PTLogFactory.h"

/**
 * PTLog : Log macros
 * Use the macros defined in PTLog.h for convinient usage of logging.
 *
 * NOTE: The string provided in the following helper functions is parsed
 * in the following formats:
 *     "message"
 *     "[tag] message"
 *     "[tag,filter_1,filter_2,...,filter_n] message"
 *
 * The file name is automatically used as tag for all the logs.
 * The log tag and the file name is automatically added to the filters of the log entry.
 * 
 * Examples of usage:
 * PTLogInfo(@"info message");
 * 
 * 
 */

#define PTLogInfo(s,...)                [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeInfo progress:kPTLOG_PROGRESS_END file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#define PTLogDebug(s,...)                [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeDebug progress:kPTLOG_PROGRESS_END file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#define PTLogEventStart(s,...)          [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeEvent progress:kPTLOG_PROGRESS_START file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#define PTLogEventProgress(p,s,...)     [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeEvent progress:(p) file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#define PTLogEventEnd(s,...)            [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeEvent progress:kPTLOG_PROGRESS_END file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#define PTLogWarning(s,...)             [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeWarning progress:kPTLOG_PROGRESS_END file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#define PTLogError(s,...)               [[PTLogFactory sharedInstance] logMessageWithType:PTLogEntryTypeError progress:kPTLOG_PROGRESS_END file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]


/**
 * PTLog : Add/Remove Loggers
 * Use the following macros for convinient usage of adding and removing loggers
 */

#define PTLogAddLogger(logger)          [[PTLogFactory sharedInstance] addLogger:(logger)]

#define PTLogRemoveLogger(logger)       [[PTLogFactory sharedInstance] removeLogger:(logger)]


@interface PTLogFactory ()

/**
 * Helper functions to create and send a log message of different types.
 * (Use macros defined in PTLog.h for easier use).
 */
- (void)logMessageWithType:(PTLogEntryType)type progress:(float)progress file:(char *)sourceFile lineNumber:(int)lineNumber format:(NSString*)format, ...;

@end

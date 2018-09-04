//
//  PTNotification.h
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

@class PTNotification;
@class AVPlayerItemErrorLogEvent;

/**
 * These enumeration values define the type of a PTNotification instance.
 */
typedef NS_ENUM(NSInteger, PTNotificationType)
{
    /** An information PTNotification. */
    PTNotificationTypeInfo,
    
    /** A warning PTNotification. */
    PTNotificationTypeWarning,
    
    /** An error PTNotification. Puts the player in error state. */
    PTNotificationTypeError,
    
    /** An undefined PTNotification. */
    PTNotificationTypeUndefined
};

/**
 * PTNotification metadata constants.
 *
 * Some notifications might contain extra information in the metadata property.
 * Constant keys for metadata.
 */

extern NSString * const NOTIFICATION_METADATA_DESCRIPTION;
extern NSString * const NOTIFICATION_METADATA_URL;
extern NSString * const NOTIFICATION_METADATA_CONTENT;
extern NSString * const NOTIFICATION_METADATA_INTERNAL_ERROR;
extern NSString * const NOTIFICATION_METADATA_MAJOR_DRM_CODE;
extern NSString * const NOTIFICATION_METADATA_MINOR_DRM_CODE;
extern NSString * const NOTIFICATION_CURRENT_MEDIA_TIME;
extern NSString * const NOTIFICATION_BITRATE;
extern NSString * const NOTIFICATION_METADATA_AD_BREAK;
extern NSString * const NOTIFICATION_METADATA_AD;
extern NSString * const NOTIFICATION_METADATA_AD_ID;
extern NSString * const NOTIFICATION_METADATA_AD_PROGRESS;

/**
 * PTNotification class.
 *
 * PTNotificationHistory mantains a list of elements, each element containing a separate insstance of PTNotificationclass.
 * This class encapsulates the object represantation of a single notification event.
 */
@interface PTNotification : NSObject

/** @name Creating a PTNotification */
/**
 * Convenience method to create a PTNotification instance with a type, code and description
 * PTNotificationType Types: PTNotificationTypeInfo, PTNotificationTypeWarning, PTNotificationTypeError,PTNotificationTypeUndefined;
 */
+ (PTNotification *) notificationWithType:(PTNotificationType)type
                                     code:(NSInteger)code
                              description:(NSString *)description;

/** @name Creating a PTNotification */
/**
 * Convenience method to create a PTNotification instance with a type, code, description, metadata and inner notification.
 * PTNotificationType Types: PTNotificationTypeInfo, PTNotificationTypeWarning, PTNotificationTypeError,PTNotificationTypeUndefined;
 */
+ (PTNotification *) notificationWithType:(PTNotificationType)type
                                     code:(NSInteger)code
                              description:(NSString *)description
                                 metadata:(NSMutableDictionary *)metadata
                        innerNotification:(PTNotification *)notification;

/** @name Creating a PTNotification */
/**
 * Convenience method to create a PTNotification from a AVPlayerItemErrorLogEvent.
 */
+ (PTNotification *) notificationWithAVPlayerItemErrorLogEvent:(AVPlayerItemErrorLogEvent *)error;

/** @name Creating a PTNotification */
/**
 * Convenience method to create a PTNotification from a NSError.
 */
+ (PTNotification *) notificationWithNSError:(NSError *)error;

/** 
 * Creating a notification
 * Initializes the notification with the specified type, code and description.
 * PTNotificationType Types: PTNotificationTypeInfo, PTNotificationTypeWarning, PTNotificationTypeError,PTNotificationTypeUndefined;
 */
- (id) initWithType:(PTNotificationType)type
               code:(NSInteger)code
        description:(NSString *)description;


/**
 * Creating a notification
 * Initializes the notification with the specified type, code, description, metadata and inner notification.
 * PTNotificationType Types: PTNotificationTypeInfo, PTNotificationTypeWarning, PTNotificationTypeError,PTNotificationTypeUndefined;
 */
- (id) initWithType:(PTNotificationType)type
               code:(NSInteger)code
        description:(NSString *)description
           metadata:(NSMutableDictionary *)metadata
  innerNotification:(PTNotification *)notification;

/**
 * Adding metadata values
 * Convinience method to add metadata values to a notification
 */
- (void) setMetadataValue:(id)value forKey:(NSString *)key;

/**
 * Getting metadata values
 * Convinience method to get metadata values from a notification.
 */
- (id) metadataValueforKey:(NSString *)key;

/** @name Properties */
/**
 * PTNotificationType
 * Describes the notification event type.
 * Types: PTNotificationTypeInfo, PTNotificationTypeWarning, PTNotificationTypeError,PTNotificationTypeUndefined;
 */
@property (nonatomic, readonly) PTNotificationType type;

/** @name Properties */
/**
 * NSInteger
 * A code describing the notification generated by the PMP framework
 */
@property (nonatomic, readonly) NSInteger code;

/** @name Properties */
/**
 * NSString
 * A description of the error.  A free-form string containing a human-readable description of the notification event.
 */
@property (nonatomic, readonly, getter = notification_description) NSString *description;

/** @name Properties */
/**
 * NSMutableDictionary
 * A dictionary for arbitrary added info. Depending on the notification, useful information can be stored in the metadata such as: URL, run-time variable values, etc.
 */
@property (nonatomic, retain) NSMutableDictionary *metadata;

/** @name Properties */
/**
 * PTNotification
 * Instance of the notification. The semantics of this link is that of "event notification reason".
 * The notification that caused the current notification to be dispatched.
 */
@property (nonatomic, readonly) PTNotification *innerNotification;

@end

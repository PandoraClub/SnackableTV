/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
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

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>

#import "PTAd.h"

/**
 * These enumeration values define the type of a custom ad notification
 */
typedef NS_ENUM(NSInteger, PTCustomAdNotificationType)
{
	PTCustomAdNotificationTypeAdStarted,
	PTCustomAdNotificationTypeAdError,
	PTCustomAdNotificationTypeAdProgress,
	PTCustomAdNotificationTypeAdLoading,
	PTCustomAdNotificationTypeAdLoaded,
	PTCustomAdNotificationTypeAdStopped,
	PTCustomAdNotificationTypeAdPaused,
	PTCustomAdNotificationTypeAdPlaying,
	PTCustomAdNotificationTypeAdClick,
	PTCustomAdNotificationTypeAdSkippableStateChanged
};

/**
 * The key used to get the PTCustomAdNotificationObject instance from the notification.
 * Code:
 * PTCustomAdNotificationObject *notificationObject = [notification.userInfo objectForKey:PTCustomAdNotificationObjectKey];
 */
extern NSString *const PTCustomAdNotificationObjectKey;

/**
 * A PTCustomAdNotificationObject instance represents the data received from a PTMediaPlayerCustomAdNotification
 * notification dispatched by the media player instance
 */
@interface PTCustomAdNotificationObject : NSObject

/** @name Properties */
/**
 * The PTAd instance associated with the custom ad event
 */
@property (nonatomic, retain) PTAd *ad;

/** @name Properties */
/**
 * Additional data associated with the custom ad event
 */
@property (nonatomic, retain) NSDictionary *data;

/** @name Properties */
/**
 * PTCustomAdNotificationType enumeration for the custom ad event
 */
@property (nonatomic, readonly) PTCustomAdNotificationType type;

/** @name Properties */
/**
 * The current progress time for the custom ad
 */
@property (nonatomic, assign) CMTime time;

/** @name Properties */
/**
 * The total duration of the custom ad
 */
@property (nonatomic, assign) CMTime duration;

/** @name Properties */
/**
 * A boolean describing whether the application must handle the touch event on the custom ad
 */
@property (nonatomic, assign) BOOL playerHandlesAdClick;

/** @name Properties */
/**
 * The click url for the touch event on the custom ad
 */
@property (nonatomic, retain) NSString *clickUrl;

/** @name Properties */
/**
 * A helper function to create a PTCustomAdNotificationObject instance.
 */
+ (PTCustomAdNotificationObject *)notificationObjectWithType:(PTCustomAdNotificationType)type;

@end

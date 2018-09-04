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
//  PTMediaPlayerNotifications.h
//  MediaPlayer
//
//  Created by Venkat Jonnadula on 8/2/12.
//

#import <Foundation/Foundation.h>

/**
 * Posted when the PTMediaPlayer instance status changes.
 * Possible status values: PTMediaPlayerStatusCreated, PTMediaPlayerStatusInitializing, PTMediaPlayerStatusInitialized, PTMediaPlayerStatusReady,
 *                         PTMediaPlayerStatusPlaying, PTMediaPlayerStatusPaused, PTMediaPlayerStatusStopped, PTMediaPlayerStatusCompleted, PTMediaPlayerStatusError.
 * The notification’s object is the PTMediaPlayer instance whose status got updated.
 * The status value can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerStatusKey
 *
 */
extern NSString *const PTMediaPlayerStatusNotification;

/**
 * Posted when the PTMediaPlayer instance current playback time is updated.
 * The notification’s object is the PTMediaPlayer instance whose current time got updated.
 *
 */
extern NSString *const PTMediaPlayerTimeChangeNotification;

/**
 * Posted when the current PTMediaPlayerItem instance on the PTMediaPlayer instance is changed.
 * The notification’s object is the PTMediaPlayer instance whose PTMediaPlayerItem instance got changed.
 *
 */
extern NSString *const PTMediaPlayerItemChangedNotification;

/**
 * Posted when playback on the current PTMediaPlayer instance starts.
 * The notification’s object is the PTMediaPlayer instance on which the playback started.
 */
extern NSString *const PTMediaPlayerPlayStartedNotification;

/**
 * Posted when the playback on the current PTMediaPlayer instance completes.
 * The notification’s object is the PTMediaPlayer instance on which the playback completes.
 *
 */
extern NSString *const PTMediaPlayerPlayCompletedNotification;

/**
 * Posted when a new PTNotification instance is added to the PTNotificationHistory's notificationItems collection.
 * The notification’s object is the PTMediaPlayer instance with which the PTNotificationHistory is linked.
 * The newly added PTNotification instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerNotificationKey
 *
 */
extern NSString *const PTMediaPlayerNewNotificationEntryAddedNotification;

/**
 * Posted when the timeline of the current PTMediaPlayer instance gets changed.
 * The notification’s object is the PTMediaPlayer instance whose timeline got changed.
 * The PTTimeline instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerTimelineKey
 *
 */
extern NSString *const PTMediaPlayerTimelineChangedNotification;

/**
 * Posted when there are new subtitles and alternate audio tracks (PTMediaSelectionOption) available on the PTMediaPlayer instance.
 * The notification’s object is the PTMediaPlayer instance on which the PTMediaSelectionOption instances are now available.
 *
 * Note: This notification may be received multiple times upon stream start. The initial notification may have an
 * option array with no items but subsquent notifications will be updated with the list of all available media selection options.
 */
extern NSString *const PTMediaPlayerMediaSelectionOptionsAvailableNotification;

/**
 * Posted when the DRMMetadata gets updated.
 * The notification’s object is the PTMediaPlayer instance on which the DRMMetadata got updated.
 * The PTDRMMetadataInfo instance can be fetched from the notification's userInfo dictioanry using key: PTDRMMetadataKey
 *
 */
extern NSString *const PTMediaPlayerItemDRMMetadataChanged;

/**
 * Posted when a PTAdBreak starts.
 * The notification’s object is the PTMediaPlayer instance which started playing the adBreak.
 * The PTAdBreak instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerAdBreakKey
 *
 */
extern NSString *const PTMediaPlayerAdBreakStartedNotification;

/**
 * Posted when an PTAdBreak completes.
 * The notification’s object is the PTMediaPlayer instance which completed playing the adBreak.
 * The PTAdBreak instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerAdBreakKey
 *
 */
extern NSString *const PTMediaPlayerAdBreakCompletedNotification;

/**
 * Posted when a PTAd starts playing.
 * The notification’s object is the PTMediaPlayer instance which started playing the ad.
 * The PTAd instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerAdKey
 *
 */
extern NSString *const PTMediaPlayerAdStartedNotification;

/**
 * Posted as the PTAd progresses playing.
 * The notification’s object is the PTMediaPlayer instance which is playing the ad.
 * The PTAd instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerAdProgressKey
 *
 */
extern NSString *const PTMediaPlayerAdProgressNotification;

/**
 * Posted when the PTAd completes playing.
 * The notification’s object is the PTMediaPlayer instance which completed playing the ad.
 * The PTAd instance can be fetched from the notification's userInfo dictioanry using key: PTMediaPlayerAdKey
 *
 */
extern NSString *const PTMediaPlayerAdCompletedNotification;

/**
 * Posted when a banner ad is clicked.
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 * The notification's userInfo dictionary can be accessed for the following values with their respective keys:
 * - PTAd instance can be fetched using key PTMediaPlayerAdKey
 * - PTAdAsset can be fetched using key PTMediaPlayerAdAssetKey
 * - Click url can be fetched using key PTMediaPlayerAdClickURLKey
 *
 */
extern NSString *const PTMediaPlayerAdClickNotification;

/**
 * Posted when a new PTTimedMetadata instance for a subscribed tag is added to the collection of PTTimedMetada instances on currently playing PTMediaPlayerItem.
 * The notification’s object is the PTMediaPlayerItem instance which is currently playing.
 * The PTTimedMetadata instance can be fetched from the notification's userInfo dictionary using key: PTTimedMetadataKey
 *
 */
extern NSString *const PTTimedMetadataChangedNotification;

/**
 * Posted when a subscribed tag is identified on the background manifest and a new PTTimedMetadata instance is prepared
 * from it.
 * The notification’s object is the PTMediaPlayerItem instance which is currently playing.
 * The PTTimedMetadata instance can be fetched from the notification's userInfo dictionary using key: PTTimedMetadataKey
 *
 */
extern NSString *const PTTimedMetadataChangedInBackgroundNotification;

/**
 * Posted when the change on audio track of currently playing media is initiated.
 * The notification’s object is the PTMediaPlayerItem instance which is currently playing.
 *
 */
extern NSString *const PTAudioTrackChangeStarted;

/**
 * Posted when the change on audio track of currently playing media completes.
 * The notification’s object is the PTMediaPlayerItem instance which is currently playing.
 *
 */
extern NSString *const PTAudioTrackChangeCompleted;

/**
 * Posted when seek operation on currently playing media is initiated.
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 *
 */
extern NSString *const PTMediaPlayerSeekStartedNotification;

/**
 * Posted when seek operation on currently playing media completes sucessfully.
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 *
 */
extern NSString *const PTMediaPlayerSeekCompletedNotification;

/**
 * Posted when seek operation on currently playing media fails and throws an error.
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 *
 */
extern NSString *const PTMediaPlayerSeekErrorNotification;

/**
 * Posted when the media player enters a buffering state
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 */
extern NSString *const PTMediaPlayerBufferingStartedNotification;

/**
 * Posted when the media player exits a buffering state
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 */
extern NSString *const PTMediaPlayerBufferingCompletedNotification;

/**
 * Posted when there's an error on downloading the  background manifest fails.
 * The notification’s object is the PTMediaPlayerItem instance which is currently playing.
 */
extern NSString *const PTBackgroundManifestErrorNotification;

/**
 * Posted when the media player is handling a custom ad.
 * The notification’s object is the PTMediaPlayer instance which is currently playing.
 */
extern NSString *const PTMediaPlayerCustomAdNotification;

/*
 * PTMediaPlayerNotifications header enumerates all the constants for notifications provided by Primetime Player SDK.
 * The following notifications are provided by PSDK.
 *
 *
 * _PTMediaPlayerStatusNotification_
 *
 * _PTMediaPlayerTimeChangeNotification_
 *
 * _PTMediaPlayerItemChangedNotification_
 *
 * _PTMediaPlayerPlayStartedNotification_
 *
 * _PTMediaPlayerPlayCompletedNotification_
 *
 * _PTMediaPlayerMediaSelectionOptionsAvailableNotification_
 *
 * _PTMediaPlayerNewNotificationEntryAddedNotification_
 *
 * _PTMediaPlayerTimelineChangedNotification_
 *
 * _PTMediaPlayerItemDRMMetadataChanged_
 *
 * _PTMediaPlayerAdBreakStartedNotification_
 *
 * _PTMediaPlayerAdBreakCompletedNotification_
 *
 * _PTMediaPlayerAdStartedNotification_
 *
 * _PTMediaPlayerAdProgressNotification_
 *
 * _PTMediaPlayerAdCompletedNotification_
 *
 * _PTMediaPlayerAdClickNotification_
 *
 * _PTTimedMetadataChangedNotification_
 *
 * _PTAudioTrackChangeStarted_
 *
 * _PTAudioTrackChangeCompleted_
 *
 * _PTMediaPlayerSeekStartedNotification_
 *
 * _PTMediaPlayerSeekCompletedNotification_
 *
 * _PTMediaPlayerSeekErrorNotification_
 *
 * _PTMediaPlayerBufferingStartedNotification_
 *
 * _PTMediaPlayerBufferingCompletedNotification_
 *
 * _PTMediaPlayerCustomAdNotification_
 */

@interface PTMediaPlayerNotifications : NSObject

@end

//
//  PTPlaybackInformation.h
//  MediaPlayer
//
//  Created by Jesus Figueroa on 1/14/13.
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


@class PTPlaybackMetrics;

/**
 * PTPlaybackInformation holds QOS information related to the playback.
 */

@interface PTPlaybackInformation : NSObject

/** @name numberOfSegmentsDownloaded */
/**
 * A count of media segments downloaded.
 *
 * Value is negative if unknown. A count of media segments downloaded from the server to this client. Corresponds to "sc-count".
 */
@property (nonatomic, assign, readonly) NSInteger numberOfSegmentsDownloaded;

/** @name numberOfMediaRequests */
/**
 * A count of media read requests.
 *
 * Value is negative if unknown. A count of media read requests from the server to this client. Corresponds to "sc-count".
 * For HTTP live Streaming, a count of media segments downloaded from the server to this client.
 * For progressive-style HTTP media downloads, a count of HTTP GET (byte-range) requests for the resource.
 * Availability: Available in iOS 6.0 and later. Returns -1 if unavailable.
 */
@property (nonatomic, assign, readonly) NSInteger numberOfMediaRequests;

/** @name playbackStartDate */
/**
 * The date/time at which playback began for this event. Can be nil.
 *
 * If nil is returned the date is unknown. Corresponds to "date".
 */
@property (nonatomic, retain, readonly) NSDate *playbackStartDate;

/** @name URI */
/**
 * The URI of the playback item. Can be nil.
 *
 * If nil is returned the URI is unknown. Corresponds to "uri".
 */
@property (nonatomic, retain, readonly) NSString *URI;

/** @name serverAddress */
/**
 * The IP address of the server that was the source of the last delivered media segment. Can be nil.
 *
 * If nil is returned the address is unknown. Can be either an IPv4 or IPv6 address. Corresponds to "s-ip".
 */
@property (nonatomic, retain, readonly) NSString *serverAddress;

/** @name numberOfServerAddressChanges */
/**
 * A count of changes to the property serverAddress, see above, over the last uninterrupted period of playback.
 *
 * Value is negative if unknown. Corresponds to "s-ip-changes".
 */
@property (nonatomic, assign, readonly) NSInteger numberOfServerAddressChanges;

/** @name playbackSessionID */
/**
 * A GUID that identifies the playback session. This value is used in HTTP requests. Can be nil.
 *
 * If nil is returned the GUID is unknown. Corresponds to "cs-guid".
 */
@property (nonatomic, retain, readonly) NSString *playbackSessionID;

/** @name playbackStartOffset */
/**
 * An offset into the playlist where the last uninterrupted period of playback began. Measured in seconds.
 *
 * Value is negative if unknown. Corresponds to "c-start-time".
 */
@property (nonatomic, assign, readonly) NSTimeInterval playbackStartOffset;

/** @name segmentsDownloadedDuration */
/**
 * The accumulated duration of the media downloaded. Measured in seconds.
 *
 * Value is negative if unknown. Corresponds to "c-duration-downloaded".
 */
@property (nonatomic, assign, readonly) NSTimeInterval segmentsDownloadedDuration;

/** @name durationWatched */
/**
 * The accumulated duration of the media played. Measured in seconds.
 *
 * Value is negative if unknown. Corresponds to "c-duration-watched".
 */
@property (nonatomic, assign, readonly) NSTimeInterval durationWatched;

/** @name numberOfStalls */
/**
 * The total number of playback stalls encountered.
 *
 * Value is negative if unknown. Corresponds to "c-stalls".
 */
@property (nonatomic, assign, readonly) NSInteger numberOfStalls;

/** @name numberOfBytesTransferred */
/**
 * The accumulated number of bytes transferred.
 *
 * Value is negative if unknown. Corresponds to "bytes".
 */
@property (nonatomic, assign, readonly) long long numberOfBytesTransferred;

/** @name observedBitrate */
/**
 * The empirical throughput across all media downloaded. Measured in bits per second.
 *
 * Value is negative if unknown. Corresponds to "c-observed-bitrate".
 */
@property (nonatomic, assign, readonly) double observedBitrate;

/** @name indicatedBitrate */
/**
 * The throughput required to play the stream, as advertised by the server. Measured in bits per second.
 *
 * Value is negative if unknown. Corresponds to "sc-indicated-bitrate".
 */
@property (nonatomic, assign, readonly) double indicatedBitrate;

/** @name numberOfDroppedVideoFrames */
/**
 * The total number of dropped video frames.
 *
 * Value is negative if unknown. Corresponds to "c-frames-dropped".
 */
@property (nonatomic, assign, readonly) NSInteger numberOfDroppedVideoFrames;

/** @name timeToLoad */
/**
 * The time taken to load the media
 *
 * Value is 0.0 if unknown.
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeToLoad;

/** @name timeToStart */
/**
 * The time taken to start the media playback
 *
 * Value is 0.0 if unknown.
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeToStart;

/** @name timeToFail */
/**
 * The time taken to fail for media playback
 *
 * Value is 0.0 if unknown.
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeToFail;

/** @name totalBufferingTime */
/**
 * Total time spent in buffering state during playback.
 *
 * Value is 0.0 if unknown.
 */
@property (nonatomic, assign, readonly) NSTimeInterval totalBufferingTime;

/** @name secondsSpent */
/**
 * Total time PTMediaPlayer was in use before it was stopped.
 *
 * Value is 0.0 if unknown.
 */
@property (nonatomic, assign, readonly) NSTimeInterval secondsSpent;

/** @name emptyBufferCount */
/**
 * The number of playbackBufferEmpty events occurred during playback.
 *
 * Value is 0 if unknown.
 */
@property (nonatomic, assign, readonly) int emptyBufferCount;

/** @name playbackBufferEmpty */
/**
 * Indicates whether playback has consumed all buffered media and that playback will stall or end.
 *
 */
@property (nonatomic, assign, readonly) BOOL playbackBufferEmpty;

/** @name playbackBufferFull */
/**
 *Indicates whether the internal media buffer is full and that further I/O is suspended.
 *
 */
@property (nonatomic, assign, readonly) BOOL playbackBufferFull;

/** @name playbackLikelyToKeepUp */
/**
 * Indicates whether the item will likely play through without stalling.
 *
 */
@property (nonatomic, assign, readonly) BOOL playbackLikelyToKeepUp;

/** @name Internal construction */
/**
 * Prepares a movie for playback.
 *
 * This method is used internaly by the PSDK to create the instances of PTPlaybackInformation.
 */
-(id)initWithPlaybackMetrics:(PTPlaybackMetrics *)metrics;

@end

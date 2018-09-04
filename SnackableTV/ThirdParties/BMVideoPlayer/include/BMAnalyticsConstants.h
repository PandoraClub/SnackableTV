//
//  BMAnalyticsConstants.h
//  BMAdobePlayer
//
//  Created by Jorge Valbuena on 2015-08-26.
//  Copyright (c) 2015 Bell Media. All rights reserved.
//

#ifndef BMAdobePlayer_BMAnalyticsConstants_h
#define BMAdobePlayer_BMAnalyticsConstants_h

#import <Foundation/Foundation.h>

/**
 * Omniture Analytics
 */
FOUNDATION_EXTERN NSString *const kMeasurementAccountKeyIpad;
FOUNDATION_EXTERN NSString *const kMeasurementAccountKeyIphone;
FOUNDATION_EXTERN NSString *const kAppStateKey;
FOUNDATION_EXTERN NSString *const kTrackingProdServer;
FOUNDATION_EXTERN NSString *const kTrackingBloodhoundServer; /*A local copy of Adobe SiteCatalyst Bloodhound is required*/
FOUNDATION_EXTERN NSInteger const BLOODHOUNDTRACKER;


/**
 * Analytics Notification Keys
 */
FOUNDATION_EXTERN NSString *const kTrackAuthenticationError;
FOUNDATION_EXTERN NSString *const kTrackAuthenticationEventAtPage;
FOUNDATION_EXTERN NSString *const kTrackViewWithOmniturePageName;
FOUNDATION_EXTERN NSString *const kTrackSearchResultsEventWithSearchKeyword;
FOUNDATION_EXTERN NSString *const kTrackPreRollInformation;
FOUNDATION_EXTERN NSString *const kTrackVideoWithEvent;
FOUNDATION_EXTERN NSString *const kTrackAdsWithEvent;
FOUNDATION_EXTERN NSString *const kTrackChromeCastWithEvent;
FOUNDATION_EXTERN NSString *const kTrackVideoStateWithEvent;


/**
 * Dictionary Keys
 */
FOUNDATION_EXTERN NSString *const kTrackPageName;
FOUNDATION_EXTERN NSString *const kTrackBrandName;
FOUNDATION_EXTERN NSString *const kTrackAuthenticationLocation;
FOUNDATION_EXTERN NSString *const kTrackWithAuthenticationId;
FOUNDATION_EXTERN NSString *const kTrackWithBDU;
FOUNDATION_EXTERN NSString *const kTrackDidSignIn;
FOUNDATION_EXTERN NSString *const kTrackWithSiteSectionArray;
FOUNDATION_EXTERN NSString *const kTrackWithAuthenticationStatus;
FOUNDATION_EXTERN NSString *const kTrackSearchKeyword;
FOUNDATION_EXTERN NSString *const kTrackSearchKeywordNumberOfResults;


/**
 * RDS, BNN, TSN
 * Additional propeties for Page/Article Views
 */

FOUNDATION_EXTERN NSString *const kTrackSPropEvar1;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar2;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar3;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar30;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar31;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar32;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar33;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar4;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar61;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar62;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar63;
FOUNDATION_EXTERN NSString *const kTrackSPropEvar69;


/**
 * Video Tracking
 */
FOUNDATION_EXTERN NSString *const kTrackVideoEventName;
FOUNDATION_EXTERN NSString *const kTrackVideoEventValue;
FOUNDATION_EXTERN NSString *const kTrackVideoWithOmnitureVariablesDictionary;
FOUNDATION_EXTERN NSString *const kTrackVideoAndViewingTimeInSeconds;


/**
 * Tracking parameters for video playback to customize the c/v6-c/v10 values
 * If application has tracked the c/v6-c/v10 values from application side already and do not set this key, will use the last c/v6-c/v10 values
 */
FOUNDATION_EXTERN NSString *const kVideoAnalyticsSiteLevelDictionary;
FOUNDATION_EXTERN NSString *const kVideoAnalyticsEvar6;
FOUNDATION_EXTERN NSString *const kVideoAnalyticsEvar7;
FOUNDATION_EXTERN NSString *const kVideoAnalyticsEvar8;
FOUNDATION_EXTERN NSString *const kVideoAnalyticsEvar9;
FOUNDATION_EXTERN NSString *const kVideoAnalyticsEvar10;


/**
 * video playback status
 */
FOUNDATION_EXTERN NSString *const kVideoStateDevice;
FOUNDATION_EXTERN NSString *const kVideoStateChromecast;
FOUNDATION_EXTERN NSString *const kVideoStateAirplay;


/**
 * authentication status values
 */
FOUNDATION_EXTERN NSString *const kStatAuthenticated;
FOUNDATION_EXTERN NSString *const kStatNotAuthenticated;


/**
 * Omniture video tracking keys (Current CTV Video Player Events)
 * BellVideoPlayerEventVideoStart - event5
 * BellVideoPlayerEventVideoEnd   - event6
 * BellVideoPlayerEventSegment20Seconds - event9
 * BellVideoPlayerEventSegmentEnd - event6
 * BellVideoPlayerEventVideo80Percent - event10
 * BellVideoPlayerEventVideoTimeElapsed - event7
 * - Subject to change
 */
FOUNDATION_EXTERN NSString *const kOMEventName;
FOUNDATION_EXTERN NSString *const kOMEventValue;
FOUNDATION_EXTERN NSString *const kOMEventVideoSegmentID;
FOUNDATION_EXTERN NSString *const kOMEventVideoContentType;
FOUNDATION_EXTERN NSString *const kOMEventVideoTitle;
FOUNDATION_EXTERN NSString *const kOMEventClipID;
FOUNDATION_EXTERN NSString *const kOMEpisodeDuration;
FOUNDATION_EXTERN NSString *const kOMAdsDuration;
FOUNDATION_EXTERN NSString *const kOMEventOwnerName;
FOUNDATION_EXTERN NSString *const kOMShowName;
FOUNDATION_EXTERN NSString *const kOMSeriesName;
FOUNDATION_EXTERN NSString *const kOMSeasonNumber;
FOUNDATION_EXTERN NSString *const kOMEpisodeNumber;
FOUNDATION_EXTERN NSString *const kOMEpisodeName;
FOUNDATION_EXTERN NSString *const kOMEpisodeID;
FOUNDATION_EXTERN NSString *const kOMPack;
FOUNDATION_EXTERN NSString *const kOMStackID;
FOUNDATION_EXTERN NSString *const kOMGenreType;
FOUNDATION_EXTERN NSString *const kOMMediaType;
FOUNDATION_EXTERN NSString *const kOMChannelID;
FOUNDATION_EXTERN NSString *const kOMStackRuntime;
FOUNDATION_EXTERN NSString *const kOMPlayerName;
FOUNDATION_EXTERN NSString *const kSSFormType;                // StreamSense form type, short-form/long-form
FOUNDATION_EXTERN NSString *const kruxID;
FOUNDATION_EXTERN NSString *const kruxBrand;
FOUNDATION_EXTERN NSString *const kruxBrandTye;
FOUNDATION_EXTERN NSString *const kruxBrandNews;
FOUNDATION_EXTERN NSString *const kruxBrandEntertainment;
FOUNDATION_EXTERN NSString *const kruxBrandSports;
FOUNDATION_EXTERN NSString *const kruxBrandMusic;
FOUNDATION_EXTERN NSString *const kruxSectionName;            // series_name or section name for krux
FOUNDATION_EXTERN NSString *const kruxVideoName;
FOUNDATION_EXTERN NSString *const kruxArtistName;
FOUNDATION_EXTERN NSString *const kruxGenre;
FOUNDATION_EXTERN NSString *const kStreamsenseBrand;
FOUNDATION_EXTERN NSString *const kOMPrerollName;
FOUNDATION_EXTERN NSString *const kOMPrerollPosition;


#endif

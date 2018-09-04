//
//  BMConvivaParameters.h
//  BMAdobePlayer
//
//  Created by Jorge Valbuena on 2015-08-26.
//  Copyright (c) 2015 Bell Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BMConvivaParameters : NSObject

#pragma mark - Conviva Parameters

/** Holds the Conviva value for the brand name (ex: CTV). */
@property (nonatomic, copy, readwrite) NSString *brandName;


/** Holds the Conviva value for the player name (ex: CTV iOS). */
@property (nonatomic, copy, readwrite) NSString *playerName;


/** Holds the Conviva value for the video player version from the video player. */
@property (nonatomic, copy, readwrite) NSString *playerVersion;


/** Holds the Conviva value for the app version. */
@property (nonatomic, copy, readwrite) NSString *appVersion;


/** Holds the Conviva value for the content name from the video player. */
@property (nonatomic, copy, readwrite) NSString *contentName;


/** Holds the Conviva value for the content category (ex: Entertainment). */
@property (nonatomic, copy, readwrite) NSString *contentCategory;


/** Holds the Conviva value for the content type from the video player. */
@property (nonatomic, copy, readwrite) NSString *contentType;


/** Holds the Conviva value if the user is streaming over mobile network from the video player. */
@property (nonatomic, assign, readwrite) BOOL isStreamingOverMobileNetwork;


/** Holds the Conviva value for the analytics genre type from the video player. */
@property (nonatomic, copy, readwrite) NSString *analyticsGenreType;


/** Holds the Conviva value for the authentication id from the video player. */
@property (nonatomic, copy, readwrite) NSString *authenticationId;


/** Holds the Conviva value for the authentication BDU from the video player. */
@property (nonatomic, copy, readwrite) NSString *authenticationBDU;


/** Holds the Conviva value for the user authentication from the video player. */
@property (nonatomic, assign, readwrite) BOOL isAuthenticated;


/** Holds the Conviva values for is playing live from the video player (internal). */
@property (nonatomic, assign, readwrite) BOOL isPlayingLive;


/** Holds the Conviva values for is DRM from the video player (internal). */
@property (nonatomic, assign, readwrite) BOOL isDRM;


/** Holds the Conviva values for the DRM type from the video player (internal). */
@property (nonatomic, copy, readwrite) NSString *drmType;


/** Holds the Conviva value for the video player description from the video player (internal). */
@property (nonatomic, copy, readwrite) NSString *playerDescription;


/** Holds the Conviva value for the asset name from the video player (internal). */
@property (nonatomic, copy, readwrite) NSString *assetName;


/** Holds the Conviva value for the content URL from the video player (internal). */
@property (nonatomic, copy, readwrite) NSString *contentURL;


/** Holds the Conviva value for the analytics show name from the video player (internal). */
@property (nonatomic, copy, readwrite) NSString *analyticsShowName;


/** Holds the Conviva value for the cdn grouping. */
@property (nonatomic, copy, readwrite) NSString *videoSubdomain;


/** Holds the Conviva value for the cdn name (internal). */
@property (nonatomic, copy, readonly) NSString *cdnName;


/** Holds the Conviva value for the segment (internal). */
@property (nonatomic, copy, readonly) NSString *segment;


@end

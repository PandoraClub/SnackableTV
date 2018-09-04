//
//  AVEVideoEngine.h
//  videoEngine
//
//  Created by Sean Batson on 2013-10-23.

//  BMVideoPlayerLipo - To build third party library
//  - Product folder is located in SRCROOT of BMAdobePlayer project

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSStreamSense.h"
#import "BMVideoEngineConstants.h"
#import "BMActivityIndicatorType.h"
#import "BMConnectionAndUserSettings.h"

/**
 * Create the appropriate "localizable.string" file for the
 * language you wish to support.
 *
 * Keys = Values
 *
 * Video Engine Visible Labels
 * ============================
 * "VIDEOENGINE_ADTIMEREMAINING" = "Ad Time Remaining: %d %@";
 * "VIDEOENGINE_LIVE" = "LIVE";
 *
 * Video Engine Accessibility Hints
 * =================================
 *
 * "VIDEOENGINE_PLAYBUTTON" = "Play";
 * "VIDEOENGINE_REWINDBUTTON"="Rewind";
 * "VIDEOENGINE_FASTFORWARD"="Fast forward";
 * "VIDEOENGINE_TOTALTIME"="Total Time";
 * "VIDEOENGINE_SEEKSLIDER"="Seek";
 * "VIDEOENGINE_CURRENTTIME"="Current Time";
 * "VIDEOENGINE_AIRPLAY"="Airplay";
 * ----------------------------------------------------------------------------------------
 * This version of the video player provides
 * - Built-in click thru ads support with "more info" button & an internal web view for ads
 * - Back button & Info button with delegate call back methods
 * - And a lot less delegate methods
 * ----------------------------------------------------------------------------------------
 */



FOUNDATION_EXPORT NSString * const kVIdeoEngineMediaChannelName;


@class AVEViewController, AVEVideoItem, BMPlayerVideoMetadata, BMSharingItems, BMConvivaSessionManager, BMConvivaParameters, BMPlayerEndPlayData;
@protocol AVEVideoDelegate;

/**
 * Block definitions
 */
typedef UIView* (^MediaPlayerViewForPlayback)();


#pragma mark - Video Engine


#pragma mark - Interface AVEVideoEngine

@interface AVEVideoEngine : NSObject

#pragma mark Public Properties

/** The delegate of the AVEVideoDelegate. */
@property (nonatomic, weak) id<AVEVideoDelegate> delegate;


/** Tells the video engine there is an info button. */
@property (nonatomic, assign, readwrite) BOOL hasInfoButton;


/** The Conviva session manager. */
@property (nonatomic, strong, readonly) BMConvivaSessionManager *convivaManager;


/** This tells the video engine it can display the chromecast button. */
@property (nonatomic, assign, readwrite) BOOL chromecastButtonCanBeDisplayed;


/** Holds the language as a string. */
@property (nonatomic, strong) NSString *language;


/** This dictionary contains all the up next dictionary. */
@property (nonatomic, strong, readwrite) NSDictionary *upNextDictionary;


/** This array contains the extra data items */
@property (nonatomic, strong, readwrite) NSArray *extraVideosArray;

/* This UserSetting contains how the user wants to stream data */
@property (nonatomic, assign) BMUserSetting   userConnectionState;


/** 
 A view controller that is to be used as a child view controller when using view controller
 based status bar style and visibility. 
 
 If you have set UIViewControllerBasedStatusBarAppearance to YES in your info.plist file (or,
 if you have not set this at all which means a default of YES), then the video player's status bar
 settings are ignored. To remedy this, you must add the view controller provided by this property
 as a child view controller of your view controller, and then use the 
 -childViewControllerForStatusBarHidden and -childViewControllerForStatusBarStyle UIViewController
 methods. 
 
 This property will not have a value until AFTER you have invoked 
 -[AVEVideoEngine prepareVideoStreamForPlaybackUsing:currentView:]. Please see the video player
 integration guide for full details. 
 
 @warning 
    You should NOT use this for anything other than hooking up the video player's internal
    view controller within the apps based status bar appearance system.
 */
@property (nonatomic, strong, readonly) UIViewController *viewControllerForStatusBarAppearance;


#pragma mark Public Methods

/**
 Initialize a singleton instance of the video player engine.
 
 @return
    A video player engine singleton intance.
*/
+ (instancetype)sharedInstance;


/**
 Prepares the video stream for playback use. These properties must be already intialized or not nil (delegate, dictionary and viewBlock).
 
 @param dictionary
    The video player information as a dictionary.
 @param viewBlock
    The view for video playback.
 
 @return
    The video item containing the video stream for playback use.
*/
- (AVEVideoItem *)prepareVideoStreamForPlaybackUsing:(NSDictionary *)dictionary currentView:(MediaPlayerViewForPlayback)viewBlock;


/**
 Gets the video player version as a string.
 
 @return
    The video player version.
*/
- (NSString *)getVideoPlayerVersion;


/**
 Sets the message dictionary to be used in the video player.
 
 @param messageDictionary
    The message dictionary.
*/
- (void)setMessageDictionary:(NSDictionary *)messageDictionary;


/**
 Stores an object of type id in the video player configurations.
 
 @param anObject
    Sets an object of type id in the video player configurations.
 @param aKey
    The object description key.
*/
- (void)setObject:(id)anObject forKey:(NSString *)aKey;


/** Tell the video engine that it should reload the video metadata for live content that is currently playing. */
- (void)reloadLiveVideoMetadata;


/** reset DRM licences. */
- (void)resetDRM;

#pragma mark - -- Rules Parsing API --

/**
 Method which takes an @BMUserSetting and a @BMConnectionType and a pointer to a @NSString and returns
 wether or not the content can be played according to the rules in VideoStartupRules.plist.
 
 @param userSetting
 The @BMUserSetting representing how the user want to stream the data. See BMConnectionAndUserSettings.h for
 values
 
 @param networkConnection
 The @BMConnectionType representing how the iOS device is connected to the internet. See BMConnectionAndUserSettings.h
 for values.
 
 @param errorMessage
 A pointer to an @NSString which will hold a key to an error message if the rule fails or nil if it succeeds.
 
 @return
 An BOOL representing success or failure of the method.
 */
- (BOOL)isPlayableFromRules:(BMUserSetting)userSetting
          networkConnection:(BMConnectionType)networkConnection
                errorString:(NSString **)errorString;

/**
 Method to start playback after an initial failure of the video startup
 rules. Since none of the video infastructure has been created (as apposed to) a network
 change while playing. This method creates the infastructure and plays the video.
 
 @param no parameters
 
 @return nothing
 */
- (void)restartPlaybackFromInitialReachabilityAlert;

@end


/***
 * Configuration of Player UI
 */
#pragma mark - Video Engine - Configuration

@interface AVEVideoEngine (AVEConfiguration)

/** Returns if the video engine is configured or not. */
@property (nonatomic, readonly) BOOL configured;

@end


/**
 * Start / Stop Video Playback
 */
#pragma mark - Video Engine - Player Controls

@interface AVEVideoEngine (AVEPlayerControls)

/** Pause video playback. */
- (void)pause;


/** Begin video playback. */
- (void)play;


/** Stop video playback and remove view from hosted view hierarchy. */
- (void)stop;


/** Resume video playback. */
- (void)resume;

/** Current video playing status. */
- (BOOL)isPlaying;

/** Is the player is the paused state */
- (BOOL)isPaused;


/** Resume playback at a special time. */
- (void)resumeAtTime:(CGFloat)newTime;

/**
 This will pause and lock the player in the paused state until a call to unlockPlayerWithKey: is made with a matching key.
 
 @discussion This call is NOT re-entrant. Once the player is locked with a key an exception will be thrown if another key is set.
*/
- (void)lockPlayerWithKey:(NSString *)key;


/**
 Cancels the effect of lockPlayerWithKey: and issues a play to the player.
 
 @discussion If the player is not locked then this issues a direct call to the player to play. This method should only be used
    with a matching lockPlayerWithKey: call.
 
 @param key 
    The key used to lock the player.\
 @param play 
    If YES then player will receive a play request right away.
*/
- (void)unlockPlayerWithKey:(NSString *)key play:(BOOL)play;


/**
 Returns the locking key used when calling lockPlayerWithKey:.
 
 @discussion If the player has been locked then this method returns the current key, if no lock has been placed, then nil is returned.
*/
- (NSString *)lockingKey;

@end


/**
 * Class Protocol Implementation
 */
#pragma mark - Video Engine - Delegate (requires)

@protocol AVEVideoDelegate <NSObject>

/** 
 Return an AdUnit id in the format: /network-name/adunit-name/showname. 

 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The ad unit name.
*/
- (NSString *)videoEngineAdUnitName:(AVEVideoEngine *)videoEngine;


/** 
 Video Master Tag as specified by adOps: 1x1. 
 
 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The video master tag name.
*/
- (NSString *)videoEngineAdMasterTagName:(AVEVideoEngine *)videoEngine;


/**
 Gets the app product name from the host app as a string.
 
 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The app product name.
*/
- (NSString *)videoEngineControllerName:(AVEVideoEngine *)videoEngine;


#pragma mark Presenting & Exit

/** 
 Gets the app version from the host app as a string. 

 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The app version.
*/
- (NSString *)videoEngineControllerVersion:(AVEVideoEngine *)videoEngine;


/** 
 Tells the video player the exit button was pressed.
 
 @param videoEngine
    The video engine that is playing the content.
 @param button
    The exit/back button of the video player.
*/
- (void)videoEngine:(AVEVideoEngine *)videoEngine exitButtonWasSelected:(UIButton *)button;


/** 
 Returns the view controller that handles the presentation of the web browser or NULL to ignore.

 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The view controller that handles the presentation of the web browser.
*/
- (UIViewController *)videoEngineWillPresentAdClickThrough:(AVEVideoEngine *)videoEngine;


/**
 Asks the host app/video playback view for the brand logo image to be displayed for back/exit button for back/exit button in the video player (image size: 49x49, 98x98 (2x), 145x145 (3x)).
 
 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The brand logo image to display for back/exit button.
*/
- (UIImage *)videoEngineWithBrandLogo:(AVEVideoEngine *)videoEngine;


#pragma mark Sharing

/**
 Returns a Boolean which tells the video player if sharing should be enabled during video playback.
 
 @discussion The default is for sharing to be disabled, so if you want it enabled you must implement
    this method and return YES.
 
 @param videoEngine
    The video engine that is playing the content.
 
 @return
    YES if you want to enable the sharing interface within the video controls, NO otherwise.
*/
- (BOOL)videoEngineSharingEnabled:(AVEVideoEngine *)videoEngine;


/**
 Asks the delegate host app for the items to share as a mutable array (text, image and url).
  
 @param videoEngine
     The video engine that is playing the content.
 
 @return
    The content that will be passed directly into the initializer for an UIActivityViewController
*/
- (BMSharingItems *)videoEngineSharingContent:(AVEVideoEngine *)videoEngine;


/**
 Asks the delegate host app for the current view controller to present sharing controller from.
 
 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The UIViewController to present sharing controller from.
*/
- (UIViewController *)videoEngineWillPresentSharingController:(AVEVideoEngine *)videoEngine;


/**
 Asks the host app for the activity indicator type.
 
 @return 
    The activity indicator type: default, crave.
 */
- (BMActivityIndicatorType)videoEngineWithActivityIndicatorType;


#pragma mark - Video Engine - Delegate (optionals)

@optional

/**
 The function can be used to save user's last playback position and it will be called every five seconds with a timestamp.

 @param videoEngine
    The video engine that is playing the content.
 @param currentTime
    The current playback time.
*/
- (void)videoEngine:(AVEVideoEngine *)videoEngine withCurrentTime:(NSNumber *)currentTime;


/** 
 Fast Forward equals to YES Means Hidden, No Means Not Hidden.
 
 @param videoEngine
    The video engine that is playing the content.
*/
- (BOOL)videoEngineHideFastForward:(AVEVideoEngine*)videoEngine;


/** 
 Tells the host app/video playback view when the video playback has finished playing and it's usually used to close the video player.
 
 @param videoEngine
    The video engine that is playing the content.
*/
- (void)videoDidFinishPlaying:(AVEVideoEngine *)videoEngine;


/** 
 Tells the host app/video playback view if the video was resumed or not.

 @param videoEngine
    The video engine that is playing the content.
*/
- (BOOL)videoEngineVideoWasResumed:(AVEVideoEngine *)videoEngine;


#pragma mark Custom Scrubber Delegates

/**
 The Slider track color for reminder/viewed progress.
 
 @param fromColor
    The reminder slider color.
 @param toColor
    The viewed slider color.
 
 @return
    The slider size.
 */
- (CGSize)videoEngineSliderWithFromColor:(UIColor *)fromColor
                              andToColor:(UIColor *)toColor;


/**
 The Ad Marker in the slider track color for reminder/viewed progress.
 
 @param fromColor
    The reminder slider color.
 @param toColor
    The viewed slider color.
 
 @return
    The slider size.
 */
- (CGSize)videoEngineAdMarkerWithFromColor:(UIColor *)fromColor
                                andToColor:(UIColor *)toColor;


/**
 The Thumb color for the normal state in the slider track color for reminder/viewed progress.
 
 @param fromColor
    The reminder slider color.
 @param toColor
    The viewed slider color.
 
 @return
    The slider size.
 */
- (CGSize)videoEngineNormalScrubberWithColor:(UIColor *)color
                             andOutlineColor:(UIColor *)outline
                         andFirstStrokeWidth:(NSNumber *)strokeFloat1
                        andSecondStrokeWidth:(NSNumber *)strokeFloat2;


/**
 The Thumb color for the active state in the slider track color for reminder/viewed progress.
 
 @param fromColor
    The reminder slider color.
 @param toColor
    The viewed slider color.
 
 @return
    The slider size.
 */
- (CGSize)videoEngineActiveScrubberWithColor:(UIColor *)color
                        andGradientBlurColor:(UIColor *)bluredColor
                         andFirstStrokeWidth:(NSNumber *)strokeFloat1
                        andSecondStrokeWidth:(NSNumber *)strokeFloat2;


#pragma mark Chromecast

/**
 Loads/Adds the chromecast button.

 @param videoEngine
    The video engine that is playing the content.
*/
- (void)addChromecastButton:(AVEVideoEngine *)videoEngine;


/**
 Moves chromecast button.

 @param isAdPlaying
    If the ads are playing or not.
*/
- (void)moveChromeCastButton:(BOOL)isAdPlaying;


/** Hides the chromecast button. */
- (void)hideChromeCastButton;


/** Shows the chromecast button. */
- (void)showChromeCastButton;


#pragma mark Conviva

/** Gets a BOOL flag if Conviva is enabled. */
- (BOOL)videoEngineIsConvivaEnabled;


/** Get the Conviva key. */
- (NSString *)videoEngineGetConvivaKey;


/**
 Gets all the Conviva paramaters like: brand name, player name, player version, player description, content category, asset name, content type, connection type, content url, analytics genre type,
 analytics show name, authentication id, authentication bdu, authentication status and is playing live.
 
 @return
    An instance of BMConvivaParameters.
*/
- (BMConvivaParameters *)videoEngineConvivaParameters;


#pragma mark Brand

/** The brand app color. */
- (UIColor *)brandColor;


/**
 Tells video player where to position the chromecast button.
 
 @param videoEngine
    The video engine that is playing the content.
 @param rect
    The position for the chromecast button.
*/
- (void)videoEngine:(AVEVideoEngine *)videoEngine positionChromecastButtonInRect:(CGRect)rect;


#pragma mark Analytics

/**
 Gets the analytics dictionary to start tracking.
 
 @param videoEngine
    The video engine that is playing the content.
 
 @return
    The analytics dictionary.
 */
- (NSDictionary *)videoEngineWillFireAnalyticsTracking:(AVEVideoEngine *)videoEngine;


/** comScore StreamSense analytics. */
- (CSStreamSense *)streamSense;


/** Returns true if the player should enable google IMA. */
- (BOOL)useGoogleIMA;


/**
 Gets the Google IMA ad tag url.
 
 @return
    The Google IMA ad tag url.
 */
- (NSString *)adTagIMA;


#pragma mark Other helper functions

/**
 Passes the air play image according to the brand.
 
 @return
    The air play image.
*/
- (UIImage *)airPlayButtonOnImage;


/** Hide the info screen. */
- (void)hideInfoObjects;


/** Show video Overlay. */
- (void)showOverlay;


/** Hide video Overlay. */
- (void)hideOverlay;

#pragma mark Ads


/**
 Tells the video player if the ad marker should expand with duration, default is YES if not implemented.
 
 @return
    If the ad marker should expand or not.
*/
- (BOOL)shouldAdMarkersExpandWithDuration;


/** Returns true if the player should enable AirPlay. */
-(BOOL)useAirPlay;


#pragma mark Up Next Configuration

/** Play the next episode. */
-(void)playNextEpisode;


/** Returns true if the player should display up next. */
- (BOOL)shouldDisplayUpNext;


/** 
 Tells the host app when to request up next content. 

 @param videoEngine
    The video engine that is playing the content.
*/
- (void)videoEngineRequestUpNextContent:(AVEVideoEngine *)videoEngine;

- (NSArray *)videoEngineRequestRelatedVideoContent:(AVEVideoEngine *)videoEngine;


/**
 Tells the host app to request the end data content.
 
 @param videoEngine
 The video engine that is playing the content.
 */
- (void)videoEngineRequestExtraContent:(AVEVideoEngine *)videoEngine;

/** Tells when the up next controller will be presented animated. */
- (void)upNextControllerWillShowAnimated;

/**
 Returns true if the player should display the closed caption button.

 @return
    If the player should display the closed caption button.
*/
- (BOOL)shouldDisplayClosedCaption;


/** 
 How many seconds before the end of the video to display the up next.

 @return
    The time remaining for up next.
*/
- (CGFloat)timeRemainingForUpNext;

/** Wether or not the application allows the player to handle reachability
 changes
 
 @return 
    Wether or not the player handles reachability changes. If NO, the app
    is responsible for informing the user of such changes.
 */
- (BOOL)playerHandlesReachability;

#pragma mark Info Panel and Bottom Bar Metadata

/**
 Asks the delegate how often the video player should check with the delegate for updated
 video metadata. 
 
 The delegate should return the value as seconds. So if you want the video player to check
 for updates every minute, then you should return 60 seconds in your delegate's implementation
 of this method.
 
 By default, if you do not implement this, then the video player will not check for updated
 video metadata after the first load of the player. Also, returning 0 here will cause the same
 behaviour.
 
 @return
    The desired number of seconds between updates.
*/
- (NSTimeInterval)metadataUpdateRateForLiveVideo;


/**
 Asks the delegate for the video metadata for the currently playing video.
 
 @return
    A BMPlayerVideoMetadata instance
*/
- (BMPlayerVideoMetadata *)metadataForCurrentVideo;


#pragma mark - End Play metada for "More Videos" & "Watch Again"


/** Sends a message to the delegate whenever the watch again is pressed. It should re-start the current playback content. */
- (void)endPlayWatchAgainWasPressed;


/**
 Tells the host app when a video has been selected from the more video sections in End Play and passes the selected video guid to start playback.
 
 @param guid
    The selected video guid.
 */
- (void)endPlaySelectedVideoWithGuid:(NSString *)guid;


/** 
 Tells the video player if it should display End Play. @a Note: End Play won't be shown if Up Next is enabled.
 
 @return 
    A Boolean specifing if End Play is enabled or not.
 */
- (BOOL)shouldDisplayEndPlay;

@end

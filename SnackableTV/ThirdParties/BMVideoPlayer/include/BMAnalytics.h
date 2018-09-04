//
//  BMAnalytics.h
//  videoEngine
//
//  Created by Sean Batson on 2012-11-21.
//
//

#import <Foundation/Foundation.h>
#import "BMAnalyticsConstants.h"

#ifndef ANALYTICS_MESSAGING
    #define ANALYTICS_MESSAGING
#endif


/**
 * Signin States
 */
typedef NS_ENUM(NSInteger, BMAnalyticsLoginStates)
{
    BMAnalyticsLoginStatesLogout,
    BMAnalyticsLoginStatesLogin,
    BMAnalyticsLoginStatesAlreadyLogin
};

typedef NS_OPTIONS(NSInteger, BMAnalyticsLoginMask)
{
    BMAnalyticsLoginStatesDidLogout  =  0,
    BMAnalyticsLoginStatesWillLogout = -1
};


@class ADMS_Measurement;

@protocol BMAnalyticsDelegate;

#pragma mark - Interface Analytics

@interface BMAnalytics : NSObject

/** Boolean specifing if the use of production omniture tracking. */
@property (nonatomic, assign) BOOL useProductionOmnitureTracking;


/** Holds the page name. */
@property (nonatomic, strong, readonly) NSString *pageName;


/** The app state as string. */
@property (nonatomic, strong) NSString *appState;


/** The video player state (device, chromecast or airplay). */
@property (nonatomic, strong, readonly) NSString *videoState;


/** Must be assigned or tracking defaults to Bravo Go. */
@property (nonatomic, strong) NSString *oMeasurementAccountKey;


/** Required Krux ID value for Krux tracking. */
@property (nonatomic, copy) NSString *kruxId;


/** Required Brand value for Krux tracking. */
@property (nonatomic, copy) NSString *kruxBrand;


/** 
 Indicates if this tracking library should perform initial Krux app launch tracking.
 
 If you use BMAnalytics to power your app's analytics (perform Omniture page tracking, etc), then
 enabling this feature will cause BMAnalytics to automatically track the Krux app launch metric.
 
 Analytics requires that we track app open with Krux when the app is launched. Your app may already
 do this and you do not want BMAnalytics to do it for you. If this is the case, set this to NO. 
 
 Defaults to NO.
 */
@property (nonatomic, assign) BOOL shouldPerformKruxAppLaunchTracking;


/**
 Should the video player perform Krux tracking. 
 
 This defaults to YES. If you set this to NO, then it is your app's responsibility to perform
 all of the required Krux tracking. We really don't want you to do this, so be sure you know what
 you are doing!
 
 If you are disabling internal Krux tracking, then this is the first thing that you should be
 doing with the BMAnalytics shared instance.
 */
@property (nonatomic, assign) BOOL shouldPerformKruxTracking;


/** 
 The KruxTracker instance that the Video Player uses interally.
 
 Feel free to use this for your own custom Krux tracking from calls within your app.
 */
@property (nonatomic, readonly) id krux;


/** The last used set of strings. */
@property (nonatomic, strong) NSArray  *lastUsedStrings;


/** The last used title or headline. */
@property (nonatomic, strong) NSString *lastUsedTitleOrHeadline;


/** The set of pre-roll information. */
@property (nonatomic, strong) NSMutableDictionary *prerollInformation;


/** The app version string. */
@property (nonatomic, strong) NSString* appVersion;


/** BMAnalyticsDelegate. */
@property (nonatomic, weak) id <BMAnalyticsDelegate>delegate;


#pragma mark Methods

/**
 Creates a BMAnalytics singleton instance.
 
 @return
    The BMAnalytics instance.
 */
+ (instancetype)sharedInstance;


/**
 Tracks video events with value, omniture variables and time in seconds.
 
 @param eventOrNil
    The event to track as a string.
 @param valueOrNil
    The value of the event tracking.
 @param omnitureVars
    The omniture variables for event tracking.
 @param viewingTime
    The current viewing time in seconds.
 */
- (void)trackVideoWithEvent:(NSString *)eventOrNil Value:(NSString *)valueOrNil withOmnitureVariables:(NSDictionary*)omnitureVars andViewingTimeInSeconds:(int64_t)viewingTime;


/**
 Tracks video events with value and omniture variables.
 
 @param eventOrNil
    The event to track as a string.
 @param valueOrNil
    The value of the event tracking.
 @param omnitureVars
    The omniture variables for event tracking.
 */
- (void)trackVideoWithEvent:(NSString *)eventOrNil Value:(NSString *)valueOrNil withOmnitureVariables:(NSDictionary*)omnitureVars;


/**
 Tracks views with omniture page name, authentication status, authentication id, authentication bdu, site section array and aux dictionary.
 
 @param omPageName
    The omniture page name.
 @param status
    The authentication status.
 @param userId
    The authentication id.
 @param bdu
    The authentication bdu.
 @param siteSections
    The site section array.
 @param dict
    The aux dictionary.
 */
- (void)trackViewWwithOmniturePageName:(NSString *)omPageName
              withAuthenticationStatus:(NSString *)status
                   andAuthenticationId:(NSString *)userId
                  andAuthenticationBdu:(NSString *)bdu
                  withSiteSectionArray:(NSArray *)siteSections
                     withAuxDictionary:(NSMutableDictionary *) dict;


/**
 Tracks the authentication error.
 
 @param errorName
    The error name.
 */
- (void)trackAuthenticationError:(NSString *)errorName;


/**
 Tracks the authentication event with page name, authentication id, bdu name and did sign in.
 
 @param omPageName
    The page name to track.
 @param userId
    The authentication id.
 @param BDUName
    The bdu name.
 @param didSignIn
    The analytics login state.
 */
- (void)trackAuthenticationEventAtPageName:(NSString *)omPageName withAuthenticationId:(NSString *)userId withBDU:(NSString *)BDUName didSignIn:(BMAnalyticsLoginStates)didSignIn;


/**
 Tracks the search result event with search key word and number of results.
 
 @param searchWord
    The search key word.
 @param numberOfResults
    The number of results.
 */
- (void)trackSearchResultsEventWithSearchKeyword:(NSString *)searchWord andNumberOfResults:(NSInteger)numberOfResults;


/**
 Tracks info click event for a show name.
 
 @param showName
    The show name to track.
 */
- (void)trackInfoClickEventForShow:(NSString *)showName;


/**
 Tracks info click event for analytics dictionary.
 
 @param aDict
    The analytics dictionary to track.
 */
- (void)trackInfoClickEventForAnalyticsDict:(NSDictionary *)aDict;


/**
 Track a user action on the end play screen.
 
 A user action is a selection of a show from the end play screen. You provide a show name, or if you provide
 a nil show, then the method will try to pull the show name out of the analytics dictionary.
 
 @param show
 The name of the show that the user has selected on the end screen.
 @param analyticsDictionary
 The dictionary of analytics data that is being used for the current video playback session.
 */
- (void)trackEndScreenInteractionForShow:(NSString *)show
                     analyticsDictionary:(NSDictionary *)analyticsDictionary;


/**
 Tells if enable debug logging or not.
 
 @param enable
    If debug logging is enabled or not.
 */
- (void)enableDebugLogging:(BOOL)enable;


/** Setups omniture tracking. */
- (void)setupOmnitureTracking;


/**
 Returns the Krux segments.
 
 @return
    The krux segments.
 */
-(NSString *)kruxSegments;


/**
 Returns the advertising id.
 
 @return
    The advertising id.
 */
-(NSString *)adventisingId;

@end


#pragma mark - Analytics Delegate

@protocol BMAnalyticsDelegate <NSObject>

@optional

/**
 Client implements this method to capture the Class "title" or "descriptive label"
 Omniture AppState tracking - replaces all stringForClass: methods
 
 @param sender
    The class for analytics.
 
 @return
    The analytics state.
 */
- (NSString *)analyticsAppStateStringFromClass:(id)sender;

@end


#pragma mark - Interface Analytics Notifications

@interface BMAnalytics (NSNotificationCenterMessages)

/**
 Tracks the video with event notification.
 
 @param notification
    The event notification.
 */
- (void)trackVideoWithEventNotification:(NSNotification *)notification;


/**
 Tracks the ads with event notification.
 
 @param notification
    The event notification.
 */
- (void)trackAdsWithEventNotification:(NSNotification *)notification;


/**
 Tracks the pre-roll with information notification.
 
 @param notification
    The information notification.
 */
- (void)trackPreRollInformationNotification:(NSNotification *)notification;


/**
 Tracks the search results with search key word notification.
 
 @param notification
    The search key word notification.
 */
- (void)trackSearchResultsEventWithSearchKeywordNotification:(NSNotification *)notification;


/**
 Tracks the view with omniture page name notification.
 
 @param notification
    The omniture page name notification.
 */
- (void)trackViewWithOmniturePageNameNotification:(NSNotification *)notification;


/**
 Tracks the authentication event with page notification.
 
 @param notification
    The page notification.
 */
- (void)trackAuthenticationEventAtPageNotification:(NSNotification *)notification;


/**
 Tracks the authentication error with error notification.
 
 @param notification
    The error notification.
 */
- (void)trackAuthenticationErrorNotification:(NSNotification *)notification;


/**
 Tracks the video state with state notification.
 
 @param notification
    The state notification.
 */
- (void)trackVideoStateNotification:(NSNotification *)notification;


/**
 Tracks the video state with event notification.
 
 @param notification
    The event notification.
 */
- (void)trackVideoStateEventNotification:(NSNotification *)notification;


/**
 Provides tracking data that needs to be relayed to Chromecast receivers.
 
 @param
    A dictionary with NSNumber values as keys, which coorespond to evar/sprop variables. The values
    of the dictionary are NSString instances.
 */
- (NSDictionary *)propertiesForChromecastReceiver;

@end
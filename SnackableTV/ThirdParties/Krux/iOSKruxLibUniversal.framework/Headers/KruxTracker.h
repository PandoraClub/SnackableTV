//
//  KruxTracker.h
//  KruxTracker
//
//  Created by Roopak Gupta on 6/10/12.
//  Copyright (c) 2012 Krux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KruxTrackerController.h"

// Krux Tracker. Tracked pageview and events are stored
// in a persistent store and dispatched in the background to the server
@interface KruxTracker : NSObject<KruxTrackerController>{
    BOOL _debug;
    BOOL _dryRun;
    NSString *_configId;
    NSArray *_segments;
}

// if the debug flag is set, debug messages will be written to the logs.
// It is useful to debug calls to Krux Tracker.
// By default, debug flag is false.
@property(readwrite) BOOL debug;

// If the dryRun flag is set, hits will not be sent to Krux Tracker.
// It is useful for testing and debugging calls to the Krux SDK.
// By default, the dryRun flag is disabled.
@property(readwrite) BOOL dryRun;

// This is the unique configId that is given to an app developer.
@property(readwrite) NSString *configId;

// This is segments for the user. This is readonly.
@property(readonly) NSArray *segments;

// Initialize with Config Id. This is the initializer that should be called from the
// apps if you want to debug messages
- (id)initWithConfigIdandDebug:(NSString *)confId
                               debug_flag:(BOOL)debug_flag;

// Initialize with Config Id. This is the initializer that should be called form the
// apps
- (id)initWithConfigId:(NSString*)configId;

// Track a page view. 
// Returns YES on success or NO on error with error set to the specific error.
// All the attributes are treated as page attributes
- (BOOL)trackPageView:(NSString *)section
           attributes:(NSMutableDictionary *)attributes
            withError:(NSError **)error;


-(void)addExternalTracker:(id<KruxTrackerController>) tracker;

-(void) stopExternalTracker:(id<KruxTrackerController>) tracker;


@end

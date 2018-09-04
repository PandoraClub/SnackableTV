//
//  TrackerController.h
//  KruxADM
//
//  Created by Aliaksei Lud on 2/24/14.
//
//

#import <Foundation/Foundation.h>

@protocol KruxTrackerController <NSObject>

// Track a page view.
// Returns YES on success or NO on error with error set to the specific error.
- (BOOL)trackPageView:(NSString *)section
       pageAttributes:(NSMutableDictionary *)pageAttributes
       userAttributes:(NSMutableDictionary *)userAttributes
            withError:(NSError **)error;


// Track an event. This event is fired using fireEvent
// Returns YES on success or NO on error with error set to the specific error.
- (BOOL)fireEvent:(NSString *)eventUid
  eventAttributes:(NSMutableDictionary *)eventAttributes
        withError:(NSError **)error;

@end

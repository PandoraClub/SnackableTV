//
//  IMAMoatTrackerManager.h
//  MoatMobileAppKit
//
//  Created by alex on 8/12/15.
//  Copyright © 2016 Moat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>
#import "BELLMoatBootstrap.h"

@interface BELLMoatIMATrackerManager : BELLMoatBootstrap

@property (weak) UIView *baseView;

- (id) initWithPartnerCode:(NSString *) partnerCode;
- (void) dispatchEvent:(IMAAdEvent *)event;
- (void) onPodEnded;
- (void) onPodError;
- (void) stop;

@end

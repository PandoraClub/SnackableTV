/*
 Copyright 2009-2017 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIKit.h>

@class UAConfig;
@class UAPreferenceDataStore;
@class UAPush;

NS_ASSUME_NONNULL_BEGIN

/**
 * ChannelCapture checks the device clipboard for an expected token on app
 * foreground and displays an alert view that allows the user to copy the Channel
 * or optionally open a url with the channel as an argument.
 */
@interface UAChannelCapture : NSObject <UIAlertViewDelegate>

/**
 * Factory method to create the UAChannelCapture.
 *
 * @param config The Urban Airship config.
 * @param push The UAPush instance.
 * @param dataStore The UAPreferenceDataStore instance.
 *
 * @return A channel capture instance.
 */
+ (instancetype)channelCaptureWithConfig:(UAConfig *)config
                                    push:(UAPush *)push
                               dataStore:(UAPreferenceDataStore *)dataStore;

/**
 * Enable channel capture for a specified duration.
 *
 * @param duration The length of time to enable channel capture for, in seconds.
 */
- (void)enable:(NSTimeInterval)duration;

/**
 * Disable channel capture.
 */
- (void)disable;

@end

NS_ASSUME_NONNULL_END

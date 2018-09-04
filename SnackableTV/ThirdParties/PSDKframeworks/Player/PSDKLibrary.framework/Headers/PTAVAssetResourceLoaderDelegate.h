//
//  PTAssetResourceLoaderDelegate.h
//  PSDKLibrary
//
//  Created by Jesus Figueroa on 4/28/15.
//  Copyright (c) 2015 Adobe Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 * An AVAsset resource loader delegate. The player will use the registered AVAsset resource loader when assistance is required of the application to load a resource. See AVFoundation's AVAssetResourceDelegate.
 */
@protocol PTAVAssetResourceLoaderDelegate <NSObject>

@required

/** @name resourceLoader: shouldWaitForLoadingOfRequestedResource: */
/**
 * Invoked when assistance is required of the application to load a resource.
 * The delegate must follow the AVAssetResourceLoaderDelegate protocol and respond to the loadingRequest.
 */
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest;

@end


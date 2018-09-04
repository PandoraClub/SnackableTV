//
//  BMSharingItems.h
//  BMAdobePlayer
//
//  Created by Jorge Valbuena on 2015-07-20.
//  Copyright (c) 2015 Bell Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BMSharingItems : NSObject

#pragma mark Properties

/** The user comment to be shared. */
@property (nonatomic, strong, readwrite) NSString *userComment;


/** The video url to be shared. */
@property (nonatomic, strong, readwrite) NSURL *url;


#pragma mark Methods

/**
 Initializes BMSharingItems.
 
 @return
    instancetype of BMSharingItems initialized.
 */
- (instancetype)init;


/**
 Initializes BMSharingItems with user comment and url to be shared.
 
 @param userComment
    comment to be shown within video sharing
 @param url
    url to access the video
 
 @return
    instancetype of BMSharingItems initialized with an user comment and url.
 */
- (instancetype)initWithUserComment:(NSString *)userComment url:(NSURL *)url;

@end

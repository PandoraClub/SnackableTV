//
//  AVEVideoItem.h
//  videoEngine
//
//  Created by Sean Batson on 2013-10-23.
//
//

#import <Foundation/Foundation.h>


#pragma mark - Interface AVEVideoItem

@interface AVEVideoItem : NSObject
{
    NSString *_url;
    NSString *_blackoutUrl;
    NSString *_title;
    NSString *_mediaId;
    NSString *_streamType;
    NSString *_description;
    NSString *_thumbnail;
    NSMutableArray *_tags;
    NSMutableDictionary *_auditudeInfo;
    NSNumber *_live;
    NSNumber *_seekTime;
    NSNumber *_secureFeed;
    NSNumber *_duration;
    NSNumber *_contentPackageID;
    NSString *_mediaDFPName;
}

#pragma mark Properties

/** The video item url. */
@property (nonatomic, strong) NSString *url;


/** The URL to use to load updatex blackout information. */
@property (nonatomic, strong) NSString *blackoutUrl;


/** The video item title. */
@property (nonatomic, strong) NSString *title;


/** The video item media id. */
@property (nonatomic, strong) NSString *mediaId;


/** The video item stream type. */
@property (nonatomic, strong) NSString *streamType;


/** The video item description. */
@property (nonatomic, strong) NSString *description;


/** The video item thumbnail. */
@property (nonatomic, strong) NSString *thumbnail;


/** The video item tags. */
@property (nonatomic, strong) NSArray *tags;


/** The video item auditude info. */
@property (nonatomic, strong) NSDictionary *auditudeInfo;


/** The video item live. */
@property (nonatomic, strong) NSNumber *live;


/** The video item seek time. */
@property (nonatomic, strong) NSNumber *seekTime;


/** The video item secure feed. */
@property (nonatomic, strong) NSNumber *secureFeed;


/** The video item duration. */
@property (nonatomic, strong) NSNumber *duration;


/** The video item content package id. */
@property (nonatomic, strong) NSNumber *contentPackageID;


/** The video item media pdf name. */
@property (nonatomic, strong) NSString *mediaDFPName;


/** The video item media channel name. */
@property (nonatomic, strong) NSString *mediaChannelName;


/** The video item media image url. */
@property (nonatomic, strong) NSString *mediaImageURL;


/** The video item media season episode. */
@property (nonatomic, strong) NSString *seasonEpisode;


#pragma mark Methods

/**
 Initializer with dictionary info.
 
 @param info
    The dictionary info.
 
 @return
    An instance type of AVEVideoItem.
*/
- (instancetype)initWithDictionary:(NSDictionary *)info;


/**
 Tells if there is a tag or not.
 
 @param tag
    The string tag.
 
 @return
    A boolen specifying if there is a tag or not.
*/
- (BOOL)hasTag:(NSString *)tag;

@end


#pragma mark - Interface NSString (AlternateURLItemsEncoding)

@interface NSString (AlternateURLItemsEncoding)

/**
 Encodes a string to embed in an URL.
  
 @return
    The encoded string.
*/
- (NSString *)encodeToPercentEscapeString;


/**
 Decodes a percent escape encoded string.
 
 @return
    The decoded string.
*/
- (NSString *)decodeFromPercentEscapeString;

@end

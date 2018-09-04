//
//  BMPlayerVideoMetadata.h
//  BMAdobePlayer
//
//  Created by David Maddock on 2015-07-12.
//  Copyright (c) 2015 Bell Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Interface BMPlayerVideoMetadata

/**
 An instance of this class describes the video metadata that should be displayed in various
 locations in the video player interface.
 */
@interface BMPlayerVideoMetadata : NSObject

#pragma mark Properties

/** The first line of text that is displayed in the video info panel. */
@property (nonatomic, copy) NSString *title;


/** The second line of text displayed in the video info panel. */
@property (nonatomic, copy) NSString *firstSubtitle;


/** The second line of text displayed in the video info panel. */
@property (nonatomic, copy) NSString *secondSubtitle;


/** The block of description text that is displayed in the info panel. */
@property (nonatomic, copy) NSString *descriptionText;


/**
 The main text that is displayed in the very bottom bar of the video controls
 interface. aka The 'bottom bar'.
 */
@property (nonatomic, copy) NSString *bottomPanelTitle;


/** 
 The additional text that is displayed next to the main text in the very bottom bar of the video 
 controls interface.
 
 The difference between this and the bottomPanelTitle property that bottomPanelTitle is emphasised
 in the interface, so use it for main content. Use this property for lesser data like season #
 and episode #.
 */
@property (nonatomic, copy) NSString *bottomPanelSubtitle;


/** 
 The text that should be displayed for Live content that indicates the time that the currently
 playing asset runs from. 
 
 The idea is that you provide text like '8pm - 8:30pm'.
 */
@property (nonatomic, copy) NSString *liveTimeRangeText;


/**
 Readonly property that indicates if the given metadata info allows the info panel view to be
 set in the video controls.
 */
@property (nonatomic, readonly) BOOL hasContentForInfoPanel;


#pragma mark Methods

/**
 Add a custom metadata group to be displayed in the info panel view.
 
 This allows you to specify arbitrary sections in the info panel with a title (groupTitle argument)
 and the content that goes below the section title (description argument).
 
 @param groupTitle
    The title that is displayed at the start of the custom metadata group.
 @param description
    The custom string content that should be displayed in the custom metadata group.
 */
- (void)addMetadataGroup:(NSString *)groupTitle
             description:(NSString *)description;

@end


#pragma mark - Interface BMPlayerMetadataGroup

@interface BMPlayerMetadataGroup : NSObject

#pragma mark Properties

/** The player metadata group title. */
@property (nonatomic, readonly, copy) NSString *title;


/** The player metadata group description title. */
@property (nonatomic, readonly, copy) NSString *descriptionText;


#pragma mark Methods

/**
 Initializer of BMPlayerMetadataGroup class with title and description.
 
 @param title
    The metadata group title.
 @param description
    The metadata group description.
 
 @return
    An instance type of BMPlayerMetadataGroup class.
*/
- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description;

@end

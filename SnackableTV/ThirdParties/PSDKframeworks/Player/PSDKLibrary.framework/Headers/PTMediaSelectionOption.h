/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

//
//  PTMediaSelectionOption.m
//  MediaPlayer
//
//  Created by Jesus Figueroa on 1/29/13.
//

#import <Foundation/Foundation.h>

/**
 * These enumeration values define the type of a PTMediaSelectionOption instance.
 */
typedef NS_ENUM(NSInteger,PTMediaSelectionOptionType)
{
    /** Media selection option undefined. */
    PTMediaSelectionOptionTypeUndefined,

    /** Media selection option of type subtitle. */
    PTMediaSelectionOptionTypeSubtitle,
    
    /** Media selection option of type audio. */
    PTMediaSelectionOptionTypeAudio
};

/**
 * PTMediaSelectionOption class represents an audiovisual media resource to accommodate different language preferences, accessibility requirements or custom application configurations
 * There are 2 possible types of PTMediaSelectionOption: Subtitles and Alternate Audio.
 */

@interface PTMediaSelectionOption : NSObject

/** @name Properties */
/**
 * Returns the id of the option
 */
@property (readonly, retain) NSString* optionId;

/** @name Properties */
/**
 * Title of the media option.
 */
@property (readonly, retain) NSString *title;

/** @name Properties */
/**
 * Indicates the locale of the media option.
 */
@property (readonly, retain) NSLocale *locale;

/** @name Properties */
/**
 * Returns YES if the option is of type forced.
 * Forced atribute only applies to PTMediaSelectionOption of type PTMediaSelectionOptionTypeSubtitle
 * Forced options are automatically selected by the player if the locale is the current language.
 */
@property (readonly, assign) BOOL forced;

/** @name Properties */
/**
 * Returns YES if the option is currently selected.
 */
@property (readonly, assign) BOOL selected;

/** @name Properties */
/**
 * Returns YES if the option is the default for the current item.
 */
@property (readonly, assign) BOOL isDefault;

/** @name Properties */
/**
 * Returns the type of the media option.
 * Types: PTMediaSelectionOptionTypeUndefined, PTMediaSelectionOptionTypeSubtitle, PTMediaSelectionOptionTypeAudio
 */
@property (readonly, assign) PTMediaSelectionOptionType type;

#pragma mark -
#pragma mark Constant media options

/** @name Constant media option */
/**
 * Returns a constant that the PTMediaPlayerItem understands for selecting its current default option.
 * THIS IS NOT THE DEFAULT OPTION ITESELF.
 */
+ (PTMediaSelectionOption *) defaultOption;

/** @name Constant media option */
/**
 * Returns a constant that the PTMediaPlayerItem understands for selecting none option.
 * For type PTMediaSelectionOptionTypeSubtitle the empty option is no subtitles track at all (not even forced).
 * For type PTMediaSelectionOptionTypeAudio the empty option is the audio stream embeded in the video stream.
 */
+ (PTMediaSelectionOption *) emptyOption;

@end
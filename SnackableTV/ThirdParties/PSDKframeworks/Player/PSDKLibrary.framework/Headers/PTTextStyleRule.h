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
//  PTTextStyleRule.h
//  MediaPlayer
//
//  Created by Prerna Vij on 1/25/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  A PTTextStyleRule object represents text styling rules that can be applied to text in a media item. 
 *  The text style objects can be used to format subtitles, closed captions, and other text-related content of the item. 
 *  The specified rules can be applied to all or part of the text in the media item.
 *
 **/


/**
 * These enumeration values define text style attribute keys that form the dictionary of rules.
 */
typedef NS_ENUM(NSInteger,TextStyleRuleKey)
{
    /** Text style rule for background color. */
    kTextStyleKey_BackgroundColorARGB = 0,
    
    /** Text style rule for foreground color. */
    kTextStyleKey_ForegroundColorARGB,
    
    /** Text style rule for font family. */
    kTextStyleKey_FontFamilyName,
    
    /** Text style rule for bold style. */
    kTextStyleKey_BoldStyle,
    
    /** Text style rule for italic style. */
    kTextStyleKey_ItalicStyle,
    
    /** Text style rule for underline style. */
    kTextStyleKey_UnderlineStyle,
    
    /** Text style rule for relative font size. */
    kTextStyleKey_RelativeFontSize
};

@interface PTTextStyleRule : NSObject

/** @name backgroundColor */
/**
 * The background color for the shape holding the text.
 * Value is an NSArray of 4 NSNumbers representing A, R, G, and B fields with values between 0 and 1.0.
 */
@property (nonatomic, retain) NSArray *backgroundColor;

/** @name foregroundColor */
/**
 * The foreground color of the text.
 * Value is an NSArray of 4 NSNumbers representing A, R, G, and B fields with values between 0 and 1.0.
 */
@property (nonatomic, retain) NSArray *foregroundColor;

/** @name bold */
/**
 * Boolean representing the bold style setting of the text.
 * Default value is No.
 */
@property (nonatomic, assign) BOOL bold;

/** @name italic */
/**
 * Boolean representing the italic style setting of the text.
 * Default value is No.
 */
@property (nonatomic, assign) BOOL italic;

/** @name underLine */
/**
 * Boolean representing the underline style setting of the text.
 * Default value is No.
 */
@property (nonatomic, assign) BOOL underLine;

/** @name font */
/**
 * NSString representing the name of the text font.
 * Value is an NSString holding the family name of font set.
 * (e.g., "Helvetica")
 */
@property (nonatomic, retain) NSString *font;

/** @name size */
/**
 * The font size expressed as a percentage of the current default font size.
 * Value returned is a non negative CFNumber holding the current percentage
 * of the size of the calculated default font size.  A value
 * of 120 indicates 20% larger than the default font size. A value of 80
 * indicates 80% of the default font size.  The value 100 indicates no size
 * difference and is the default.
 */
@property (nonatomic, retain) NSNumber *size;

/** @name Setting Text Style Rules */
/**
 * Creates a new TextStyleRule dictionary.
 * @param combinedRules A dictionary of style attributes with TextStyleRuleKey keys and corresponding values.
 *
 *  Key                                                 Value Expected
 *
 *  kTextStyleKey_BackgroundColorARGB              NSArray of 4 NSNumber representing A, R, G, and B fields with values
 *                                                 between 0 and 1.0.
 *
 *  kTextStyleKey_ForegroundColorARGB              NSArray of 4 NSNumber representing A, R, G, and B fields with values
 *                                                 between 0 and 1.0.
 *
 *  kTextStyleKey_FontFamilyName                   NSString holding the family name of an installed font
 *                                                 (e.g., "Helvetica") that is used to render and/or measure text.
 *
 *  kTextStyleKey_BoldStyle                        BOOL. Default value is NO. If this attribute is YES, the text will be
 *                                                 rendered with a bold style.
 *
 *  kTextStyleKey_ItalicStyle                      BOOL. Default value is NO. If this attribute is YES, the text will be
 *                                                 rendered with an italic style.
 *
 *  kTextStyleKey_UnderlineStyle                   BOOL. Default value is NO. If this attribute is YES, the text will be
 *                                                 rendered with an underline style.
 *
 *  kTextStyleKey_RelativeFontSize                 Value must be a non-negative NSNumber. This is a number holding a 
 *                                                 percentage of the size of the calculated default font size.  A value
 *                                                 of 120 indicates 20% larger than the default font size. A value of 80
 *                                                 indicates 80% of the default font size.  The value 100 indicates no size
 *                                                 difference and is the default.
 *
 * @param textSelector  A string containing an identifier for the ranges of text to which the style attributes
                        should be applied. Eligible identifiers are determined by the media format and its corresponding
                        text content. For example, the string could contain the CSS selectors used by the corresponding 
                        text in Web Video Text Tracks (WebVTT) markup. 
                        
                        Specify nil if you want the style attributes to apply to all text in the item
 */
- (void) setTextStyleRulesDictionary: (NSDictionary*)combinedRules textSelector:(NSString*)textSelector;


/** @name Undo Text Style Rule For a Key */
/**
 * Resets text style to default settings for the given key.
 * Keys: kTextStyleKey_BackgroundColorARGB (Default), kTextStyleKey_ForegroundColorARGB, kTextStyleKey_FontFamilyName, kTextStyleKey_BoldStyle,
         kTextStyleKey_ItalicStyle, kTextStyleKey_UnderlineStyle, kTextStyleKey_RelativeFontSize
 */
- (void) deleteTextStyleRuleForKey: (TextStyleRuleKey) textStyleKey;

/** @name Resetting Text Style Rules */
/**
 * Resets text style to default settings. Erases all custom settings set via setTextStyleRulesDictionary method.
 */
- (void) resetToDefaultTextStyleSettings;

@end
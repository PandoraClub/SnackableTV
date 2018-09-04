/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
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
//  PTAd.h
//
//  Created by Catalin Dobre on 3/25/12.
//

#import "PTAdAsset.h"

/**
 * These enumeration values define the type of an ad instance.
 */
typedef NS_ENUM(NSInteger, PTAdType)
{
    /** To mark an ad of regular type. */
    PTAdTypeRegular,
    
    /** To mark an ad of type C3. This needs C3 ad ranges. */
    PTAdTypeC3,
	
	/** To mark an ad of custom type. */
	PTAdTypeCustom
};

/**
 * The PTAd instance represents a primary linear asset spliced into the content. It can optionally contain an array
 * of companion assets that must be displayed along with the linear asset.
 */
@interface PTAd : NSObject

/** @name Properties */
/**
 * Returns the id of the ad.
 */
@property (retain, nonatomic) NSString *adId;

/** @name Properties */
/**
 * Returns the index of the ad within the ad break starting with 0.
 */
@property (nonatomic, assign) NSInteger index;

/** @name Properties */
/**
 * Returns the primary linear asset associated with this ad
 */
@property (retain, nonatomic) PTAdAsset *primaryAsset;

/** @name Properties */
/**
 * Returns an array of companion banner assets associated with this ad.
 */
@property (retain, nonatomic) NSArray *companionAssets;

/** @name Properties */
/**
 * Returns the data of the ad.
 */
@property (retain, nonatomic) NSDictionary *data;

/** @name Properties */
/**
 * Returns the custom data of the ad.
 */
@property (retain, nonatomic) NSDictionary *customData;

/** @name Properties */
/**
 * Returns the type of this ad (regular, c3 etc)
 * Types: PTAdTypeRegular, PTAdTypeC3
 */
@property (nonatomic) PTAdType type;



@end

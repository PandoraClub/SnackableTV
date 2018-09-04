//
//  PTDeviceInformation.h
//  MediaPlayer
//
//  Created by Prerna Vij on 1/15/13.
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

#import <Foundation/Foundation.h>
/**
 * PTDeviceInformation holds QOS information related to the device.
 */

@interface PTDeviceInformation : NSObject

/** @name os */
/**
 * The name of the operating system running on the device represented by the receiver. (read-only) 
 */
@property (readonly, nonatomic) NSString *os;

/** @name model */
/**
 * The model of the device. Possible examples of model strings
 * are @”iPhone” and @”iPod touch”.(read-only)
 */
@property (readonly, nonatomic) NSString *model;

/** @name id */
/**
 * An alphanumeric string that uniquely identifies a device to the app’s vendor. (read-only)
 */
@property (readonly, nonatomic) NSUUID *id;

@end

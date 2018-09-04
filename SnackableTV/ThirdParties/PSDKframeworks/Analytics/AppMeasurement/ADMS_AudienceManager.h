//
//  ADMS_AudienceManager.h
//  Adobe Digital Marketing Suite -- iOS Audience Manager Library
//
//  Copyright 1996-2013. Adobe, Inc. All Rights Reserved

#import <Foundation/Foundation.h>

@interface ADMS_AudienceManager : NSObject 

#pragma mark - getters/setters
+ (NSDictionary *) visitorProfile;

+ (NSString *) dpuuid;
+ (NSString *) dpid;
+ (void) setDpid:(NSString *)newDpid dpuuid:(NSString *)newDpuuid;

+ (void) configureAudienceManager:(NSString *)server;
+ (bool) isConfigured;

+ (void) submitSignal:(NSDictionary *)data callback:(void(^)(NSDictionary *))callback;

@end

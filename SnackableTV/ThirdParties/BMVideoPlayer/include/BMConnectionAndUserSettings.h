//
//  BMConnectionAndUserSettings.h
//  BMAdobePlayer
//
//  Created by John Cebasek on 2016-05-31.
//  Copyright © 2016 Bell Media. All rights reserved.
//

#ifndef BMConnectionAndUserSettings_h
#define BMConnectionAndUserSettings_h

typedef NS_ENUM(NSInteger, BMConnectionType)
{
    kBMConnectionTypeNone = 0,
    kBMConnectionTypeWifi = 1,
    kBMConnectionTypeWWAN = 2
};

typedef NS_ENUM(NSInteger, BMUserSetting)
{
    kBMUserSettingNotApplicable = 0,
    kBMUserSettingWifi = 1,
    kBMUserSettingWifiAndWWAN
};

#endif /* BMConnectionAndUserSettings_h */

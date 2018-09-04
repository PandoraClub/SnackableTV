//
//  BMVideoCompanion.h
//  BMVideoCompanion
//
//  Created by John Cebasek on 2015-09-16.
//  Copyright (c) 2015 Bell Media. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *kBMURLResponseErrorTextKey;
FOUNDATION_EXPORT NSString *kBMURLResponseStatusCode;

typedef void(^BMExtraDataRetrievalSuccess)(NSArray *jsonArray);
typedef void(^BMExtraDataRetrievalFailure)(NSError *retrievalError);

@interface BMVideoRelatedDataProvider : NSObject

- (instancetype)initWithContentID:(NSString *)contentID forBrand:(NSString *)brandId;

- (void)relatedContentForVideo:(BMExtraDataRetrievalSuccess)success failure:(BMExtraDataRetrievalFailure)failure;


@end

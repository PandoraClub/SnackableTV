//
//  BMDataParser.h
//  BMVideoCompanion
//
//  Created by Jorge Valbuena on 2015-12-02.
//  Copyright © 2015 Bell Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMPlayerEndPlayData;

@interface BMDataParser : NSObject

/**
 Tells if the parser is parsing the data.
 */
@property (nonatomic, assign, readonly) BOOL isParsing;


/**
 Holds the parser dictionary.
 */
@property (nonatomic, strong, readonly) NSDictionary *dictionary;


/**
 Custom initializer which takes an @NSDictionary to be parse with @BMPlayerEndPlayData.
 
 @param dictionary
    The @NSDictionary to be parsed.
 
 @return
    An instancetype of @BMDataParser.
 */
+ (BMDataParser *)parserWithDictionary:(NSDictionary *)dictionary;


/**
 Loads the general content with image url, title, subtitle, description and guid.
 
 @param dictionary
    The dictionary containing all the content to load.
 
 @return
    An instancetype of @BMPlayerEndPlayData.
 */
- (BMPlayerEndPlayData *)loadContentWithDictionary:(NSDictionary *)dictionary;


/**
 Tells the parser to parse the data.
 
 @return
    The parsed data.
 */
- (BMPlayerEndPlayData *)parse;

@end

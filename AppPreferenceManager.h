//
//  AppPreferenceManager.h
//  ListingTemplate
//
//  Created by Ashok Matoria on 17/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>

// Each enum value representing configuration file.
typedef enum {
	AppPreferenceMain
} AppPreferenceType;

#define kAppPreferenceKey_StartWithLogin @"StartApplicationOnLogin"

@interface AppPreferenceManager : NSObject {
	NSDictionary *preferenceData;
}

// class methods
+ (NSString *)fileNameFromType:(AppPreferenceType)fileType;

// instance menthods
- (id)initWithFileType:(AppPreferenceType)fileType;
- (id)valueForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

@end

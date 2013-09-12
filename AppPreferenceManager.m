//
//  AppPreferenceManager.m
//  ListingTemplate
//
//  Created by Ashok Matoria on 17/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppPreferenceManager.h"

@implementation AppPreferenceManager

+ (NSString *)fileNameFromType:(AppPreferenceType)fileType {
	NSString *fileName = nil;

	if (fileType == AppPreferenceMain) {
		fileName = @"AppPreference.plist";
	}

	return fileName;
}

- (id)initWithFileType:(AppPreferenceType)fileType {
	self = [super init];

	if (self) {
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *fileName = [AppPreferenceManager fileNameFromType:fileType];
		NSString *resourcePath = [path stringByAppendingPathComponent:@"Contents"];
		NSString *resourcePath2 = [resourcePath stringByAppendingPathComponent:@"Resources"];
		NSString *dataPath = [resourcePath2 stringByAppendingPathComponent:fileName];

		preferenceData = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
	}

	return self;
}

- (id)valueForKey:(NSString *)key {
	return [preferenceData valueForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
	// TODO ashok_matoria : Ensure to keep a copy of the preference file to user area and modify that file.
	id value = [preferenceData valueForKey:key];

	if ([key isEqual: kAppPreferenceKey_StartWithLogin] && [value boolValue] != [object boolValue]) {
		NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithDictionary:preferenceData];

		[newDictionary setObject:object forKey:kAppPreferenceKey_StartWithLogin];
		[preferenceData release];
		preferenceData = [newDictionary copy];
		[newDictionary release];
	}
}
- (void)dealloc {
	[preferenceData release];
	
	[super dealloc];
}

@end

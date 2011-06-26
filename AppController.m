//
//  AppController.m
//  MenuletTicket
//
//  Created by Ashok Matoria on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "AppPreferenceManager.h"

@interface AppController (PrivateMethods)
- (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(NSString *)appPath;
- (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(NSString *)appPath;
- (BOOL)loginItemExistsWithLoginItemReference:(LSSharedFileListRef)theLoginItemsRefs ForPath:(NSString *)appPath;
- (void)addRemoveAppToLoginItem:(BOOL)addInLoginList;
@end

@implementation AppController

- (void) awakeFromNib{
	
	//Create the NSStatusBar and set its length
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	//Used to detect where our files are
	NSBundle *bundle = [NSBundle mainBundle];
	
	//Allocates and loads the images into the application which will be used for our NSStatusItem
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon" ofType:@"png"]];
	statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon-alt" ofType:@"png"]];
	
	//Sets the images in our NSStatusItem
	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusHighlightImage];
	
	//Tells the NSStatusItem what menu to load
	[statusItem setMenu:statusMenu];
	//Sets the tooptip for our item
	[statusItem setToolTip:@"My Custom Menu Item"];
	//Enables highlighting
	[statusItem setHighlightMode:YES];
	
	AppPreferenceManager *appPreference = [[AppPreferenceManager alloc] initWithFileType:AppPreferenceMain];

	BOOL startOnLogin = [[appPreference valueForKey:kAppPreferenceKey_StartWithLogin] boolValue];

	[self addRemoveAppToLoginItem:startOnLogin];
	[appPreference release];
}

- (void) dealloc {
	//Releases the 2 images we loaded into memory
	[statusImage release];
	[statusHighlightImage release];
	[super dealloc];
}

- (void)addRemoveAppToLoginItem:(BOOL)addInLoginList {
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
	
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	if (loginItems) {
		if (addInLoginList)
			[self enableLoginItemWithLoginItemsReference:loginItems ForPath:appPath];
		else
			[self disableLoginItemWithLoginItemsReference:loginItems ForPath:appPath];
	}
	CFRelease(loginItems);
}

-(IBAction)setTicket:(id)sender{
	NSLog(@"Hello there!");
//
//    NSString *bringAppToFrontScript = @"\
//	tell application \"Safari\"\n\
//	activate\n\
//	end tell";
//	
//    NSDictionary* errorDict;
//    NSAppleEventDescriptor *returnDescriptor = NULL;
//    NSAppleScript* scriptObject = [[NSAppleScript alloc]
//								   initWithSource:bringAppToFrontScript];
//    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
//    [scriptObject release];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://google.com/"]];
}
- (IBAction)launchAtLogin:(id)sender {
	NSMenuItem *launchAtLoginMenuItem = (NSMenuItem *)sender;
	NSInteger state = [launchAtLoginMenuItem state];
	BOOL addAppToLoginItemList = NO;

	if (state == 1) {
		addAppToLoginItemList = NO;
		[launchAtLoginMenuItem setState:0];
	}
	else {
		addAppToLoginItemList = YES;
		[launchAtLoginMenuItem setState:1];
	}

	AppPreferenceManager *appPreference = [[AppPreferenceManager alloc] initWithFileType:AppPreferenceMain];

	[appPreference setObject:[NSNumber numberWithBool:addAppToLoginItemList] forKey:kAppPreferenceKey_StartWithLogin];
	[appPreference release];

	[self addRemoveAppToLoginItem:addAppToLoginItemList];

	NSLog(@"menu state = %d", state);
}

- (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(NSString *)appPath {
	// We call LSSharedFileListInsertItemURL to insert the item at the bottom of Login Items list.
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:appPath];
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRefs, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);		
	if (item)
		CFRelease(item);
}

- (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(NSString *)appPath {
	UInt32 seedValue;
	CFURLRef thePath;
	// We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
	// and pop it in an array so we can iterate through it to find our item.
	CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
	for (id item in (NSArray *)loginItemsArray) {		
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
			if ([[(NSURL *)thePath path] hasPrefix:appPath]) {
				LSSharedFileListItemRemove(theLoginItemsRefs, itemRef); // Deleting the item
			}
			// Docs for LSSharedFileListItemResolve say we're responsible
			// for releasing the CFURLRef that is returned
			CFRelease(thePath);
		}		
	}
	CFRelease(loginItemsArray);
}

- (BOOL)loginItemExistsWithLoginItemReference:(LSSharedFileListRef)theLoginItemsRefs ForPath:(NSString *)appPath {
	BOOL found = NO;  
	UInt32 seedValue;
	CFURLRef thePath;
	
	// We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
	// and pop it in an array so we can iterate through it to find our item.
	CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
	for (id item in (NSArray *)loginItemsArray) {    
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
			if ([[(NSURL *)thePath path] hasPrefix:appPath]) {
				found = YES;
				break;
			}
		}
		// Docs for LSSharedFileListItemResolve say we're responsible
		// for releasing the CFURLRef that is returned
		CFRelease(thePath);
	}
	CFRelease(loginItemsArray);
	
	return found;
}
@end

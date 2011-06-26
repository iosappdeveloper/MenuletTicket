//
//  AppController.h
//  MenuletTicket
//
//  Created by Ashok Matoria on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSMenu *statusMenu;
	
	NSStatusItem *statusItem;
	NSImage *statusImage;
	NSImage *statusHighlightImage;
}

- (IBAction)setTicket:(id)sender;
- (IBAction)launchAtLogin:(id)sender;

@end

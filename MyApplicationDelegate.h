//
//  MyApplicationDelegate.h
//  Disassembletron
//
//  Created by Michael Lamb on 8/10/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "Disassembletron.h"
#import <Cocoa/Cocoa.h>
#import "PluginManager.h"


@interface MyApplicationDelegate : NSObject 
{
	PluginManager* _thePluginManager;
	NSWindowController *preferencesController;
}

@property (nonatomic, retain) NSWindowController *preferencesController;

-(BOOL) applicationShouldOpenUntitledFile:(NSApplication*) sender;
-(void) applicationDidFinishLaunching:(NSNotification*) aNotification;
-(IBAction) showPrefs: sender;	

@end

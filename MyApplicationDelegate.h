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
#import "PreferencesController.h"


@interface MyApplicationDelegate : NSObject <NSToolbarDelegate>
{
	PluginManager* _thePluginManager;
	PreferencesController* preferencesController;
}

@property (nonatomic, retain) PreferencesController *preferencesController;

-(BOOL) applicationShouldOpenUntitledFile:(NSApplication*) sender;
-(void) applicationDidFinishLaunching:(NSNotification*) aNotification;
-(IBAction) showPrefs: sender;
-(IBAction) openDocument: sender;
@end

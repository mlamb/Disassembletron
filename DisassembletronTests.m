//
//  DisassembletronTests.m
//  Disassembletron
//
//  Created by Michael Lamb on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <AppKit/NSApplication.h>
#import "DisassembletronTests.h"
#import "PluginManager.h"
#import "MyApplicationDelegate.h"


@implementation DisassembletronTests

-(void) setUp 
{
	appDelegate = [[NSApplication sharedApplication] delegate];
	STAssertNotNil(appDelegate, @"Cannot find the application delegate");
	_pluginManager = [PluginManager sharedInstance];
}

-(void) tearDown
{
  // nop
}

-(void) test_AppDelegateMethods {
	STAssertNotNil(appDelegate, @"Cannot find the application delegate");
	STAssertTrue([appDelegate isKindOfClass:[MyApplicationDelegate class]],@"appDelegate is not an MyApplicationDelegate class");
	STAssertTrue(NO == [appDelegate applicationShouldOpenUntitledFile:[NSApplication sharedApplication]], @"Application will not open untitled document");
	STAssertTrue([appDelegate respondsToSelector:@selector(applicationDidFinishLaunching:)],@"Application doesn't respond to applicationFinishLaunching");
}

-(void) test_sharedPlugin_SharedInstance
{
	PluginManager* _anotherPluginManager = [PluginManager sharedInstance];
	
	STAssertNotNil(_pluginManager,@"Could not create instance of PluginManager.");	
	STAssertEquals(_pluginManager,_anotherPluginManager,@"Plugins are equal");
}

-(void) DISABLED_test_sharedPlugin_PluginClasses
{
	STAssertTrue([_pluginManager._pluginClasses count] > 0,@"Plugins greater than 0");
	STAssertTrue([_pluginManager._pluginClasses isKindOfClass:[NSArray class]],@"Plugin classes is not a NSArray");
	//STAssertTrue([_pluginManager._pluginClasses isKindOfClass:[NSMutableDictionary class]],@"Plugin classes is not a NSArray");
}


-(void) DISABLED_test_sharedPlugin_ActivatePlugin {
	NSUInteger count = [_pluginManager._pluginClasses count];
	// TODO: replace this with relative (or at least not specific to my home directory) paths
	[_pluginManager activatePlugin:@"/Users/Mlamb/Disassembletron/build/Debug/Disassembletron.app/Contents/PlugIns/Application Plug-in.plugin"];
	NSUInteger newCount = [_pluginManager._pluginClasses count];
	STAssertTrue( newCount > count,@"activatePlugin did not add the plugin. newcount = %i count = %i", newCount, count);
}

-(void) test_sharedPlugin_PluginPathsForDirectoriesInDomains {
	// TODO: replace this with relative (or at least not specific to my home directory) paths
	NSArray *goodpluginPaths = [[NSArray alloc] initWithObjects:@"/Users/Mlamb/Library/Application Support/Disassembletron/PlugIns", @"/Library/Application Support/Disassembletron/PlugIns", @"/Network/Library/Application Support/Disassembletron/PlugIns", @"/Users/Mlamb/Disassembletron/build/Debug/Disassembletron.app/Contents/PlugIns",nil];
	NSArray* pluginPaths = [[_pluginManager pluginPathsForDirectoriesInDomains] retain];
	STAssertTrue([pluginPaths isEqualToArray:goodpluginPaths],@"pluginPathsForDirectoriesInDomains returned a different list of plugin paths %@ %@",pluginPaths,goodpluginPaths);

	[pluginPaths release];
	[goodpluginPaths release];
}
	

-(void) testToolbar {
	
	NSDocumentController* documentController = [NSDocumentController sharedDocumentController];
	
	// newDocument calls openUntitledDocumentAndDisplay:error
	// default implementation of openUntitledDocumentAndDisplay:error uses documentClassForType (which gets correct class from info.plist) to create a new NSDocument sub-class object, it then sends makeWindowControllers to the new object
	// default implementation of makeWindowControllers uses windowNibName to determine which NIB to load, so that it can set the correct delegate, file's owner, etc
	[documentController newDocument:self];
	
	//now that we have a document created, and added to the documentController, get its (via the collection)
	NSArray* documents = [documentController documents];
	
	
	for (id object in documents) {
		//now that we have the document, get its windowController (via the collection)
		NSArray* arrayControllers = [object windowControllers];
		for (id window in arrayControllers) {
			//now that we have the windowController, get its window
			id theWindow = [window window];
			//now that we have the window, check that it has a toolbar
			STAssertNotNil([theWindow toolbar],@"toolbar is nil");
			STAssertTrue([[theWindow toolbar] isKindOfClass:[NSToolbar class]],@"toolbar is not a toolbar");
		}
	}
	
	
}

@end

//
//  MyDocument.m
//  Disassembletron
//
//  Created by Michael Lamb on 8/10/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "PluginManager.h"
#import "CodeParser.h"
#import "MyDocument.h"

@implementation MyDocument


#pragma mark -
#pragma mark NSDocument delegate methods
-(id) init
{
    self = [super init];
    if (self) 
	{
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}



-(NSString*) windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

-(void) windowControllerDidLoadNib:(NSWindowController*) aController
{
    [super windowControllerDidLoadNib:aController];
	
	// TODO: Move toolbar into it's own class?
	
	// create the toolbar object
    NSToolbar* toolbar = [[NSToolbar alloc] initWithIdentifier:@"MySampleToolbar"];
	
    // set initial toolbar properties
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
	
    // set our controller as the toolbar delegate
    [toolbar setDelegate:self];
	
    // attach the toolbar to our window
    [[aController window] setToolbar:toolbar];
	
    // clean up
    [toolbar release];
	
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
} 

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	// if this is a core data file (i.e. a "project" file) ... 
	// then we need to call [NSPersistentDocument configurePersistentStoreCoordinatorForURL:ofType:modelConfiguration:storeOptions:error:] 
	// and instantiate the manged object context with whatever needs to be there 

	// if it's not, then open it as a regular NSDocument (create a NSFileWrapper and call readFromFileWrapper)
	NSFileWrapper *theFileWrapper = [[NSFileWrapper alloc] initWithURL:absoluteURL options: (NSFileWrapperReadingImmediate && NSFileWrapperReadingWithoutMapping) error:outError];
	[self readFromFileWrapper:theFileWrapper ofType:typeName error:outError];
	
    								 
	if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.
	
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    char buffer[5];
	
	
	[[data subdataWithRange:NSMakeRange(0,4)] getBytes: buffer];
	buffer[4] = '\0';
	
	// buffer now has \xca\xfe\xba\xbe
	// check to see if this is a fat binary, and proceed.
	NSLog(@"%s",buffer);
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}


-(NSData*) dataOfType:(NSString*) typeName error:(NSError **) outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) 
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}


-(BOOL) readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError
{
	NSString *fileType = nil;
	
	if ([fileWrapper isDirectory]) {
		// TODO: if the file is a directory, check to see it's an app, and open the info dict to find the main executable, and open that.
		if ([typeName compare:@"com.apple.application-bundle"] == NSOrderedSame || [typeName compare:@"com.apple.framework"] == NSOrderedSame) {
			fileType = [typeName stringByAppendingFormat:@" %@", @"BUNDLE FOUND!"];
		} else {
			fileType = typeName;
		}

	}
	if ([fileWrapper isRegularFile]) {
		// if the file is a regular file, open it up directly
		fileType = [typeName stringByAppendingFormat:@" %@", @"RegularFile"];
	}
	
	Plugin* thePlugin = [[PluginManager sharedInstance] pluginForFileType: fileType];
	
	/*id plugins;
	
	plugins = [[PluginManager sharedInstance].plugins objectForKey:@"CodeParser"];
	
	

	if ([[[[plugins objectAtIndex:0] _PluginPrincipalClass] registerFileTypesHandled] containsObject:typeName]) {
			id pluginInstance = [[[[[plugins objectAtIndex:0] _PluginPrincipalClass] alloc] init] autorelease];
			DebugLog(@"%@",pluginInstance);
		} 
	

	*/
	DebugLog(@"plugin = %@" , thePlugin); 
	
	[self readFromData:[fileWrapper regularFileContents] ofType:typeName error:outError];
	
	if (outError != NULL) 
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}


#pragma mark -
#pragma mark NSToolbar delegate methods

// TODO: move these into a toolbar manager class so that plugins can add themselves to the toolbar

-(NSToolbarItem*) toolbar:(NSToolbar*) toolbar itemForItemIdentifier:(NSString*) itemIdentifier willBeInsertedIntoToolbar:(BOOL) flag 
{
	NSToolbarItem* toolbarItem = nil;
	
    if ([itemIdentifier isEqualTo:ToolbarIdentifier]) 
	{
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [toolbarItem setLabel:@"Save"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Save"];
        //[toolbarItem setImage:[NSImage imageNamed:@"save.png"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(save:)];
    } 
	
    return [toolbarItem autorelease];
}

-(NSArray*) toolbarAllowedItemIdentifiers:(NSToolbar*) toolbar 
{
	return [NSArray arrayWithObjects:ToolbarIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier, 
			NSToolbarSpaceItemIdentifier, 
			NSToolbarSeparatorItemIdentifier, nil];
}

-(NSArray*) toolbarDefaultItemIdentifiers:(NSToolbar*) toolbar 
{
	return [NSArray arrayWithObjects:ToolbarIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier, 
			nil];
}

@end

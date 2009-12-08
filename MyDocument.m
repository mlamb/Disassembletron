//
//  MyDocument.m
//  Disassembletron
//
//  Created by Michael Lamb on 8/10/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "PluginManager.h"
#import "MyDocument.h"


@implementation MyDocument


#pragma mark -
#pragma mark NSDocument delegate methods
- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	// TODO: Move toolbar into it's own class?
	
	// create the toolbar object
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"MySampleToolbar"];
	
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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

#pragma mark -
#pragma mark NSToolbar delegate methods

// TODO: move these into a toolbar manager class so that plugins can add themselves to the toolbar

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSToolbarItem *toolbarItem = nil;
	
    if ([itemIdentifier isEqualTo:ToolbarIdentifier]) {
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

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:ToolbarIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier, 
			NSToolbarSpaceItemIdentifier, 
			NSToolbarSeparatorItemIdentifier, nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:ToolbarIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier, 
			nil];
}

@end

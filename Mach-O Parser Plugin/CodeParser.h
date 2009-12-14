//
//  CodeParser.h
//  Disassembletron
//
//  Created by Michael Lamb on 11/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol CodeParser

//	initializeClass: is called once when the plug-in is loaded. The plug-in's bundle is passed
//	as argument; the plug-in could discover its own bundle again, but since we have it available
//	anyway when this is called, this saves some time and space.
//	In a real implementation, we might also pass a NSDictionary with the appropriate preferences.
//	This method should do all global plug-in initialization, such as loading preferences; if
//	initialization fails, it should return NO, and the plug-in won't be called again.

// TODO: investigate handing off an NSData object to the CodeParser so that it can get byte specific data.  (not sure if this should be in initialize, or parse though.
+ (BOOL)initializeClass:(NSBundle*)theBundle; //withData:(NSData*);


// registerFileTypesHandled: is called during plugin discovery to register the file types that 
// this plugin can handle this is called so that dataOfType:error and readFromData:error know 
// to hand off parsing to this plugin
+ (NSArray*) registerFileTypesHandled;

@optional
// parse parses the file into it's component parts.  Is called after file is opened
- (BOOL) parse;

// accessors for the respective parts of a binary
- (NSArray*) getSegments;
- (NSArray*) getSections;
- (NSArray*) getSymbols;

// accessors for arbitrary memory locations  (may not be needed)  TODO: decide on "ForMemory" vs "ForAddress" vs "ForMemoryAddress" or maybe even "ForVMAddress"
- (id) getSegmentForMemory:(id) address;
- (id) getSectionForAddress:(id) address;
- (id) getSymbolForMemoryAddress:(id) address;



//	terminateClass is called once when the plug-in won't be used again. 
+ (void)terminateClass;


@end

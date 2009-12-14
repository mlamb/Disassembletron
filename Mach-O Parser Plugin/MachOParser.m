//
//  MachOParser.m
//  Mach-O Parser Plugin
//
//  Created by Michael Lamb on 12/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MachOParser.h"


@implementation MachOParser

+ (NSArray*) registerFileTypesHandled {
	return [[[NSArray alloc] init] retain];
}

+ (BOOL) initializeClass:(NSBundle *)theBundle {
	return YES;
}


@end

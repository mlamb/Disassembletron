//
//  MyDocument.h
//  Disassembletron
//
//  Created by Michael Lamb on 8/10/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

static NSString* ToolbarIdentifier = @"ToolBarIdentifier";

@interface MyDocument : NSDocument <NSToolbarDelegate>
{
	//IBOutlet NSWindow *window;
}
@end

//
//  MyDocument.h
//  Disassembletron
//
//  Created by Michael Lamb on 8/10/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "Disassembletron.h"
#import <Cocoa/Cocoa.h>

static NSString* ToolbarIdentifier = @"DAToolBarIdentifier";

@interface MyDocument : NSDocument <NSToolbarDelegate>
{
	//IBOutlet NSWindow *window;
}
@end

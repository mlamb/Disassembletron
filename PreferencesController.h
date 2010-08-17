//
//  PreferencesController.h
//
//  Created by Michael Lamb on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController {
    IBOutlet NSToolbar *theToolbar;
}

@property (nonatomic, retain) NSToolbar* theToolbar;
@end

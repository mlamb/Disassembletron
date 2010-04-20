/*
 *  Disassembletron.h
 *  Disassembletron
 *
 *  Created by Michael Lamb on 4/16/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#define DEBUG TRUE

#if DEBUG
#define	DebugLog(args...)			NSLog(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])
#else
#define	DebugLog(args...)			// stubbed out
#endif
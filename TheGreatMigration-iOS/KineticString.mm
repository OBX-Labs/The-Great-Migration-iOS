//
//  KineticString.mm
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KineticString.h"


@implementation KineticString

@synthesize parent, group, string;

-(id)initWithString:(NSString*) s
{
    self = [super init];
    if (self) {
        string = s;
    }
    return self;
}

@end

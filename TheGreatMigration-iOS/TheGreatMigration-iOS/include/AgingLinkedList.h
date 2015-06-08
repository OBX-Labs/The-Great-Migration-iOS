//
//  AgingLinkedList.h
//  TheGreatMigration-iOS
//
//  Created by c-a on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KineticObject.h"
#import "CHDataStructures.h"

@interface AgingLinkedList: NSObject
{    
    CHSinglyLinkedList *theList;      //list of objects
    CHSinglyLinkedList *recycledList; //list of recycled objects
    float death;              //time in millis when objects die 

    KineticObject *tmpObj;
}
    
//constructor
-(id)initWithDuration:(float) death;
    
//add an object
-(void)add:(KineticObject*)obj;
    
//update the list and its objects
-(void) update:(float)dt;

//get a recycled object if any
-(KineticObject*)recycle;

//get the number of objects in the list
-(int)count;

//get the object enumerator for the list
-(NSEnumerator*)objectEnumerator;

@end

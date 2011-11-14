//
//  WSContent.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSContent.h"


@implementation WSContent

@synthesize ArtistName;
@synthesize SynopsisEnglish,SynopsisFrench;
@synthesize License;
@synthesize DataLocation;
@synthesize MIMEType;
@synthesize TitleEnglish,TitleFrench;



-(void)dealloc{
    [self.ArtistName release];
    [self.SynopsisEnglish release];
    [self.SynopsisFrench release];
    [self.License release];
    [self.DataLocation release];
    [self.MIMEType release];
    [self.TitleEnglish release];
    [self.TitleFrench release];
    [super dealloc];
}

-(id) initWithDictionary:(NSDictionary *) contentDict{
    self=[super init];
    if (self) {
        self.ArtistName = [[contentDict valueForKey:@"ArtistName"] description];
        self.SynopsisEnglish = [[contentDict valueForKey:@"SynopsisEnglish"] description];
        self.SynopsisFrench = [[contentDict valueForKey:@"SynopsisFrench"] description];
        self.License = [[contentDict valueForKey:@"License"] description];
        self.DataLocation= [[contentDict valueForKey:@"DataLocation"] description];
        self.MIMEType = [[contentDict valueForKey:@"MIMEType"] description];
        self.TitleEnglish = [[contentDict valueForKey:@"TitleEnglish"] description];
        self.TitleFrench = [[contentDict valueForKey:@"TitleFrench"] description];
    }
    return self;
}
-(Content *) ToManagedContent:(NSManagedObjectContext*) context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Content" inManagedObjectContext:context];
    Content * managedContent = [[Content alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    managedContent.ArtistName = self.ArtistName;
    managedContent.TitleEnglish=self.TitleEnglish;
    managedContent.TitleFrench=self.TitleFrench;
    managedContent.SynopsisEnglish=self.SynopsisEnglish;
    managedContent.SynopsisFrench=self.SynopsisFrench;
    managedContent.License=self.License;
    managedContent.MIMEType=self.MIMEType;
    managedContent.DataLocation=self.DataLocation;
   
    return managedContent;
}
@end

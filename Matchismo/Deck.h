//
//  Deck.h
//  Matchismo
//
//  Created by Chao Huang on 8/31/14.
//  Copyright (c) 2014 Clemson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface Deck : NSObject

- (void) addCard: (Card *)card atTop:(BOOL) atTop;
- (void) addCard: (Card *)card;
- (Card *) drawRandCard;


@end

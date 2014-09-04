//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Chao Huang on 8/31/14.
//  Copyright (c) 2014 Clemson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"


@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype) initWithCardCount:(NSUInteger)count usingDeck: (Deck *) deck;
- (void) chooseCardAtIndex: (NSUInteger) index;
- (Card *) cardAtIndex: (NSUInteger) index;

@property (nonatomic,readonly) NSInteger score;



/* ----- my code ------*/
@property (nonatomic,strong) NSMutableArray *existCard;
@property (nonatomic,strong) NSMutableArray *cards;

//@property (nonatomic) NSUInteger existCardCount;

- (int) checkStatus: (NSMutableArray *) existCard;
/* ----- my code ------*/




@end

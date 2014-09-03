//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Chao Huang on 8/28/14.
//  Copyright (c) 2014 Clemson. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSMutableArray *cardButtons;
@property (strong,nonatomic) Deck *deck;
@property (strong,nonatomic) CardMatchingGame *game;

/* --- mycode --- */

@property (nonatomic) NSUInteger currentPos;

/* --- mycode --- */


@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    return _game;
}


- (Deck *) deck
{
    if(!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}
/*
- (void) setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
    NSLog(@"HELLO = %d",self.flipCount);
}
*/


- (IBAction)touchCardButton:(UIButton *)sender
{
    int cardIndex = [self.cardButtons indexOfObject:sender];
    if (cardIndex == self.currentPos)
    {
        [self.game chooseCardAtIndex:cardIndex];
    
        self.currentPos++;
        
        //self.scoreLabel.text = [NSString stringWithFormat:@"cardNum: %d",cardIndex];//some display problem
        
        [self.game.existCard addObject:sender];

        
        int k = [self.game checkStatus:self.game.existCard];
        
        self.scoreLabel.text = [NSString stringWithFormat:@"exist: %d",k];

        [self updateUI];
        /*
         if ([sender.currentTitle length]){
            UIImage *cardImage = [UIImage imageNamed:@"cardback"];
            [sender setBackgroundImage:cardImage forState:UIControlStateNormal];
            [sender setTitle:@"" forState:UIControlStateNormal];
         }
         else{
            Card *randomCard = [self.deck drawRandCard];
            if (randomCard) {
                UIImage *cardImage = [UIImage imageNamed:@"cardfront"];
                [sender setBackgroundImage:cardImage forState:UIControlStateNormal];
                [sender setTitle:randomCard.contents forState:UIControlStateNormal];
            }
         }
         self.flipCount++;
         */
    }
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        
        // set the content of the select card
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState: UIControlStateNormal];
        
        //set whether the card should be put as ismatched
        cardButton.enabled = !card.isMatched;
        
        /* ----- my code ------*/
        
        //[self.game.existCard addObject:card];

        
        /* ----- my code ------*/

    }
    //int k = [self.game checkStatus:self.game.existCard];
    //self.scoreLabel.text = [NSString stringWithFormat:@"exist: %d",k];
    
    //self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}









- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen? @"cardfront" : @"cardback"];
}


@end

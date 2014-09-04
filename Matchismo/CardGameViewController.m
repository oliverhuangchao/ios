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
//@property (nonatomic) NSUInteger samepos;

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
        
        Card *newcard = [self.game cardAtIndex:cardIndex]; //game class has already random the card, so do not use [self.deck drawRandCard];
             
        [self.game.existCard addObject:newcard];

        int samepos = [self.game checkStatus:self.game.existCard];//check same position

        //if (samepos != -1)  [NSThread sleepForTimeInterval:0.5];
        //[self updateUI:self.currentPos];//draw the screen of the game
        
        self.scoreLabel.text = [NSString stringWithFormat:@"existnumber: %d, sameposition: %d",self.game.existCard.count,samepos];

        if (samepos == -1)
        {
            self.currentPos++;
        }
        else
        {
            //[NSThread sleepForTimeInterval:1.0];

            self.currentPos = samepos;
            
            int init_exist_Count = self.game.existCard.count;
            
            for(int i = init_exist_Count-1;i >= samepos; i--)
            {
                [self.game.existCard removeObjectAtIndex:i];
                Card * randCard = [self.deck drawRandCard];
                [self.game.cards replaceObjectAtIndex:i withObject:randCard];

            }
        }
        
        [self updateUI:self.currentPos];//draw the screen of the game
        //self.scoreLabel.text = [NSString stringWithFormat:@"existnumber: %d, currentpos: %d",self.game.existCard.count,self.currentPos];
        self.scoreLabel.text = [NSString stringWithFormat:@"Exist Card: %d",self.game.existCard.count];

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
         */
    }
}

- (void) updateUI:(NSUInteger) currentPos
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int buttonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:buttonIndex];
        
        
        if (buttonIndex<currentPos) {
            card.Chosen = YES;
        }
        else
        {
            card.Chosen = NO;
        }
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];//set whether the card should be put as ismatched
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState: UIControlStateNormal];
        
        //cardButton.enabled = !card.isMatched;//set whether the card should be put as ismatched

    }
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

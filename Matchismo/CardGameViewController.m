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
@property (weak, nonatomic) IBOutlet UILabel *SamePostionLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSMutableArray *cardButtons;
@property (strong,nonatomic) Deck *deck;
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UITextField *CardCountTextField;
//@property (weak, nonatomic) IBOutlet UITextView *CardCount;
@property (weak, nonatomic) IBOutlet UILabel *IntroductionLabel;

@property (nonatomic) NSUInteger currentPos;
@property (nonatomic) NSUInteger stepCount;
@property (nonatomic) NSUInteger CardCountNumber;

@end

@implementation CardGameViewController
- (IBAction)ChangeCardCount:(UITextField *)sender
{
    self.CardCountNumber = [self.CardCountTextField.text intValue] - 1;
    self.IntroductionLabel.text = [NSString stringWithFormat:@"You have selected %d cards",self.CardCountNumber+1];
}
- (IBAction)LeaveTheCardCountTextField:(UITextField *)sender
{
    self.IntroductionLabel.text = [NSString stringWithFormat:@"You have selected %d cards",self.CardCountNumber+1];
}
- (IBAction)RestartGame:(UIButton *)sender//restart the game!!!
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int buttonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:buttonIndex];
        card.Chosen = NO;
        card.matched = NO;
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState: UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.currentPos = 0;
    self.stepCount = 0;
    self.CardCountNumber = [self.CardCountTextField.text intValue]-1;
    self.IntroductionLabel.text = [NSString stringWithFormat:@"You have selected %d cards",self.CardCountNumber+1];
}

- (void) viewDidLoad //initializtion methods
{
    self.CardCountNumber = 14;
}


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


- (IBAction)touchCardButton:(UIButton *)sender
{
    int cardIndex = [self.cardButtons indexOfObject:sender];
    if (cardIndex == self.currentPos)
    {
        [self.game chooseCardAtIndex:cardIndex];
        
        Card *newcard = [self.game cardAtIndex:cardIndex]; //game class has already random the card, so do not use [self.deck drawRandCard];
             
        [self.game.existCard addObject:newcard];

        int samepos = [self.game checkStatus:self.game.existCard];//check same position
        
        [self viewWillAppear:YES];
        
        self.stepCount++;
        self.SamePostionLabel.text = [NSString stringWithFormat:@"Step Cost is %d",self.stepCount];
        self.currentPos++;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:samepos], @"samepos", nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(RefreshTable:) userInfo:userInfo repeats:NO];
        [self viewWillAppear:YES];
    }
}

- (void) RefreshTable:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    int samepos = [[userInfo objectForKey:@"samepos"] integerValue];
    if (samepos != -1)
    {
        self.currentPos = samepos;
        int init_exist_Count = self.game.existCard.count;
        
        for(int i = init_exist_Count-1;i >= samepos; i--)
        {
            [self.game.existCard removeObjectAtIndex:i];
            Card * randCard = [self.deck drawRandCard];
            [self.game.cards replaceObjectAtIndex:i withObject:randCard];
        }
    }
    if (self.game.existCard.count == self.CardCountNumber+1)
        self.scoreLabel.text = [NSString stringWithFormat:@"Game Over!"];
    else{
        if (self.game.existCard.count == 0) {
            self.stepCount = 0;
            self.scoreLabel.text = [NSString stringWithFormat:@"You win!"];
        }
        else{
            self.scoreLabel.text = [NSString stringWithFormat:@"Exist Card: %d",self.currentPos];
        }
    }
    [self viewWillAppear:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int buttonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:buttonIndex];
        if (buttonIndex<self.currentPos )
            card.Chosen = YES;
        else
            card.Chosen = NO;
        
        if (self.CardCountNumber < self.currentPos)
            card.matched = YES;
        else
            card.matched = NO;
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState: UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    if(!card.isMatched)
        return [UIImage imageNamed:card.isChosen? @"cardfront" : @"cardback"];
    else
        return [UIImage imageNamed:card.isChosen? @"cardfront" : @"monkey"];
}


@end

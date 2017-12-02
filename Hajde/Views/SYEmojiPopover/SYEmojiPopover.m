//
//  SYEmojiPopover.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYEmojiPopover.h"

#import "WYPopoverController.h"
#import "SYEmojiCharacters.h"

#define EMOJI_RUNNING_IPHONE        ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
#define EMOJI_ITEM_SIZE             ( EMOJI_RUNNING_IPHONE ? 60.f : 60.f )
#define EMOJI_FONT_SIZE             ( EMOJI_RUNNING_IPHONE ? 50.f : 50.f )
#define EMOJI_NB_ITEM_IN_ROW        ( EMOJI_RUNNING_IPHONE ? 5.f : 5.f )
//#define EMOJI_NB_ITEM_IN_COL        ( EMOJI_RUNNING_IPHONE ? 10.f : 10.f )
//#define EMOJI_GRID_TOP_MARGIN       ( EMOJI_RUNNING_IPHONE ? 0.f : 0.f )
//#define EMOJI_GRID_MARGIN           ( EMOJI_RUNNING_IPHONE ? 0.f : 0.f )
//#define EMOJI_GRID_DEFAULT_WIDTH    ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_ROW + EMOJI_GRID_MARGIN * 2.f )
//#define EMOJI_GRID_DEFAULT_HEIGHT   ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_COL + EMOJI_GRID_MARGIN * 2.f )
#define EMOJI_PAGECONTROL_X         (30.f)
#define EMOJI_PAGECONTROL_WIDTH     (55.f)
#define EMOJI_NAVBAR_HEIGHT         (85.f)

@interface SYEmojiPopoverCell : UITableViewCell {
    NSUInteger _row;
    NSUInteger _page;
    NSMutableArray *_buttons;
}
@property (nonatomic, copy) void (^clickedCharacter) (NSString*);

-(void)setRow:(NSUInteger)row andPage:(NSUInteger)page;
-(void)refresh;
-(void)refreshLayout;
-(void)emojiButtonTapped:(id)sender;
@end


@interface SYEmojiPopover (Private)
-(void)createView;
-(void)loadPage:(int)pageIndex;
-(void)updateFramesForSize:(CGSize)size;
-(void)setScrollEnabledAllTableViews:(BOOL)enabled;
@end

@implementation SYEmojiPopover

@synthesize delegate = _delegate;
@synthesize popover = _popover;

#pragma mark - Initialization
- (id)init
{ if (self = [super init]) { [self createView]; } return self; }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) { [self createView]; } return self; }

- (id)initWithCoder:(NSCoder *)aDecoder
{ if (self = [super initWithCoder:aDecoder]) { [self createView]; } return self; }


#pragma mark - Private methods
-(void)createView {
    
    NSUInteger numberOfSections = [[SYEmojiCharacters sharedCharacters] numberOfSections];
//    _preferredSize = CGSizeMake(EMOJI_GRID_DEFAULT_WIDTH, EMOJI_GRID_DEFAULT_HEIGHT + EMOJI_PAGECONTROL_HEIGHT + EMOJI_PAGECONTROL_HEIGHT);
    _preferredSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
    
    /*************************************/
    /**********  MainView INIT  **********/
    /*************************************/
    if(!self.view)
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
    /*************************************/
    /********  PageControl INIT  *********/
    /*************************************/
    if(!self->_pageControl)
        self->_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    self->_pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self->_pageControl.backgroundColor = [UIColor clearColor];
    self->_pageControl.clipsToBounds = YES;
    self->_pageControl.numberOfPages = (NSInteger)numberOfSections;
    self->_pageControl.currentPage = 0;
    
    if([self->_pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
        self->_pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    if([self->_pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
        self->_pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self->_pageControl];
    
    self->_pageControl.hidden = YES;
    
    /*************************************/
    /*********  ScrollView INIT  *********/
    /*************************************/
    if(!self->_scrollView)
        self->_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    self->_scrollView.autoresizingMask = UIViewAutoresizingNone;
    self->_scrollView.backgroundColor = [UIColor clearColor];
    self->_scrollView.pagingEnabled = YES;
    self->_scrollView.showsHorizontalScrollIndicator = NO;
    self->_scrollView.showsVerticalScrollIndicator = NO;
    self->_scrollView.alwaysBounceHorizontal = YES;
    self->_scrollView.clipsToBounds = YES;
    self->_scrollView.zoomScale = 1.f;
    self->_scrollView.maximumZoomScale = 1.f;
    self->_scrollView.minimumZoomScale = 1.f;
    self->_scrollView.contentSize = CGSizeMake(1.f, 1.f);
    self->_scrollView.delegate = self;
    
    [self.view addSubview:self->_scrollView];
    
    /*************************************/
    /**********  TableView INIT  *********/
    /*************************************/
    if(!self->_tableViews) {
        self->_tableViews = [NSMutableArray arrayWithCapacity:numberOfSections];
        for(uint i = 0; i < numberOfSections; ++i)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.rowHeight = EMOJI_ITEM_SIZE;
            
            tableView.autoresizingMask = UIViewAutoresizingNone;
            tableView.backgroundColor = [UIColor clearColor];
            
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.alwaysBounceVertical = YES;
            tableView.clipsToBounds = YES;
            
            tableView.delegate = self;
            tableView.dataSource = nil;
            
            UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, EMOJI_NAVBAR_HEIGHT)];
            [footerView setBackgroundColor:[UIColor clearColor]];
            tableView.tableFooterView = footerView;
            
            [self->_scrollView addSubview:tableView];
            [self->_tableViews addObject:tableView];
        }
    }

    self->pageView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - EMOJI_NAVBAR_HEIGHT, [UIScreen mainScreen].applicationFrame.size.width, EMOJI_NAVBAR_HEIGHT)];
    self->pageView.backgroundColor = [UIColor colorWithRed:27./255. green:30./255. blue:35./255. alpha:0.8];
    [self.view addSubview:self->pageView];
    
    self->emojiButton0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self->emojiButton0.center = CGPointMake(EMOJI_PAGECONTROL_X, EMOJI_NAVBAR_HEIGHT / 4);
    [self->emojiButton0 setImage:[UIImage imageNamed:@"emoji_nav_selected_0"] forState:UIControlStateNormal];
    [self->emojiButton0 addTarget:self action:@selector(onSelectEmoji0:) forControlEvents:UIControlEventTouchUpInside];
    [self->pageView addSubview:self->emojiButton0];
    
    self->emojiButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self->emojiButton1.center = CGPointMake(EMOJI_PAGECONTROL_X + EMOJI_PAGECONTROL_WIDTH, EMOJI_NAVBAR_HEIGHT / 4);
    [self->emojiButton1 setImage:[UIImage imageNamed:@"emoji_nav_1"] forState:UIControlStateNormal];
    [self->emojiButton1 addTarget:self action:@selector(onSelectEmoji1:) forControlEvents:UIControlEventTouchUpInside];
    [self->pageView addSubview:self->emojiButton1];
    
    self->emojiButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self->emojiButton2.center = CGPointMake(EMOJI_PAGECONTROL_X + EMOJI_PAGECONTROL_WIDTH * 2, EMOJI_NAVBAR_HEIGHT / 4);
    [self->emojiButton2 setImage:[UIImage imageNamed:@"emoji_nav_2"] forState:UIControlStateNormal];
    [self->emojiButton2 addTarget:self action:@selector(onSelectEmoji2:) forControlEvents:UIControlEventTouchUpInside];
    [self->pageView addSubview:self->emojiButton2];
    
    self->emojiButton3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self->emojiButton3.center = CGPointMake(EMOJI_PAGECONTROL_X + EMOJI_PAGECONTROL_WIDTH * 3, EMOJI_NAVBAR_HEIGHT / 4);
    [self->emojiButton3 setImage:[UIImage imageNamed:@"emoji_nav_3"] forState:UIControlStateNormal];
    [self->emojiButton3 addTarget:self action:@selector(onSelectEmoji3:) forControlEvents:UIControlEventTouchUpInside];
    [self->pageView addSubview:self->emojiButton3];
    
    self->emojiButton4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self->emojiButton4.center = CGPointMake(EMOJI_PAGECONTROL_X + EMOJI_PAGECONTROL_WIDTH * 4, EMOJI_NAVBAR_HEIGHT / 4);
    [self->emojiButton4 setImage:[UIImage imageNamed:@"emoji_nav_4"] forState:UIControlStateNormal];
    [self->emojiButton4 addTarget:self action:@selector(onSelectEmoji4:) forControlEvents:UIControlEventTouchUpInside];
    [self->pageView addSubview:self->emojiButton4];
    
    /*************************************/
    /********  NavController INIT  *******/
    /*************************************/
    if(!self->_navController)
        self->_navController = [[UINavigationController alloc] initWithRootViewController:self];
    
    self->_navController.navigationBar.hidden = YES;
}

-(CGSize)contentSizeForViewInPopover {
    return self->_preferredSize;
}

-(void)updateFramesForSize:(CGSize)size
{
    self->_preferredSize = size;
    
    NSUInteger numberOfSections = [[SYEmojiCharacters sharedCharacters] numberOfSections];
    CGFloat pageHeight = size.height - 2.f;
    
    if(self.view)
        [self.view setFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    if(self->_pageControl)
        [self->_pageControl setFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    if(self->_scrollView) {
        [self->_scrollView setFrame:CGRectMake(0.f, 0.f, size.width, pageHeight)];
        [self->_scrollView setContentSize:CGSizeMake(size.width * numberOfSections, pageHeight)];
    }
    
    if(self->_tableViews) {
        for(uint i = 0; i < [self->_tableViews count]; ++i) {
            CGRect f = CGRectMake(i * size.width, 0.f, size.width, pageHeight);
            [(UITableView*)[self->_tableViews objectAtIndex:i] setFrame:f];
        }
    }
}

-(void)setScrollEnabledAllTableViews:(BOOL)enabled
{
    for(UITableView *tableView in self->_tableViews)
        [tableView setScrollEnabled:enabled];
}

-(void)loadPage:(int)pageIndex
{
    if(pageIndex < 0 || pageIndex >= (int)[self->_tableViews count])
        return;
    
    UITableView *tableView = [self->_tableViews objectAtIndex:(uint)pageIndex];
    if(tableView.dataSource == nil) {
        tableView.dataSource = self;
        [tableView reloadData];
    }
}

#pragma mark - View methods

-(void)showFromPoint:(CGPoint)point inView:(UIView *)view
{
    if(!self.view)
        [self createView];

    [self updateFramesForSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
    
    [self loadPage:0];
    [self loadPage:1];
    
    self->_popover = [[WYPopoverController alloc] initWithContentViewController:self->_navController];
    [self->_popover presentPopoverFromRect:CGRectMake(point.x, point.y, 1, 1)
                                    inView:view
                  permittedArrowDirections:WYPopoverArrowDirectionAny
                                  animated:YES];
}

-(void)removeEmojiPopover {
    
    [self->_popover dismissPopoverAnimated:YES];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    int pageIndex = ((int)floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
    
    if(scrollView == self->_scrollView) {
        [self setScrollEnabledAllTableViews:NO];
        
        [self loadPage:pageIndex-1];
        [self loadPage:pageIndex];
        [self loadPage:pageIndex+1];
        
    }
    else
        [self->_scrollView setScrollEnabled:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setScrollEnabledAllTableViews:YES];
    [self->_scrollView setScrollEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    int pageIndex = ((int)floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
    
    if(pageIndex >= (int)[[SYEmojiCharacters sharedCharacters] numberOfSections] || pageIndex < 0)
        pageIndex = 0;
    
    [self->_pageControl setCurrentPage:pageIndex];
    
    [self onSetEmojiController:pageIndex];

}

- (void)onSetEmojiPage:(int)pageIndex {
    
    [self loadPage:pageIndex-1];
    [self loadPage:pageIndex];
    [self loadPage:pageIndex+1];
    
    [self->_scrollView setContentOffset:CGPointMake(self->_scrollView.frame.size.width * pageIndex , 0) animated:YES];
}

- (void)onSetEmojiController:(int)pageIndex {
    
    if (pageIndex == 0) {
        
        [self->emojiButton0 setImage:[UIImage imageNamed:@"emoji_nav_selected_0"] forState:UIControlStateNormal];
        [self->emojiButton1 setImage:[UIImage imageNamed:@"emoji_nav_1"] forState:UIControlStateNormal];
        [self->emojiButton2 setImage:[UIImage imageNamed:@"emoji_nav_2"] forState:UIControlStateNormal];
        [self->emojiButton3 setImage:[UIImage imageNamed:@"emoji_nav_3"] forState:UIControlStateNormal];
        [self->emojiButton4 setImage:[UIImage imageNamed:@"emoji_nav_4"] forState:UIControlStateNormal];
        
    } else if (pageIndex == 1) {
        
        [self->emojiButton1 setImage:[UIImage imageNamed:@"emoji_nav_selected_1"] forState:UIControlStateNormal];
        [self->emojiButton0 setImage:[UIImage imageNamed:@"emoji_nav_0"] forState:UIControlStateNormal];
        [self->emojiButton2 setImage:[UIImage imageNamed:@"emoji_nav_2"] forState:UIControlStateNormal];
        [self->emojiButton3 setImage:[UIImage imageNamed:@"emoji_nav_3"] forState:UIControlStateNormal];
        [self->emojiButton4 setImage:[UIImage imageNamed:@"emoji_nav_4"] forState:UIControlStateNormal];
        
    } else if (pageIndex == 2) {
        
        [self->emojiButton2 setImage:[UIImage imageNamed:@"emoji_nav_selected_2"] forState:UIControlStateNormal];
        [self->emojiButton1 setImage:[UIImage imageNamed:@"emoji_nav_1"] forState:UIControlStateNormal];
        [self->emojiButton0 setImage:[UIImage imageNamed:@"emoji_nav_0"] forState:UIControlStateNormal];
        [self->emojiButton3 setImage:[UIImage imageNamed:@"emoji_nav_3"] forState:UIControlStateNormal];
        [self->emojiButton4 setImage:[UIImage imageNamed:@"emoji_nav_4"] forState:UIControlStateNormal];
        
    } else if (pageIndex == 3) {
        
        [self->emojiButton3 setImage:[UIImage imageNamed:@"emoji_nav_selected_3"] forState:UIControlStateNormal];
        [self->emojiButton1 setImage:[UIImage imageNamed:@"emoji_nav_1"] forState:UIControlStateNormal];
        [self->emojiButton2 setImage:[UIImage imageNamed:@"emoji_nav_2"] forState:UIControlStateNormal];
        [self->emojiButton0 setImage:[UIImage imageNamed:@"emoji_nav_0"] forState:UIControlStateNormal];
        [self->emojiButton4 setImage:[UIImage imageNamed:@"emoji_nav_4"] forState:UIControlStateNormal];
        
    } else if (pageIndex == 4) {
        
        [self->emojiButton4 setImage:[UIImage imageNamed:@"emoji_nav_selected_4"] forState:UIControlStateNormal];
        [self->emojiButton1 setImage:[UIImage imageNamed:@"emoji_nav_1"] forState:UIControlStateNormal];
        [self->emojiButton2 setImage:[UIImage imageNamed:@"emoji_nav_2"] forState:UIControlStateNormal];
        [self->emojiButton3 setImage:[UIImage imageNamed:@"emoji_nav_3"] forState:UIControlStateNormal];
        [self->emojiButton0 setImage:[UIImage imageNamed:@"emoji_nav_0"] forState:UIControlStateNormal];
        
    }
}

- (void)onSelectEmoji0:(id)sender {
    
    [self onSetEmojiPage:0];
}

- (void)onSelectEmoji1:(id)sender {
    
    [self onSetEmojiPage:1];
}

- (void)onSelectEmoji2:(id)sender {
    
    [self onSetEmojiPage:2];
}

- (void)onSelectEmoji3:(id)sender {
    
    [self onSetEmojiPage:3];
}

- (void)onSelectEmoji4:(id)sender {
    
    [self onSetEmojiPage:4];
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger page = [self->_tableViews indexOfObject:tableView];
    if(page == NSNotFound)
        return 0;
    
    CGFloat nbCharacters = (CGFloat)[[SYEmojiCharacters sharedCharacters] numberOfRowsInSection:page];
    return (int)ceil(nbCharacters / EMOJI_NB_ITEM_IN_ROW);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger page = [self->_tableViews indexOfObject:tableView];
    if(page == NSNotFound)
        return [[UITableViewCell alloc] init];
    
    NSString *cellIdentifier = @"cellEmoji";
    SYEmojiPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[SYEmojiPopoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [cell setRow:(uint)indexPath.row andPage:page];
    
    if(!cell.clickedCharacter)
    {
        [cell setClickedCharacter:^(NSString *character) {
            SEL clickSel = @selector(emojiPopover:didClickedOnCharacter:);
            if([self.delegate respondsToSelector:clickSel]) {
                
                [self.delegate emojiPopover:self didClickedOnCharacter:character];
                [self->_popover dismissPopoverAnimated:YES];
            }
            
        }];
        
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return NO; }
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath { return NO; }


#pragma mark - UITableViewDelegate methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleNone;
}

@end


@implementation SYEmojiPopoverCell

@synthesize clickedCharacter;

-(void)setRow:(NSUInteger)row andPage:(NSUInteger)page
{
    self->_row = row;
    self->_page = page;
    [self refresh];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self refreshLayout];
}

#pragma mark - Display
-(void)refresh
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self setBackgroundColor:[UIColor clearColor]];
    
    if(!self->_buttons)
    {
        self->_buttons = [NSMutableArray arrayWithCapacity:EMOJI_NB_ITEM_IN_ROW];
        for(uint i = 0; i < EMOJI_NB_ITEM_IN_ROW; ++i)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:EMOJI_FONT_SIZE]];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [button setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [button addTarget:self action:@selector(emojiButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            [self->_buttons addObject:button];
            [self addSubview:button];
        }
    }
    
    NSUInteger firstCharacterIndex = self->_row * (uint)EMOJI_NB_ITEM_IN_ROW;
    for(uint i = 0; i < EMOJI_NB_ITEM_IN_ROW; ++i)
    {
        UIButton *button = [self->_buttons objectAtIndex:i];
        
        NSString *character = [[SYEmojiCharacters sharedCharacters] emojiAtRow:(i + firstCharacterIndex) andSection:self->_page];
        if(!character)
            character = @"";
        
        [button setTitle:character forState:UIControlStateNormal];
    }

    [self refreshLayout];

//    return CGSizeMake(EMOJI_ITEM_SIZE, EMOJI_ITEM_SIZE);
//    [textView setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
}

-(void)refreshLayout
{
    if(!self->_buttons || [self->_buttons count] != EMOJI_NB_ITEM_IN_ROW)
        return;
    
    CGFloat itemWidth = self.frame.size.width / EMOJI_NB_ITEM_IN_ROW;
    CGFloat itemInternalWidth = itemWidth * 0.9f;
    for(uint i = 0; i < EMOJI_NB_ITEM_IN_ROW; ++i)
    {
        UIButton *button = [self->_buttons objectAtIndex:i];
        [button setFrame:CGRectMake(i * itemWidth, 0.f, itemInternalWidth, self.frame.size.height)];
    }
}

#pragma mark - Button click
-(void)emojiButtonTapped:(id)sender {
    
    NSString *character = @"";
    if([sender isKindOfClass:[UIButton class]])
        character = [(UIButton*)sender titleForState:UIControlStateNormal];
    
    if(![[SYEmojiCharacters sharedCharacters] isCharacterEmoji:character])
        return;
    
    if(self.clickedCharacter)
        self.clickedCharacter(character);
}

@end



#import "LoadMoreTableFooterView.h"


@interface LoadMoreTableFooterView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation LoadMoreTableFooterView
@synthesize delegate = _delegate;
@synthesize statusButton = _statusButton;
@synthesize activityView = _activityView;
@synthesize state = _state;

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
  _delegate=nil;
	[_statusButton release];
	[_activityView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
		             
        _statusButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f)];
        //UIButton *showbtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_statusButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [self addSubview:_statusButton];
				
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(50.0f, 10.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
		
		[self setState:LoadMoreNormal];
    }
	
    return self;	
}


#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{	
	switch (aState) {
		case LoadMorePulling:
            [_statusButton setTitle:NSLocalizedString(@"松开加载更多", @"松开加载更多") forState:UIControlStateNormal];
			break;
		case LoadMoreNormal:
            [_statusButton setTitle:NSLocalizedString(@"上拉加载更多", @"上拉加载更多") forState:UIControlStateNormal];
			[_activityView stopAnimating];
			break;
		case LoadMoreLoading:
            [_statusButton setTitle:NSLocalizedString(@"加载中...", @"加载中") forState:UIControlStateNormal];
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == LoadMoreLoading) {
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
		}
		
		if (_state == LoadMoreNormal && scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height-30)) && !_loading) {
			[self setState:LoadMorePulling];
		} else if (_state == LoadMorePulling && scrollView.contentOffset.y < (scrollView.contentSize.height - (scrollView.frame.size.height-30)) && !_loading) {
			[self setState:LoadMoreNormal];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height-30)) && !_loading) {
        [self setState:LoadMoreLoading];
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
			[_delegate loadMoreTableFooterDidTriggerRefresh:self];
		}
	}
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	[self setState:LoadMoreNormal];
}

- (void)showMore{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
    
    if (YES == _loading) return;
    
    [self setState:LoadMoreLoading];
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
        [_delegate loadMoreTableFooterDidTriggerRefresh:self];
    }
    
}



@end

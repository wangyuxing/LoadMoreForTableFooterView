#import <UIKit/UIKit.h>

typedef enum{
  LoadMorePulling = 0,
	LoadMoreNormal,
	LoadMoreLoading,	
} LoadMoreState;

@protocol LoadMoreTableFooterDelegate;
@interface LoadMoreTableFooterView : UIView
{
    id _delegate;
}

@property(nonatomic,assign) id<LoadMoreTableFooterDelegate> delegate;
@property(nonatomic,retain) UIButton *statusButton;
@property(nonatomic,retain) UIActivityIndicatorView *activityView;
@property(nonatomic,assign) LoadMoreState state;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)showMore;

@end

@protocol LoadMoreTableFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view;
@end

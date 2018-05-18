//
//  XLButtonBarPagerTabStripViewController.h
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLButtonBarView.h"
#import "XLButtonBarViewCell.h"
#import "XLPagerTabStripViewController.h"

@interface XLButtonBarPagerTabStripViewController : XLPagerTabStripViewController

@property (copy) void (^changeCurrentIndexProgressiveBlock)(XLButtonBarViewCell* oldCell, XLButtonBarViewCell *newCell, CGFloat progressPercentage, BOOL indexWasChanged, BOOL fromCellRowAtIndex);
@property (copy) void (^changeCurrentIndexBlock)(XLButtonBarViewCell* oldCell, XLButtonBarViewCell *newCell, BOOL animated);

@property (readonly, nonatomic) XLButtonBarView * buttonBarView;
@property (strong, nonatomic) UIView * bottomLineView;
//添加检测当前显示的视图改变时 调用子类方法  toindex 显示的视图下标  isClickChangeView Yes 点击切换  NO为滑动切换

@property (strong, nonatomic) UIColor * titleColorSelected;
@property (strong, nonatomic) UIColor * titleColorNor;
- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  ;
@end
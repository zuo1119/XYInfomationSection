//
//  XYInfomationBaseViewController.m
//  qyxiaoyou
//
//  Created by 渠晓友 on 2019/6/19.
//  Copyright © 2019年 qyxiaoyou. All rights reserved.
//

#import "XYInfomationBaseViewController.h"

@interface XYInfomationBaseViewController ()

/** 内部使用的ScrollViewContentView */
@property(nonatomic , strong)     UIView *scrollContentView;

@end

@implementation XYInfomationBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass(self.superclass) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.scrollView layoutIfNeeded];
    
    NSLog(@"scrollView.bounds = %@",NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"scrollView.frame = %@",NSStringFromCGRect(self.scrollView.bounds));
    NSLog(@"scrollView.contentSize = %@",NSStringFromCGSize(self.scrollView.contentSize));
    NSLog(@"scrollView.contentInset = %@",NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    if (!self.scrollView.contentInset.top) {
        self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 可以用来设置基类的背景色
    // self.view.backgroundColor = HEXCOLOR(0xf6f6f6);
    
    /// 创建基本的内部组件, default is hidden
    self.scrollView = [UIScrollView new];
    self.scrollView.hidden = YES;
    self.scrollContentView = [UIView new];
    _headerView = [UIView new];
    _contentView = UIView.new;
    _footerView = UIView.new;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.headerView];
    [self.scrollContentView addSubview:self.contentView];
    [self.scrollContentView addSubview:self.footerView];
    
    __weak typeof(self) weakSelf = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.width.equalTo(weakSelf.scrollView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.scrollContentView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.scrollContentView);
        make.right.equalTo(weakSelf.scrollContentView);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.scrollContentView);
        make.right.equalTo(weakSelf.scrollContentView);
        make.bottom.equalTo(weakSelf.scrollContentView);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.headerView.backgroundColor = UIColor.redColor;
    self.contentView.backgroundColor = UIColor.greenColor;
    self.footerView.backgroundColor = UIColor.yellowColor;
    
}

- (void)setHeaderView:(UIView *)headerView
{
    [self setHeaderView:headerView edgeInsets:UIEdgeInsetsZero];
}

- (void)setContentView:(UIView *)contentView{
    [self setContentView:contentView edgeInsets:UIEdgeInsetsZero];
}

- (void)setFooterView:(UIView *)footerView
{
    [self setFooterView:footerView edgeInsets:UIEdgeInsetsZero];
}

- (void)setHeaderView:(UIView *)headerView edgeInsets:(UIEdgeInsets)edgeInsets
{
    [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.headerView addSubview:headerView];

    __weak typeof(self) weakSelf = self;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView).offset(edgeInsets.top);
        make.left.equalTo(weakSelf.headerView).offset(edgeInsets.left);
        make.right.equalTo(weakSelf.headerView).offset(-edgeInsets.right);
        make.height.mas_equalTo(headerView.bounds.size.height);
        make.bottom.equalTo(weakSelf.headerView).offset(-edgeInsets.bottom);
    }];
    
    [self hasSetupContent];
}

- (void)setContentView:(UIView *)contentView edgeInsets:(UIEdgeInsets)edgeInsets
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:contentView];
    
    __weak typeof(self) weakSelf = self;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(edgeInsets.top);
        make.left.equalTo(weakSelf.contentView).offset(edgeInsets.left);
        make.right.equalTo(weakSelf.contentView).offset(-edgeInsets.right);
        make.height.mas_equalTo(contentView.bounds.size.height);
        make.bottom.equalTo(weakSelf.contentView).offset(-edgeInsets.bottom);
    }];
    
    [self hasSetupContent];
}

- (void)setFooterView:(UIView *)footerView edgeInsets:(UIEdgeInsets)edgeInsets
{
    [self.footerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.footerView addSubview:footerView];
    
    __weak typeof(self) weakSelf = self;
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.footerView).offset(edgeInsets.top);
        make.left.equalTo(weakSelf.footerView).offset(edgeInsets.left);
        make.right.equalTo(weakSelf.footerView).offset(-edgeInsets.right);
        make.height.mas_equalTo(footerView.bounds.size.height);
        make.bottom.equalTo(weakSelf.footerView).offset(-edgeInsets.bottom);
    }];
    
    [self hasSetupContent];
}


- (void)hasSetupContent{
    // 只要有内容设置就展示对应的scrollView(页面的所有内容)
    self.scrollView.hidden = NO;
}

@end
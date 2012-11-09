//
//  ViewController.h
//  ChartTest
//
//  Created by Cameron Cooke on 05/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBarChart.h"
#import "BTLineChart.h"

@interface ViewController : UIViewController <BTBarChartDataSource, BTLineChartDataSource>
@end
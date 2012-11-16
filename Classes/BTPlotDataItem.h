//
//  BTPlotDataItem.h
//  ChartTest
//
//  Created by Cameron Cooke on 07/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTPlotDataItem <NSObject>

// plot type label (normally used for the legend)
@property (nonatomic, copy) NSString *plotTypeLabel;

// label that is normally shown above the plot item
@property (nonatomic, copy) NSString *dataLabel;

// value
@property (nonatomic) NSUInteger value;

// styling properties
@property (nonatomic, strong) UIColor *startGradientColour;
@property (nonatomic, strong) UIColor *endGradientColour;
@end

//
//  ViewController.m
//  ChartTest
//
//  Created by Cameron Cooke on 05/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Random.h"
#import "InstrumentData.h"
#import "InstrumentsDateGroup.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet BTBarChart *chart1;
@property (weak, nonatomic) IBOutlet BTBarChart *chart2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end


@implementation ViewController {
    NSArray *data;
    NSArray *data2;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        for (NSInteger c = 0; c < 2; c++) {
            
            // generate sample data
            NSMutableArray *tempData = [@[] mutableCopy];
            
            NSInteger count = MAX(2, (arc4random() % 10)); // number of months back of fake data to generate
            
            // date format for date labels
            NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MM YYYY" options:0 locale:[NSLocale currentLocale]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:dateFormat];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit  fromDate:[NSDate date]];
            dateComponents.month -= count;
            
            NSArray *labels = @[@"Roche", @"Brightec", @"Other qPCR", @"Fruit", @"Roche <96", @"ABI"];
            NSInteger labelCount = MAX(2, (arc4random() % (labels.count+1)));
            
            for (NSInteger i = 0; i < count; i++) {
                
                dateComponents.month += 1;
                NSDate *date = [calendar dateFromComponents:dateComponents];
                NSString *dateString = [formatter stringFromDate:date];
                
                // create sample instruments
                NSMutableArray *tmp = [@[] mutableCopy];
                
                for (NSInteger j = 0; j < labelCount; j++) {
                    
                    NSInteger fakeValue = MAX(5, arc4random() % 1000);
                    
                    InstrumentData *instrument = [[InstrumentData alloc] init];
                    instrument.label = labels[j];
                    instrument.value = fakeValue;
                    [tmp addObject:instrument];
                }
                
                InstrumentsDateGroup *dataGroup = [[InstrumentsDateGroup alloc] init];
                dataGroup.label = dateString;
                dataGroup.plotDataItems = [NSArray arrayWithArray:tmp];
                [tempData addObject:dataGroup];
            }

            if (c == 0) {
                data = [NSArray arrayWithArray:tempData];
            }
            else {
                data2 = [NSArray arrayWithArray:tempData];
            }
        }
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.contentSize = CGSizeMake(2048, 748);
    
    self.chart1.chartTitle = @"Reagent vs Time";
    self.chart2.chartTitle = @"Number of Instruments vs Time";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark -
# pragma mark BTBarChartDataSource

- (NSInteger)numberOfPlotGroupsInChart:(BTChart *)chart
{
    if (chart == self.chart2) {
        return data2.count;
    }
    return data.count;
}


- (NSInteger)chart:(BTChart *)chart numberOfPlotsInGroup:(NSInteger)group
{
    InstrumentsDateGroup *g;
    if (chart == self.chart2) {
        g = data2[group];
    }
    else {
        g = data[group];
    }
    return g.plotDataItems.count;
}


- (id<BTPlotDataItem>)chart:(BTChart *)chart dataItemForIndexPath:(NSIndexPath *)indexPath
{
    InstrumentsDateGroup *g;
    if (chart == self.chart2) {
        g = data2[indexPath.section];
    }
    else {
        g = data[indexPath.section];
    }

    InstrumentData *item = (InstrumentData *)g.plotDataItems[indexPath.row];
    return item;
}


- (NSString *)chart:(BTChart *)chart titleForGroup:(NSInteger)group
{
    InstrumentsDateGroup *g;
    if (chart == self.chart2) {
        g = data2[group];
    }
    else {
        g = data[group];
    }
    return g.label;
}


# pragma mark -
# pragma mark BTBarChartDataSource

- (NSArray *)barChart:(BTChart *)barChart startAndEndGradientColorsForPlotItem:(NSInteger)item
{
    UIColor *startColour = [UIColor randomPrimaryColour];

    // darken end colour
    CGFloat hue, sat, bright, alpha;
    [startColour getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
    bright = 80/255.0f;
    UIColor *endColour = [UIColor colorWithHue:hue saturation:sat brightness:bright alpha:alpha];
    
    return @[startColour, endColour];
}


# pragma mark -
# pragma mark BTLineChartDataSource

- (UIColor *)lineChart:(BTLineChart *)lineChart lineColourForPlotItem:(NSInteger)item;
{
    return [UIColor randomPrimaryColour];
}

@end
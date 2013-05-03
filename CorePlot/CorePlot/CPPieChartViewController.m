//
//  CPFirstViewController.m
//  CorePlot
//
//  Created by Muhammed Rashid A on 03/05/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CPPieChartViewController.h"

@interface CPPieChartViewController ()

@end

@implementation CPPieChartViewController

@synthesize hostView = hostView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"PieChart", @"PieChart");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    grades = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D", nil];
    numberOfStudents = [[NSArray alloc]initWithObjects:[NSDecimalNumber  numberWithInt:4], [NSDecimalNumber numberWithInt:12], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:2], nil];
    
    [self initPlot];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

#pragma mark - CPTPlotDataSource methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot 
{
    return [grades count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    if (CPTPieChartFieldSliceWidth == fieldEnum) 
    {
        return [numberOfStudents objectAtIndex:index];
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    //Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText)
    {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    //Calculate total numberOfStudents
    NSDecimalNumber *totalNumberOfStudents = [NSDecimalNumber zero];
    for (NSDecimalNumber *numberOfStudent in numberOfStudents) 
    {
        totalNumberOfStudents = [totalNumberOfStudents decimalNumberByAdding:numberOfStudent];
    }
    
    //Calculate percentage value
    NSDecimalNumber *students = [numberOfStudents objectAtIndex:index];
    NSDecimalNumber *percent = [students decimalNumberByDividingBy:totalNumberOfStudents];
    
    //Set up display label
    NSString *labelValue = [NSString stringWithFormat:@"%d : (%0.2f) ", [students intValue], ([percent floatValue] * 100.0f)];
    
    //Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    if (index < [grades count])
    {
        return [grades objectAtIndex:index];;
    }
    
    return @"N/A";
}

- (void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost 
{    
    CGRect hostViewFrame = CGRectMake(10,10, 460, 240);
    self.hostView = [[CPTGraphHostingView alloc]initWithFrame:hostViewFrame];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph 
{    
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    [self.hostView.hostedGraph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    
    //Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    
    //Configure title
    NSString *title = @"Student Grades ";
    graph.title = title;    
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;    
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);      
}

-(void)configureChart 
{
    //Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;    
    //Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;    
    //Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    //Add chart to graph    
    [graph addPlot:pieChart];

}

-(void)configureLegend
{    
    
    //Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    //Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    //Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    //Add legend to graph
    graph.legend = theLegend;     
    graph.legendAnchor = CPTRectAnchorRight;
    CGFloat legendPadding = -(self.view.bounds.size.width / 10);
    graph.legendDisplacement = CGPointMake(legendPadding, 0.0);

}

@end

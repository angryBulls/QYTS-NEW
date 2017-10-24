//
//  VoiceStatisticsRecordingCell.m
//  QYTS
//
//  Created by 孙中山 on 2017/10/16.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "VoiceStatisticsRecordingCell.h"

@interface VoiceStatisticsRecordingCell ()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UIImageView *dotIm;


@end


@implementation VoiceStatisticsRecordingCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(W(22/2), H(5/2), self.width-W(22/2), H(25/2))];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:H(8)];
        [self addSubview:self.timeLabel];
        
        UIImageView *playIV = [[UIImageView alloc] initWithFrame:CGRectMake(W(22/2), H(35/2), W(157/2), H(20))];
        playIV.image = [UIImage imageNamed:@"statistics_recording_bg"] ;
        
        [self addSubview:playIV];
        
        _dotIm = [[UIImageView alloc] initWithFrame:CGRectMake(W((22+157+3)/2), H(30/2), W(10/2), H(10/2))];
        _dotIm.image = [UIImage imageNamed:@"statistics_recording_dot"];
        [self addSubview:_dotIm];
    }
    
    return self;
}

-(void)setModel:(PcmModel *)model{
    _model = model;
    self.timeLabel.text = [model.pcmPath componentsSeparatedByString:@"/"].lastObject;
    if (model.areadlyPlay) {
        _dotIm.hidden = YES;
    }
    else
    {
        _dotIm.hidden = NO;
    }
    
}



@end

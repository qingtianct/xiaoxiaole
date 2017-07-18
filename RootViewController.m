//
//  RootViewController.m
//  xiaoxiaole
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 ChengTao. All rights reserved.
//

#import "RootViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "PlaySound.h"

#define W 8
#define H 12
@interface RootViewController ()
{
    NSMutableArray *array;
    UIButton *btn;
}
@property (nonatomic , strong) PlaySound* sound;
@property (nonatomic , strong) AVAudioPlayer*audioPlayer;
@property (nonatomic , assign) NSInteger score;
@property (nonatomic , strong) UILabel* l1;
@end

@implementation RootViewController
bool isClick = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    _score = 0;
    [self creatPlayer];
   
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mn4.png"]];
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    
     [self creatScoreUI];
    [self creatButton];
    [self addImageToAllButton];
    [self check];
    [self check];
    [self check];
    [self check];
}

-(void)creatScoreUI{
    
    _l1 = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 20, 100, 30)];
    _l1.textAlignment = 1 ;
    _l1.textColor = [UIColor redColor];
    _l1.text = [NSString stringWithFormat:@"分数：%li",_score];
    [self.view addSubview:_l1];

}
-(void)creatButton
{
    array = [NSMutableArray array];
    for(int i=0;i<W;i++)
    {
        for(int j=0;j<H;j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/W*i, 50+[UIScreen mainScreen].bounds.size.width/W*j, [UIScreen mainScreen].bounds.size.width/W, [UIScreen mainScreen].bounds.size.width/W);
            button.tag = 100+i+j*W;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor yellowColor].CGColor;
            [button addTarget:self action:@selector(allPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [array addObject:button];
        }
    }
}
-(void)unSortArray
{
    for(int i=0;i<array.count;i++)
    {
        [array exchangeObjectAtIndex:i withObjectAtIndex:(arc4random()%(array.count-i)+i)];
    }
    
}
-(void)addImageToAllButton
{
    [self unSortArray];
    for(int i=0;i<array.count;i++)
    {
        UIButton *button = array[i];
        NSInteger k = arc4random()%7+1;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",k]] forState:UIControlStateNormal];
        button.titleLabel.text =[NSString stringWithFormat:@"%li",k];
    }
}

-(void)allPress:(UIButton*)button
{
    if(isClick == 0)
    {
        btn = button;
        btn.backgroundColor = [UIColor whiteColor];
    }
    else if (isClick == 1)
    {
        BOOL a=0;
         if(button.tag == (btn.tag-W))
        {
            a=1;
        }
        
        else if(button.tag == (btn.tag-1))
        {
            a=1;
        }
        else if(button.tag == (btn.tag+1))
        {
            a=1;
        }
        
        else if(button.tag == (btn.tag+W))
        {
            a=1;
        }
                if(a==1)
        {
            NSString *l;
            l = button.titleLabel.text;
            [button setBackgroundImage:[UIImage imageNamed:btn.titleLabel.text] forState:UIControlStateNormal];
            button.titleLabel.text = btn.titleLabel.text;
            
            [btn setBackgroundImage:[UIImage imageNamed:l] forState:UIControlStateNormal];
            btn.titleLabel.text = l;
            
            [self check];
            [self check];
             [self check];
        }
         btn.backgroundColor = [UIColor clearColor];
    }
    isClick = !isClick;
}
//当前位置检查
-(void)presentPositionCheck:(UIButton*)btn1 and:(UIButton*)button
{
    NSMutableArray *array1 = [self xy:btn1];
    NSMutableArray *array2 = [self xy:btn1];
    int x1 =[array1[0] intValue];
    int y1 =[array1[1] intValue];
     [self checkW:x1 and:y1];
    int y2 =[array2[1] intValue];
    int x2 =[array2[0] intValue];
    [self checkW:x2 and:y2];
    
}
-(void)checkW:(int)x and:(int)y
{
    int count = 1;
    int count0 =1;
    if(x>=2&&x<W-2)
    {
        for(int a=0;a<3;a++)
        {
            
          UIButton *a1 = (id)[self.view viewWithTag:100+x+a+5*y];
          UIButton *a2 = (id)[self.view viewWithTag:99+x+a+5*y];
          UIButton *a3 = (id)[self.view viewWithTag:98+x+a+5*y];
            if([a1.titleLabel.text isEqualToString:a2.titleLabel.text]&&[a1.titleLabel.text isEqualToString:a3.titleLabel.text])
            {
                count = 3;
                [self creatNewImageWidth:a+x-2 and:y and:3];
            }
        }
    }
    if(y>=2&&y<=H-2)
    {
        for(int a=0;a<3;a++)
        {
            
            UIButton *b1 = (id)[self.view viewWithTag:100+x+5*(y+a)];
            UIButton *b2 = (id)[self.view viewWithTag:95+x+5*(y+a)];
            UIButton *b3 = (id)[self.view viewWithTag:90+x+5*(y+a)];
            if([b1.titleLabel.text isEqualToString:b2.titleLabel.text]&&[b1.titleLabel.text isEqualToString:b3.titleLabel.text])
            {
                count0 = 3;
                [self creatNewImageHeight:x and:(y+a-2) and:3];
            }

        }
    }
    
}

-(NSMutableArray*)xy:(UIButton*)btn1
{
    NSInteger tag = btn.tag;
    NSMutableArray *array1 = [NSMutableArray array];
    NSInteger x = (tag-100)%5;
    NSInteger y = (tag-100)/5;
    NSString* i = [NSString stringWithFormat:@"%li",x];
    NSString* j = [NSString stringWithFormat:@"%li",y];
    [array1 addObject:i];
    [array1 addObject:j];
    return array1;
}

//遍历检查
-(void)check
{
    for(int i=0;i<W;i++)
    {
        for(int j=0;j<H;j++)
        {
            int count = 1;
            int count0 = 1;
                UIButton *a1 = (id)[self.view viewWithTag:100+i+j*W];
                UIButton *a2 = (id)[self.view viewWithTag:101+i+j*W];
                UIButton *a3 = (id)[self.view viewWithTag:102+i+j*W];
                UIButton *a4 = (id)[self.view viewWithTag:103+i+j*W];
                UIButton *a5 = (id)[self.view viewWithTag:103+i+j*W];
                if([a1.titleLabel.text isEqualToString:a2.titleLabel.text])
                {
                    count++;
                    if([a1.titleLabel.text isEqualToString:a3.titleLabel.text])
                    {
                        count++;
                        if([a1.titleLabel.text isEqualToString:a4.titleLabel.text])
                        {
                            count++;
                            if([a1.titleLabel.text isEqualToString:a5.titleLabel.text])
                            {
                                count++;
                            }
                            
                        }
                    }
                }
            
            
    
        UIButton *b1 = (id)[self.view viewWithTag:100+i+j*W];
        UIButton *b2 = (id)[self.view viewWithTag:100+i+(j+1)*W];
        UIButton *b3 = (id)[self.view viewWithTag:100+i+(j+2)*W];
        UIButton *b4 = (id)[self.view viewWithTag:100+i+(j+3)*W];
        UIButton *b5 = (id)[self.view viewWithTag:100+i+(j+4)*W];
            
                if([b1.titleLabel.text isEqualToString:b2.titleLabel.text])
                {
                    count0++;
                    if([b1.titleLabel.text isEqualToString:b3.titleLabel.text])
                    {
                        count0++;
                        if([b1.titleLabel.text isEqualToString:b4.titleLabel.text])
                        {
                            count0++;
                            if([b1.titleLabel.text isEqualToString:b5.titleLabel.text])
                            {
                                count0++;
                            }
                        }
                    }
                }
             if(count0>=3)
            {
                NSLog(@"height");
                [self playMusic];
                [self creatNewImageHeight:i and:j and:count0];
            }
            if(count>=3)
            {
                NSLog(@"width");
                 [self playMusic];
                [self creatNewImageWidth:i and:j and:count];
            }
            
        }
    }
        
}



-(void)creatNewImageWidth:(int)i and:(int)j and:(int)count
{
    _score += count;
    _l1.text = [NSString stringWithFormat:@"分数：%li",_score];
    for(int a=j;a>0;a--)
    {
        for(int b=0;b<count;b++)
        {
            UIButton *a1 = (id)[self.view viewWithTag:100+b+i+a*W];
            UIButton *a2 = (id)[self.view viewWithTag:100+b+i+(a-1)*W];
            
            [a1 setBackgroundImage:[UIImage imageNamed:a2.titleLabel.text] forState:UIControlStateNormal];
            NSLog(@"tag=%i",100+b+i+a*W);
            a1.titleLabel.text = a2.titleLabel.text;
           
        }
    }
    for(int k=0;k<count;k++)
    {
        UIButton *a1 = (id)[self.view viewWithTag:100+k+i];
        NSInteger x = arc4random()%7+1;
        [a1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",x]] forState:UIControlStateNormal];
        a1.titleLabel.text =[NSString stringWithFormat:@"%li",x];
    }
    NSLog(@"-");
}

-(void)creatNewImageHeight:(int)i and:(int)j and:(int)count0
{
    _score += count0;
    _l1.text = [NSString stringWithFormat:@"分数：%li",_score];
    if(count0<5)
    {
        for(int k=0;k<count0;k++)
        {
            UIButton *a1 = (id)[self.view viewWithTag:100+i+(j+count0-1-k)*W];
            UIButton *a2 = (id)[self.view viewWithTag:100+i+(j-k-1)*W];
            a1.titleLabel.text = a2.titleLabel.text;
            [a1 setBackgroundImage:[UIImage imageNamed:a1.titleLabel.text] forState:UIControlStateNormal];
            
        }
        for(int l=count0-1;l>=0;l--)
        {
            UIButton *a1 = (id)[self.view viewWithTag:100+i+l*W];
            NSInteger x = arc4random()%7+1;
            [a1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",x]] forState:UIControlStateNormal];
            a1.titleLabel.text =[NSString stringWithFormat:@"%li",x];
        }
    }
    else if(count0 == 5)
    {
        for(int k=0;k<3;k++)
        {
            UIButton *a1 = (id)[self.view viewWithTag:100+i+(j+count0-1-k)*W];
            UIButton *a2 = (id)[self.view viewWithTag:100+i+(j-k-1)*W];
            a1.titleLabel.text = a2.titleLabel.text;
            [a1 setBackgroundImage:[UIImage imageNamed:a1.titleLabel.text] forState:UIControlStateNormal];
            
        }
        for(int l=count0-1;l>=0;l--)
        {
            UIButton *a1 = (id)[self.view viewWithTag:100+i+l*W];
            NSInteger x = arc4random()%7+1;
            [a1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",x]] forState:UIControlStateNormal];
            a1.titleLabel.text =[NSString stringWithFormat:@"%li",x];
        }
        
    }

    NSLog(@"|");
}

-(void)creatPlayer{

    _sound = [[PlaySound alloc]initSystemShake];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"sound.caf" ofType:nil];
    
    NSURL * musicURL = [[NSURL alloc]initFileURLWithPath:musicPath];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:&error];
    if (error) {
        NSLog(@"error : %@",error);
        return;
    }

}

-(void)playMusic{
    [_sound play];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

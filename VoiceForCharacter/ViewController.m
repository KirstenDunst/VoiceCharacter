//
//  ViewController.m
//  VoiceForCharacter
//
//  Created by CSX on 2017/2/24.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

@interface ViewController () <SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSString *_languageStr;
    NSMutableDictionary *_languageDic;
    
    
}
@property (weak, nonatomic) IBOutlet UITextView *talkMessage;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property(strong,nonatomic)SFSpeechRecognizer *speechRecognizer;
@property(strong,nonatomic)AVAudioEngine *audioEngine;
@property(strong,nonatomic)SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property(strong,nonatomic)NSMutableArray *languageNameArr;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UILabel *resultStringLabel;



@end


@implementation ViewController


- (NSMutableArray *)languageNameArr{
    if (!_languageNameArr) {
        _languageNameArr = [_languageDic allKeys].copy;
    }
    return _languageNameArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _languageStr = @"zh-CH";
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.talkMessage.returnKeyType = UIReturnKeyDone;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LanguageRegion" ofType:@"plist"];
    _languageDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
//    _languageDic = @{@"公用荷兰语 - 南非":@"af-ZA",@"阿尔巴尼亚 -阿尔巴尼亚":@"sq-AL",@"阿拉伯语 -阿尔及利亚":@"ar-DZ",@"阿拉伯语 -巴林":@"ar-BH",@"阿拉伯语 -埃及":@"ar-EG",@"阿拉伯语 -伊拉克":@"ar-IQ",@"阿拉伯语 -约旦":@"ar-JO",@"阿拉伯语 -科威特":@"ar-KW", @"阿拉伯语 -黎巴嫩": @"ar-LB",@"阿拉伯语 -利比亚":@"ar-LY",@"阿拉伯语 -摩洛哥":@"ar-MA",@"阿拉伯语 -阿曼":@"ar-OM",@"阿拉伯语 -卡塔尔": @"ar-QA",@"阿拉伯语 - 沙特阿拉伯":@"ar-SA",@"阿拉伯语 -叙利亚共和国":@"ar-SY",@"阿拉伯语 -北非的共和国": @"ar-TN",@"阿拉伯语 - 阿拉伯联合酋长国": @"ar-AE",@"阿拉伯语 -也门":@"ar-YE",@"亚美尼亚的 -亚美尼亚":@"hy-AM",@"Azeri-(西里尔字母的) 阿塞拜疆":@"az-AZ-Cyrl",@"Azeri(拉丁文)- 阿塞拜疆":@"az-AZ-Latn",@"巴斯克 -巴斯克":@"eu-ES",@"Belarusian-白俄罗斯":@"be-BY",@"保加利亚 -保加利亚":@"bg-BG",@"嘉泰罗尼亚 -嘉泰罗尼亚":@"ca-ES",@"华 - 香港的 SAR":@"zh-HK",@"华 - 澳门的 SAR":@"zh-MO",@"华 -中国": @"zh-CN",@"华 (单一化)":@"zh-CHS",@"华 -新加坡": @"zh-SG",@"华 -台湾":@"zh-TW",@"华 (传统的)":@"zh-CHT",@"英国 -澳洲":@"en-AU",@"英国 -伯利兹":@"en-BZ",@"英国 -加拿大": @"en-CA",@"英国 -加勒比海": @"en-CB",@"英国 -爱尔兰":@"en-IE",@"英国 -牙买加":@"en-JM",@"英国 - 新西兰":@"en-NZ",@"英国 -菲律宾共和国": @"en-PH",@"英国 - 南非":@"en-ZA",@"英国 - 千里达托贝哥共和国":@"en-TT",@"英国 - 英国":@"en-GB",@"英国 - 美国":@"en-US",@"英国 -津巴布韦":@"en-ZW"}.mutableCopy;
//    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.talkMessage endEditing:YES];
    }
    
    return YES;
}
- (IBAction)pronounce:(UIButton *)sender {
    
    //切换为播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    AVSpeechUtterance *utterance;
    //发音。  en-US：英语发音。    zh-TW:台湾语音。
    AVSpeechSynthesisVoice *voice;

    utterance = [AVSpeechUtterance speechUtteranceWithString:self.talkMessage.text];
    voice = [AVSpeechSynthesisVoice voiceWithLanguage:_languageStr];
    utterance.voice = voice;
    utterance.volume = 1.0;
    utterance.rate = 0.5;//设置语速
    utterance.pitchMultiplier = 1.1;//音高
    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
    [synth speakUtterance:utterance];
}
- (IBAction)chooseLanguage:(UIButton *)sender {
    self.myTableView.hidden = NO;
}
- (IBAction)readForNow:(UIButton *)sender {
    //本地文件语音读取   这里设置为中文，如有需要可修改
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    SFSpeechRecognizer *localRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];
    NSURL *url =[[NSBundle mainBundle] URLForResource:@"test.mp3" withExtension:nil];
    if (!url) return;
    SFSpeechURLRecognitionRequest *res =[[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    [localRecognizer recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"语音识别解析失败,%@",error);
        }
        else
        {
            self.resultStringLabel.text = result.bestTranscription.formattedString;
        }
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SFSpeechRecognizer  requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    /*
                     UIControlStateDisabled与self.recordButton.enabled = NO同用才有效，不然的话没有效果
                     */
                    self.recordButton.enabled = NO;
                    [self.recordButton setTitle:@"语音识别未授权" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    
                    self.recordButton.enabled = NO;
                    [self.recordButton setTitle:@"用户未授权使用语音识别" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    self.recordButton.enabled = NO;
                    [self.recordButton setTitle:@"语音识别在这台设备上受到限制" forState:UIControlStateDisabled];
                    
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    self.recordButton.enabled = YES;
                    [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
        });
    }];
}

- (IBAction)rescordButtonClicked:(UIButton *)sender {
    
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        if (_recognitionRequest) {
            [_recognitionRequest endAudio];
        }
        self.recordButton.enabled = NO;
        //让文字显示在点击的状态显示
        [self.recordButton setTitle:@"正在停止" forState:UIControlStateDisabled];
    }else{
        [self startRecording];
        [self.recordButton setTitle:@"停止录音" forState:UIControlStateNormal];
    }
}
- (void)startRecording{
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    //录制音频模式
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(inputNode, @"录入设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) weakSelf = self;
    _recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL isFinal = NO;
        if (result) {
            strongSelf.resultStringLabel.text = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        if (error || isFinal) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionTask = nil;
            strongSelf.recognitionRequest = nil;
            strongSelf.recordButton.enabled = YES;
            [strongSelf.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        }
        
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
    self.resultStringLabel.text = @"正在录音。。。";
}
#pragma mark - lazyload
- (AVAudioEngine *)audioEngine{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
- (SFSpeechRecognizer *)speechRecognizer{
    if (!_speechRecognizer) {
        //要为语音识别对象设置语言，这里设置的是中文，可以作修改为动态（eg：_languageStr）
        NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        _speechRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}
#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    }
    else{
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"语音识别不可用" forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.languageNameArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.languageNameArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _languageStr = [_languageDic objectForKey:self.languageNameArr[indexPath.row]];
    self.myTableView.hidden = YES;
    [self.languageButton setTitle:self.languageNameArr[indexPath.row] forState:UIControlStateNormal];
}
@end

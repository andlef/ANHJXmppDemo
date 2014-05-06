##
#设置语言（国际化）动态显示,不需要退出app。 paulus.an  11-23-2011
# It can auto-setting Localization in your app, but it's not really very useful since I think so.

# 1.Import GetStringForLang.h in your file.
# 2.Open Language.h, you must do modification:
#    #define LANG_FILE_NAME @"Localization"  //@"Localization" was you *.strings.
    
# 3.Implement.
#   
#    - (NSString*) getStrFromGetStringForLang:(NSString *)key comment:(NSString *)comment sender:(id)sender actionKey:(ActionKeyType)actKey;

#   ActionKeyType:
                typedef enum {
                    setTitle,
                    setText,
                    Title,
                    Text,
                    setPlaceholder
                } ActionKeyType;

Description:
    Set "Title" and "Text" for actionKey parameter of controller when only one parameters or no setTitle/setText method. Otherwise(the second para was "forState"), set "setTitle/setText" for actionKey.

EXP:
    // .h
    GetStringForLang        *   getString4Lang; 

    // .m
    getString4Lang = [[GetStringForLang alloc] init];
    //UIButton...
    [aButton setTitle:[languageSetting getStrFromGetStringForLang:@"  HOT" comment:@"  HOT" sender:aButton  actionKey:setTitle] forState:UIControlStateNormal]];    
    
    //UILabel...
    [aLabel setText:[languageSetting getStrFromGetStringForLang:@"  HOT" comment:@"  HOT" sender:aButton  actionKey:Text]];

    //UIBarButtonItem...
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginBarClick:)];
    self.navigationItem.rightBarButtonItem.title = [getString4Lang getStrFromGetStringForLang:@"Login" comment:@"Login" sender:self.navigationItem.rightBarButtonItem actionKey:Title];
    
    //......
 
    //The SetLanguageFromNotifications.m was a test page which trigger notification


NOTE:
    1.You can add related method to "- (void) changeLANG:(NSNotification*)note" in setLangrageNotifications.m if the second para was not "forState".
    2.Add related enum-type data to ActionKeyType if necessary.
    3.This is not very well solutions for LanguageSettins_RightNow_EntiretyProjectApplication , so, let me konw if you have a better solutions.  Email: andlef@163.com anhj101@163.com  QQ: 20850902




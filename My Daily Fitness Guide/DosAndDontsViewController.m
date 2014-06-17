//
//  DosAndDontsViewController.m
//  My Daily Fitness Guide
//
//  Created by yogesh on 24/05/2014.
//  Copyright (c) 2014 yogesh. All rights reserved.
//

#import "DosAndDontsViewController.h"

@interface DosAndDontsViewController () {
    FMDatabase *database;
    NSString *heart, *diabetes, *pregnancy, *thyroid, *cholestrol, * pcos;
    NSString *trainerHeart, *trainerDiabetes, *trainerLowerBack, *trainerSpon, *trainerKnee, *trainerWrist, *trainerPregnancy;
    NSMutableString *htmlString;
}

@end

@implementation DosAndDontsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    [self initializeStrings];
    
    database = [FMDatabase databaseWithPath:[DatabaseExtra dbPath]];
    htmlString = [[NSMutableString alloc] init];

    [htmlString appendFormat:@"<html><head><style>ul {padding-left: 20px; margin-top: 2px; margin-left: 10px;} h5 { margin-bottom: 2px; padding-left: 5px; margin-left:5px; font-size:20px;} h4 { margin-top: -6px; margin-bottom: -12px; text-align: center;} div {background: -webkit-linear-gradient(top, #e8e8e8, #ffffff);} li {margin-top:13px;} hr {display: block; height: 1px; border: 0; border-top: 1px solid #ccc; margin-top:-2px;}</style></head><body>"];
    
    [database open];
    if ([self.screenType isEqualToString:@"nutritionist"]) {
        FMResultSet *results = [database executeQuery:@"SELECT name FROM medicalCondition WHERE selected = 'true' AND dietMod = 'yes'"];
        while([results next]) {
            if ([[results stringForColumn:@"name"] isEqualToString:@"Heart / Hypertension / High BP"]) {
                [htmlString appendString:heart];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Diabetes"]) {
                [htmlString appendString:diabetes];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Pregnancy"]) {
                [htmlString appendString:pregnancy];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Thyroid (hypo thyroid)"]) {
                [htmlString appendString:thyroid];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Cholesterol"]) {
                [htmlString appendString:cholestrol];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"PCOS"]) {
                [htmlString appendString:pcos];
            }
        }
    } else {
        FMResultSet *results = [database executeQuery:@"SELECT name FROM medicalCondition WHERE selected = 'true' AND wtm = 'yes'"];
        while([results next]) {
            if ([[results stringForColumn:@"name"] isEqualToString:@"Heart / Hypertension / High BP"]) {
                [htmlString appendString:trainerHeart];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Diabetes"]) {
                [htmlString appendString:trainerDiabetes];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Lower back"]) {
                [htmlString appendString:trainerLowerBack];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Spondilytis"]) {
                [htmlString appendString:trainerSpon];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Knee"]) {
                [htmlString appendString:trainerKnee];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Wrist"]) {
                [htmlString appendString:trainerWrist];
            } else if ([[results stringForColumn:@"name"] isEqualToString:@"Pregnancy"]) {
                [htmlString appendString:trainerPregnancy];
            }
        }
    }
    
    [database close];
    
    [htmlString appendString:@"</body></html>"];
    
    [_webView loadHTMLString:htmlString baseURL:nil];
    [self longPress:self.webView];
}

- (void)longPress:(UIView *)webView {
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    
    // Making sure the allowable movement isn't too narrow
    longPress.allowableMovement=100;
    // This is important - the duration must be long enough to allow taps but not longer than the period in which the scroll view opens the magnifying glass
    longPress.minimumPressDuration=0.3;
    
    longPress.delaysTouchesBegan=YES;
    longPress.delaysTouchesEnded=YES;
    
    longPress.cancelsTouchesInView=YES; // That's when we tell the gesture recognizer to block the gestures we want
    
    [webView addGestureRecognizer:longPress]; // Add the gesture recognizer to the view and scroll view then release
    [webView addGestureRecognizer:longPress];
}

// I just need this for the selector in the gesture recognizer.
- (void)handleLongPress {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initializeStrings {
    
    /**********************************************************  NUTRITIONIST ************************************************************/
    
    heart = @"<div id='Heart'><br/><h4>Blood Pressure - Hypertension</h4><h5>Do's</h5><hr/><ul><li>Have lot of vegetables and fruits.</li><li>Use low fat dairy products.</li><li>Consume whole grains and lean meat, fish and poultry.</li><li>Limit fast foods, canned foods or foods that are bought prepared.</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid Saturated fats and Trans Fats.</li><li>Restrict the intake of table salt.</li><li>Avoid Alcohol and Smoking.</li></ul></div><div id='Heart'><br/><h4>Blood Pressure - Hypotension</h4><h5>Do's</h5><hr/><ul><li>Include more salt in your diet.</li><li>Eating smaller meals, more often.</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid caffeine at night.</li><li>Limit alcohol intake.</li></ul></div>";
    
    diabetes = @"<div id='Diabetes'><br/><h4>Diabetes </h4><h5>Do's</h5><hr/><p>Include the following in your diet regularly</p><ul><li>Fenugreek (methi)- 1-2tspn/day</li><li>Indian blackberry (jamun)- 8-10/day</li><li>Garlic- 2-3 cloves/day</li><li>Flaxseed- 1-2tspn/day </li><li>Fibre- 25-30gms/day </li></ul><h5>Don'ts</h5><hr/><p>Use the following foods in moderation</p><ul><li>Salt </li><li>Sugar </li><li>Fat </li><li>Whole milk and products </li><li>Tea and coffee</li><li>White flour and its products</li><li>Foods with a high glycemic index.</li></ul></div>";
    
    pregnancy = @"<div id='Pregnancy'><br/><h4>Pregnancy</h4><h5>Do's</h5><hr/><ul><li>Eat plenty of calcium (milk, cheese, yoghurt).</li><li>Include protein (lean meat, chicken and fish, eggs and pulses) in your diet.</li><li>Eat iron rich foods(fortified cereals, red meat, pulses, bread, green veg).</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid caffeine intake.</li><li>Do not consume liver or liver products.</li><li>Avoid raw shellfish.</li></ul></div>";
    
    thyroid = @"<div id='Thyroid (HyproThyroid)'><br/><h4>Thyroid (HyproThyroid)</h4><h5>Do's</h5><hr/><ul><li>Eat Foods high in Vitamin B and Iron such as fresh vegetables and whole grains.</li><li>Eat more of Almonds, Sesame Seeds, and Oats.</li><li>Eat foods high in antioxidants, including fruits such as blueberries, cherries, and tomatoes.</li><li>Include omega 3 sources like fish, walnuts, etc.</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid High levels of Caffeine.</li><li>Avoid goitrogens like broccoli, cabbage, brussels sprouts, cauliflower, kale, spinach, turnips, soybeans, peanuts, linseed, pine nuts, millets.</li></ul></div>";
    
    cholestrol = @"<div id='Cholestrol'><br/><h4>Cholestrol</h4><h5>Do's</h5><hr/><ul><li>Consume vegetables, soy products, protein rich foods, and a high fiber diet.</li><li>Include lot of walnuts, flaxseeds, fish, oats, whole wheat bran and whole grain in your diet.</li><li>Drink at least 8-10 glasses of water each day.</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid red meats, organ meats and all those junk foods that contain a high amount of toxic trans-fats and saturated fats.</li><li>Avoid refined and processed foods.</li><li>Avoid high fat dairy products, instead use low fat variety.</li><li>Use salt in moderation.</li></ul></div>";
    
    pcos = @"<div id='PCOS'><br/><h4>PCOS</h4><h5>Do's</h5><hr/><ul><li>Increase the intake of Fiber in your diet.</li><li>Include omega 3 rich food like fish, walnuts in your diet.</li></ul><h5>Don'ts</h5><hr/><ul><li>Don't Eat High-Sugar Foods.</li></ul></div>";
    
    /**********************************************************  TRAINER ******************************************************************/
    
    trainerHeart = @"<div><br/><h4>Hypertension</h4><h5>Do's</h5><hr/><ul><li>Make physical activity a part of your lifestyle.</li><li>Be regular with your medication.</li><li>Be physically active for 30 to 60 minutes on most days of the week mostly cardio. Remember that even a little bit of activity is better than no activity at all.</li><li>Lift light weights for 15 to 20 reps as a circuit training during weight training days.</li><li>Choose the following more often: vegetables, fruit, low fat dairy products, food low in saturated and Trans fat and salt, whole grains and lean meat, fish and poultry. Limit fast foods, canned foods or foods that are bought prepared.</li><li>Use less oil, ghee, butter, margarine, shortening, and salad dressings.</li><li>If you are overweight, losing about 10 lbs (5kgs) will lower your blood pressure, and reducing your weight to within a healthy range will lower your blood pressure even more.</li><li>Alcohol- If you drink alcohol, limit the amount to two drinks a day or less. A regular-sized bottle or can of beer, 1.5 oz. of hard liquor, or a regular sized glass of wine are all equal to a single alcoholic drink.</li><li>Smoking- It is important to stop smoking if you have high blood pressure. Smoking increases that risk of developing heart problems and other diseases. Living and working places that are smoke free are also important.</li></ul><h5>Don'ts</h5><hr/><ul><li>Consume too much salt.</li><li>Stop consuming alcohol</li><li>Spend more time in warm-ups and cool downs.</li><li>Hold your breath while lifting weights.</li><li>Grip weights tightly.</li><li>Run or do activities which will suddenly elevate your blood pressure.</li><li>Smoke.</li><li>Stop medicines without doctor's advice.</li><li>Do not eat food in Hotels, Shops etc. as they contain too much oils which are very un-hygienic too. So, prefer only homely food.</li></ul></div>";
    
    trainerDiabetes = @"<div><br/><h4>Diabetes</h4><h5>Do's</h5><hr/><ul><li>Maintain good control over blood glucose levels.</li><li>Check your eyes, feet and kidneys, once in a year, as they are the main organs to be affected by high blood glucose levels.</li><li>Continue taking insulin and other medicines as prescribed by the Doctor.</li><li>Check your blood lipid levels and blood pressure at regular intervals.</li><li>Always carry sugar/sweet candy in your pocket if taking medicines for Diabetes as they may lower blood glucose levels.</li><li>Please check the lowering of blood glucose levels by knowing the symptoms like extreme weakness and numbness in the hands.</li><li>Exercise in the morning is good as it raises your body activity level and this will result in more burning of the calories throughout the day.</li><li>Always consult your Doctor in case of any doubts regarding eating habits, exercise and medication.</li><li>Have protein with meals. Lean protein is great for people with diabetes because it does not raise blood sugar levels and it helps you feel satisfied.  Give up on healthy eating.</li><li>Eat fruits and vegetables daily. The recommendation is to eat five servings of fruits and vegetables daily. If you are not coming close to this recommendation, make sure you are eating at least some fruit and vegetables every day and then work toward the bigger goal of five servings per day.</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid taking tobacco and alcohol.</li><li>Do not miss the daily dose of medicine.</li><li>Eating sweets and taking more medicines to lower blood glucose levels should be avoided.</li><li>Do not over exercise in such a way that there may be a sudden fall of blood glucose levels.</li><li>Avoid overeating.</li><li>Avoid fasting.</li><li>Do not drink soda or sweetened drinks unless you are hypoglycemic (having a low blood sugar episode.)</li><li>Skipping meals isn't good for your metabolism and it can lead to overeating at the next meal. Depending on your diabetes medication, skipping meals may also cause hypoglycemia.</li></ul></div>";
    
    trainerLowerBack = @"<div><br/><h4>Lower back</h4><h5>Do's</h5><hr/><ul><li>Perform  back stretches to calm low-back spasms in the mornings and evenings.</li><li>Exercise in a pain-free zone. Don't work through the pain.If it hurts to bend backward, don't bend. Pressing into a painful position can cause further tissue damage and aggravate existing damage.</li><li>Straighten up. Slumping and slouching is often a culprit in back pain symptoms, The pelvis can tilt to stabilize additional weight on the skeletal system, causing lower-back muscles to tighten.If you tend to slouch, practice good posture.</li><li>Use proper biomechanics when lifting.Bend from the knees and hip to lift any object off the floor.</li><li>Wear shorter-heeled shoes. Wearing high heels may also contribute to an unstable postural alignment.</li></ul><h5>Don'ts</h5><hr/><ul><li>Do not just take a long bed rest it will aggravate the back pain.</li><li>Don't skip your warm-up. Many back pain issues occur when we suddenly put pressure on the spine without warming up.Before attempting activities such as resistance exercises or working in the garden, perform some simple stretches.</li><li>Don't lift heavy objects or practice high-impact moves.Don't lift weights overhead or on your shoulders.</li><li>Rush in to a new workout.</li><li>Don't ignore the hurt and continue with exercise or it may get worse.</li></ul></div>";
    
    trainerSpon = @"<div><br/><h4>Spondylitis</h4><h5>Do's</h5><hr/><ul><li>In case of neck pain, always wear cervical collar, it will give you huge relief from neck pain.</li><li>Go for regular walk and light aerobic exercises.</li><li>Always take care when you stand up from lying down position. Do not turn one side while getting up.</li><li>If you are facing severe pain take rest and take medication suggested by your physician.</li><li>Do regular exercise to maintain neck strength, flexibility and range of motion.</li><li>Wear a cervical collar during the day.</li><li>Regularly walk or engage in low-impact aerobic activity.</li><li>Use a seat belt when in a car and use firm collar while traveling.</li><li>When in acute pain take rest, immobilize the neck, and take medications as directed.</li></ul><h5>Don'ts</h5><hr/><ul><li>Never sleep in comfortable mattresses and avoid using soft pillow. Instead of it, use thin and firm mattress as it will keep your body straight and reduce pain. Do not take many pillows below the neck and shoulder while sleeping.</li><li>Never skip exercises. To treat this problem, exercises is the only way to reduce the pain. Make a routine of regular exercise. It will help you to maintain spine and neck's flexibility and strength.</li><li>Do not hold head for long time in same position for long time. Always take break while working on computer, watching TV or driving.</li><li>Do not lift heavy weights on head or back.</li><li>Avoid bad roads, if traveling by two or four wheelers.</li><li>Do not drive for long hours; take breaks.</li><li>Avoid habit of holding the telephone on one shoulder and leaning at it for long time.</li><li>Do not lie flat on your stomach.</li><li>In order to turn around, do not twist your neck or the body; instead turn around by moving your feet first.</li><li>Do not undergo spinal manipulations if you are experiencing acute pain.</li><li>If you are suffering from severe neck pain and cervical pain, avoid doing aerobics and exercises.</li><li>Never lift heavy weight.</li><li>Avoid lifting weight overhead.</li></ul></div>";
    
    trainerKnee = @"<div><br/><h4>Knee Pain</h4><h5>Do's</h5><hr/><ul><li>Try aqua aerobics as this will prevent joint loading and cause injury.</li><li>Slow walking on treadmills.</li><li>Perform strength training exercises for lower body.Like a natural knee brace, stronger muscles will help compensate for weak or injured tendons, ligaments, and joints.</li><li>Do warm up and stretch. Warm, flexible muscles aren't injured as easily.</li></ul><h5>Don'ts</h5><hr/><ul><li>Never exercise or stretch to the point of pain.</li><li>Push through an acute injury.</li><li>Bounce when you stretch.</li><li>Rush in to a new workout.</li><li>Skip rest days.</li><li>Skip stretching.</li><li>Wear worn-out shoes, Imbalanced footwear can affect your gait and balance, which can contribute to knee and hip pain.</li><li>Too much rest can weaken your muscles, which can worsen joint pain. Find an exercise program that is safe for your knees and stick with it.</li><li>Don't exercise on hard surfaces and avoid high impact exercises like aerobics or kickboxing.</li></ul></div>";
    
    trainerWrist = @"<div><br/><h4>Wrist Pain / Injury</h4><h5>Do's</h5><hr/><ul><li>If your work demands too much use of wrist the give some rest in between.</li><li>You can do ISOMETRIC DUMBBELL HOLDS which can strengthen your forearm muscles.</li><li>Always use true grip when you do any exercise as if you exercise with falsegrip that would give excessive compressive load at your wrist.</li><li>Use a wrist band for support when required while lifting weights.</li></ul><h5>Don'ts</h5><hr/><ul><li>Do not take  pain In Your Wrist.</li><li>Never exercise or stretch to the point of pain.</li><li>Avoid wrist curls since it gives the excessive stress on your wrist and can lead to one of the dangerous wrist injury which is known as Capell Tunnel Syndrome.</li></ul></div>";
    
    trainerPregnancy = @"<div><br/><h4>Pregnancy</h4><h5>Do's</h5><hr/><ul><li>Drink plenty of fluids. If you don't drink enough fluids, your nausea might get worse. Keep a water bottle at your desk or in your work area and sip throughout the day. </li><li>Eat foods rich in iron and protein. Fatigue can be a symptom of iron deficiency anemia, but adjusting your diet can help. Choose foods such as red meat, poultry, seafood, leafy green vegetables, iron-fortified whole-grain cereal and beans.</li><li>Take short, frequent breaks. Getting up and moving around for a few minutes can reinvigorate you. Spending a few minutes with the lights off, your eyes closed and your feet up also can help you recharge. </li><li>Cut back on activities. Scaling back can help you get more rest when your workday ends. Consider doing your shopping online or hiring someone to clean the house or take care of the yard.</li><li>Keep up your fitness routine. Although exercise might be the last thing on your mind at the end of a long day, physical activity can help boost your energy level - especially if you sit at a desk all day. Take a walk after work or join a prenatal fitness class, as long as your health care provider says it's OK. </li><li>Go to bed early. Aim for seven to nine hours of sleep every night. Resting on your side will improve blood flow to your baby and help prevent swelling. For added comfort, place pillows between your legs and under your belly. </li><li>While Sitting on chair use a small pillow or cushion to provide extra support for your back. </li><li>Avoid prolonged standing as it might lead to leg ,back pain or dizziness.</li><li>Wear comfortable shoes with good arch support.</li><li>While bending and bend at your knees, not your waist. Keep the load close to your body, lifting with your legs - not your back. Avoid twisting your body while lifting.</li><li>If you have not exercised before pregnancy begin with as little as five minutes of physical activity a day. Build up to 10 mins,15 mins at finally reach at least 30 minutes a day.</li><li>You exercised before pregnancy. You can probably continue to work out at the same level while you're pregnant - as long as you're feeling comfortable and your health care provider says it's OK.</li></ul><h5>Don'ts</h5><hr/><ul><li>Avoid taking tobacco and alcohol.  </li><li>Avoid any exercises that force you to lie flat on your back after your first trimester </li><li>Avoid activities that pose a high risk of falling - such as downhill skiing, gymnastics, water skiing, surfing and horseback riding </li><li>Avoid exercise at high altitude </li><li>Stop the exercise immediately if you have<ol><li>Dizziness</li><li>Headache</li><li>Increased shortness of breath</li><li>Chest pain</li><li>Uneven or rapid heartbeat</li><li>Uterine contractions that continue after rest</li><li>Vaginal bleeding</li><li>Fluid leaking or gushing from your vagina </li><li>Decreased fetal movement</li><li>If your signs and symptoms continue after you stop exercising, contact your health care provider.</li></ol></li></ul></div>";
}

@end
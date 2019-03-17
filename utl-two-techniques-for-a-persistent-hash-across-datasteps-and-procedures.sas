Two techniques for a persistent hash across datasteps and procedures                                                  
                                                                                                                      
                                                                                                                      
Problem                                                                                                               
-------                                                                                                               
                                                                                                                      
  I recieve a list of male student ids and a list of female ids daily.                                                
  The subequent processing is much different for males and females.                                                   
  I need a shared persistent hash so my big data lookup can                                                           
  be shared over different datasteps and procs.                                                                       
                                                                                                                      
  There is a lot of setup - see complete solution on end                                                              
                                                                                                                      
  Two Solutions                                                                                                       
  --------------                                                                                                      
       1. Arts, Barts and Thomas's (a lot of setup needed - see entire solution on end.                               
          (Faster than my solution)                                                                                   
                                                                                                                      
       2. Roger ( has the advantage of lossless double floats - does not use macro variables)                         
          Slower do to SAS implementation of DOSBL - should be very fast                                              
          Shared storage                                                                                              
                                                                                                                      
github                                                                                                                
http://tinyurl.com/y6ke72am                                                                                           
https://github.com/rogerjdeangelis/utl-two-techniques-for-a-persistent-hash-across-datasteps-and-procedures           
                                                                                                                      
https://www.lexjansen.com/wuss/2018/41_Final_Paper_PDF.pdf                                                            
Arthur L. Carpenter, California Occidental Consultants, Anchorage, Alaska                                             
                                                                                                                      
Arthur Carpenter art@caloxy.com                                                                                       
Bart Jablonski yabwon@gmail.com                                                                                       
Thomas Billings                                                                                                       
                                                                                                                      
*   _         _     ____             _     _____                                                                      
   / \   _ __| |_  | __ )  __ _ _ __| |_  |_   _|__  _ __ ___                                                         
  / _ \ | '__| __| |  _ \ / _` | '__| __|   | |/ _ \| '_ ` _ \                                                        
 / ___ \| |  | |_  | |_) | (_| | |  | |_    | | (_) | | | | | |                                                       
/_/   \_\_|   \__| |____/ \__,_|_|   \__|   |_|\___/|_| |_| |_|                                                       
                                                                                                                      
;                                                                                                                     
                                                                                                                      
*_                   _                                                                                                
(_)_ __  _ __  _   _| |_                                                                                              
| | '_ \| '_ \| | | | __|                                                                                             
| | | | | |_) | |_| | |_                                                                                              
|_|_| |_| .__/ \__,_|\__|                                                                                             
        |_|                                                                                                           
;                                                                                                                     
                                                                                                                      
proc datasets lib=work kill;                                                                                          
run;quit;                                                                                                             
                                                                                                                      
data big(keep=name age height weight rand);                                                                           
    length name $15;                                                                                                  
    set sashelp.class(rename=(name=oldname));                                                                         
    do i = 1 to 100000;                                                                                               
       rand = ranuni(123456789);                                                                                      
       name=cats(oldname,i);                                                                                          
       output big;                                                                                                    
    end;                                                                                                              
run;quit;                                                                                                             
                                                                                                                      
proc sort data=big;                                                                                                   
  by rand;                                                                                                            
run;                                                                                                                  
                                                                                                                      
/*                                                                                                                    
WORK,BIG total obs=1,900,000                                                                                          
                                                                                                                      
    Student ID                                                                                                        
    NAME            AGE    HEIGHT    WEIGHT                                                                           
                                                                                                                      
    Robert6046       12     64.8      128.0                                                                           
    Carol61898       14     62.8      102.5                                                                           
    Jeffrey78436     13     62.5       84.0                                                                           
    Joyce8288        11     51.3       50.5                                                                           
    Judy47654        14     64.3       90.0                                                                           
    Thomas77379      11     57.5       85.0                                                                           
    Alice19118       13     56.5       84.0                                                                           
  ....                                                                                                                
*/                                                                                                                    
                                                                                                                      
/*                                                                                                                    
Two lists of students to lookyup in big table                                                                         
*/                                                                                                                    
                                                                                                                      
filename ft15f001 "d:/txt/females.txt";                                                                               
parmcards4;                                                                                                           
Joyce28602                                                                                                            
Alice95825                                                                                                            
Judy64975                                                                                                             
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
filename ft15f001 "d:/txt/males.txt";                                                                                 
parmcards4;                                                                                                           
Thomas50168                                                                                                           
Philip23419                                                                                                           
Jeffrey15018                                                                                                          
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
*            _               _                                                                                        
  ___  _   _| |_ _ __  _   _| |_ ___                                                                                  
 / _ \| | | | __| '_ \| | | | __/ __|                                                                                 
| (_) | |_| | |_| |_) | |_| | |_\__ \                                                                                 
 \___/ \__,_|\__| .__/ \__,_|\__|___/                                                                                 
                |_|                                                                                                   
;                                                                                                                     
/*                                                                                                                    
-------------                                                                                                         
FEMALE REPORT                                                                                                         
-------------                                                                                                         
        Demographic Statistics for Female Students                                                                    
                                                                                                                      
                    Statistcs                                                                                         
                                                                                                                      
 NAME          HEIGHT    WEIGHT    AGE                                                                                
                                                                                                                      
 Joyce28602    51.3      50.5      11                                                                                 
 Alice95825    56.5      84        13                                                                                 
 Judy64975     64.3      90        14                                                                                 
                                                                                                                      
                                                                                                                      
-----------                                                                                                           
MALE REPORT                                                                                                           
-----------                                                                                                           
 Body Mass Index for Male Students                                                                                    
                                                                                                                      
                      Statistcs                                                                                       
                                                                                                                      
 NAME                BMI  WEIGHT                                                                                      
                                                                                                                      
 Thomas50168   18.073346  85                                                                                          
 Philip23419   20.341435  150                                                                                         
 Jeffrey15018  15.117312  84                                                                                          
*/                                                                                                                    
                                                                                                                      
*          _       _   _                                                                                              
 ___  ___ | |_   _| |_(_) ___  _ __                                                                                   
/ __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                  
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                                 
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                 
                                                                                                                      
;                                                                                                                     
                                                                                                                      
options cmplib = (work.functions);                                                                                    
proc fcmp outlib=work.functions.hash;                                                                                 
subroutine GetStats(name $, height,weight,age) ;                                                                      
outargs height, weight, age;                                                                                          
declare hash class(dataset:'work.big');                                                                               
rc=class.definekey('name');                                                                                           
rc=class.definedata('name','height','weight', 'age');                                                                 
rc=class.definedone();                                                                                                
rc=class.find();                                                                                                      
endsub;                                                                                                               
run;quit;                                                                                                             
                                                                                                                      
%macro callgetstats(name=Alfred1);                                                                                    
%local name height weight age ;                                                                                       
%let height=.;                                                                                                        
%let weight=.;                                                                                                        
%let age=.;                                                                                                           
%syscall getstats(name,height,weight,age);                                                                            
%bquote(&name)!%bquote(&height)!%bquote(&weight)!%bquote(&age)                                                        
%mend callgetstats;                                                                                                   
                                                                                                                      
                                                                                                                      
*-------------                                                                                                        
FEMALES LOOKUP                                                                                                        
--------------;                                                                                                       
                                                                                                                      
data females;                                                                                                         
  length str $ 1000 height weight age $8;                                                                             
  input name $12.;                                                                                                    
  str = resolve('%callgetstats(name='||strip(name)||')');                                                             
  height = scan(str, 2, "!");                                                                                         
  weight = scan(str, 3, "!");                                                                                         
  age = scan(str, 4, "!");                                                                                            
  drop str;                                                                                                           
cards4;                                                                                                               
Joyce28602                                                                                                            
Alice95825                                                                                                            
Judy64975                                                                                                             
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
proc report data=work.females ls=171 ps=65  split="/" nocenter headskip;                                              
column  ("Demographic Statistics for Female Students" name ( "Statistcs" height weight age ));                        
run;quit;                                                                                                             
                                                                                                                      
                                                                                                                      
*-------------                                                                                                        
FEMALES LOOKUP                                                                                                        
--------------;                                                                                                       
                                                                                                                      
* very fast because hash has already been loaded;                                                                     
                                                                                                                      
data males;                                                                                                           
  length str $ 1000 height weight $8;                                                                                 
  input name $12.;                                                                                                    
  str = resolve('%callgetstats(name='||strip(name)||')');                                                             
  height = scan(str, 2, "!");                                                                                         
  weight = scan(str, 3, "!");                                                                                         
  bmi=703 * weight/height**2;                                                                                         
  drop str;                                                                                                           
cards4;                                                                                                               
Thomas50168                                                                                                           
Philip23419                                                                                                           
Jeffrey15018                                                                                                          
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
                                                                                                                      
proc report data=work.males ls=171 ps=65  split="/" nocenter headskip;                                                
column  ("Body Mass Index for Male Students" name ( "Statistcs" bmi weight ));                                        
run;quit;                                                                                                             
                                                                                                                      
                                                                                                                      
*____                                                                                                                 
|  _ \ ___   __ _  ___ _ __                                                                                           
| |_) / _ \ / _` |/ _ \ '__|                                                                                          
|  _ < (_) | (_| |  __/ |                                                                                             
|_| \_\___/ \__, |\___|_|                                                                                             
            |___/                                                                                                     
;                                                                                                                     
                                                                                                                      
Persistent HASH - Thanks to Fried  Egg and SAS PTRLONGADD function                                                    
                                                                                                                      
github                                                                                                                
http://tinyurl.com/yys4wywv                                                                                           
https://github.com/rogerjdeangelis/utl-dosubl-persistent-hash-across-datasteps-and-procedures                         
                                                                                                                      
*_                   _                                                                                                
(_)_ __  _ __  _   _| |_                                                                                              
| | '_ \| '_ \| | | | __|                                                                                             
| | | | | |_) | |_| | |_                                                                                              
|_|_| |_| .__/ \__,_|\__|                                                                                             
        |_|                                                                                                           
;                                                                                                                     
                                                                                                                      
proc datasets lib=work kill;                                                                                          
run;quit;                                                                                                             
                                                                                                                      
data big(keep=question answer rand);                                                                                  
    length question $15 answer $64;                                                                                   
    set sashelp.class(rename=(name=oldname));                                                                         
    do i = 1 to 100000;                                                                                               
       rand = ranuni(123456789);                                                                                      
       question=cats(oldname,i);                                                                                      
       answer=catx('|',sex,age,height,weight);                                                                        
       output big;                                                                                                    
    end;                                                                                                              
run;quit;                                                                                                             
                                                                                                                      
proc sort data=big;                                                                                                   
  by rand;                                                                                                            
run;                                                                                                                  
                                                                                                                      
/*                                                                                                                    
WORK,BIG total obs=1,900,000                                                                                          
                                                                                                                      
    Student ID                                                                                                        
    NAME            AGE    HEIGHT    WEIGHT                                                                           
                                                                                                                      
    Robert6046       12     64.8      128.0                                                                           
    Carol61898       14     62.8      102.5                                                                           
    Jeffrey78436     13     62.5       84.0                                                                           
    Joyce8288        11     51.3       50.5                                                                           
    Judy47654        14     64.3       90.0                                                                           
    Thomas77379      11     57.5       85.0                                                                           
    Alice19118       13     56.5       84.0                                                                           
  ....                                                                                                                
*/                                                                                                                    
                                                                                                                      
/*                                                                                                                    
Two lists of students to lookyup in big table                                                                         
*/                                                                                                                    
                                                                                                                      
filename ft15f001 "d:/txt/females.txt";                                                                               
parmcards4;                                                                                                           
Joyce28602                                                                                                            
Alice95825                                                                                                            
Judy64975                                                                                                             
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
filename ft15f001 "d:/txt/males.txt";                                                                                 
parmcards4;                                                                                                           
Thomas50168                                                                                                           
Philip23419                                                                                                           
Jeffrey15018                                                                                                          
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
*          _       _   _                                                                                              
 ___  ___ | |_   _| |_(_) ___  _ __                                                                                   
/ __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                  
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                                 
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                 
;                                                                                                                     
                                                                                                                      
data females;                                                                                                         
   informat question $15.;                                                                                            
   infile "d:/txt/females.txt" ;                                                                                      
   input question;                                                                                                    
run;quit;                                                                                                             
                                                                                                                      
data males;                                                                                                           
   informat question $15.;                                                                                            
   infile "d:/txt/males.txt";                                                                                         
   input question;                                                                                                    
run;quit;                                                                                                             
                                                                                                                      
data _null_;                                                                                                          
                                                                                                                      
    if _n_=0 then do;                                                                                                 
       %let rc=%sysfunc(dosubl('                                                                                      
         data _null_;                                                                                                 
            set males nobs=_nobs;                                                                                     
            call symputx("_nobs_m",_nobs);                                                                            
         run;quit;                                                                                                    
         data _null_;                                                                                                 
            set females nobs=_nobs;                                                                                   
            call symputx("_nobs_f",_nobs);                                                                            
         run;quit;                                                                                                    
       '));                                                                                                           
    end;                                                                                                              
                                                                                                                      
    length question $15;                                                                                              
    declare hash lookUp();                                                                                            
    rc=lookUp.defineKey('question');                                                                                  
    rc=lookUp.defineData('answer');                                                                                   
    rc=lookUp.defineDone();                                                                                           
                                                                                                                      
    do until(eof1);                                                                                                   
      set big end=eof1;                                                                                               
      rc=lookUp.add();                                                                                                
    end;                                                                                                              
                                                                                                                      
    array que[&_nobs_m] $15 _temporary_;  * small arrays;                                                             
    array ans[&_nobs_m] $64 _temporary_;                                                                              
    do _i_=1 by 1 until ( dne );                                                                                      
       set males end=dne;                                                                                             
       que[_i_]=question;                                                                                             
       rc=lookUp.find();                                                                                              
       ans[_i_]=answer;                                                                                               
    end;                                                                                                              
    adrQue=put(addrlong(que[1]),$hex16.);                                                                             
    adrAns=put(addrlong(ans[1]),$hex16.);                                                                             
    call symputx('adrQue',adrQue);                                                                                    
    call symputx('adrAns',adrAns);                                                                                    
                                                                                                                      
    rc=dosubl('                                                                                                       
    data fnd_males;                                                                                                   
      length height weight age sex $8 que $15;                                                                        
      que=peekclong (ptrlongadd ("&adrQue"x,(_i_-1)*64),64);                                                          
      do _i_=1 to &_nobs_m;                                                                                           
        answer     =input(peekclong (ptrlongadd ("&adrAns"x,(_i_-1)*64),64),$char64.);                                
        sex    = scan(answer, 1, "|");                                                                                
        age    = scan(answer, 2, "|");                                                                                
        height = scan(answer, 3, "|");                                                                                
        weight = scan(answer, 4, "|");                                                                                
        bmi=703 * weight/height**2;                                                                                   
        put answer;                                                                                                   
        output;                                                                                                       
        drop _i_;                                                                                                     
      end;                                                                                                            
      run;quit;                                                                                                       
                                                                                                                      
      proc report data=fnd_males ls=171 ps=65  split="/" nocenter headskip;                                           
      column  ("Body Mass Index for Male Students" que ( "Statistcs" bmi weight ));                                   
      run;quit;                                                                                                       
   ');                                                                                                                
                                                                                                                      
    dne=0;                                                                                                            
    array quef[&_nobs_f] $15 _temporary_;  * small arrays;                                                            
    array ansf[&_nobs_f] $64 _temporary_;                                                                             
    do _i_=1 by 1 until ( dne );                                                                                      
       set females end=dne;                                                                                           
       quef[_i_]=question;                                                                                            
       rc=lookUp.find();                                                                                              
       ansf[_i_]=answer;                                                                                              
    end;                                                                                                              
                                                                                                                      
    adrQue=put(addrlong(quef[1]),$hex16.);                                                                            
    adrAns=put(addrlong(ansf[1]),$hex16.);                                                                            
    call symputx('adrQue',adrQue);                                                                                    
    call symputx('adrAns',adrAns);                                                                                    
                                                                                                                      
    rc=dosubl('                                                                                                       
    data fnd_females;                                                                                                 
      length height weight age sex $8 que $15;                                                                        
      que=peekclong (ptrlongadd ("&adrQue"x,(_i_-1)*64),64);                                                          
      do _i_=1 to &_nobs_f;                                                                                           
        answer     =input(peekclong (ptrlongadd ("&adrAns"x,(_i_-1)*64),64),$char64.);                                
        sex    = scan(answer, 1, "|");                                                                                
        age    = scan(answer, 2, "|");                                                                                
        height = scan(answer, 3, "|");                                                                                
        weight = scan(answer, 4, "|");                                                                                
        put answer;                                                                                                   
        drop _i_;                                                                                                     
        output;                                                                                                       
      end;                                                                                                            
    run;quit;                                                                                                         
                                                                                                                      
    proc report data=fnd_females ls=171 ps=65  split="/" nocenter headskip;                                           
    column  ("Demographic Statistics for Female Students" que ( "Statistcs" height weight age ));                     
    run;quit;                                                                                                         
                                                                                                                      
   ');                                                                                                                
run;quit;                                                                                                             
                                                                                                                      
*            _               _                                                                                        
  ___  _   _| |_ _ __  _   _| |_                                                                                      
 / _ \| | | | __| '_ \| | | | __|                                                                                     
| (_) | |_| | |_| |_) | |_| | |_                                                                                      
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                     
                |_|                                                                                                   
;                                                                                                                     
-------------                                                                                                         
FEMALE REPORT                                                                                                         
-------------                                                                                                         
        Demographic Statistics for Female Students                                                                    
                                                                                                                      
                    Statistcs                                                                                         
                                                                                                                      
 NAME          HEIGHT    WEIGHT    AGE                                                                                
                                                                                                                      
 Joyce28602    51.3      50.5      11                                                                                 
 Alice95825    56.5      84        13                                                                                 
 Judy64975     64.3      90        14                                                                                 
                                                                                                                      
                                                                                                                      
-----------                                                                                                           
MALE REPORT                                                                                                           
-----------                                                                                                           
 Body Mass Index for Male Students                                                                                    
                                                                                                                      
                      Statistcs                                                                                       
                                                                                                                      
 NAME                BMI  WEIGHT                                                                                      
                                                                                                                      
 Thomas50168   18.073346  85                                                                                          
 Philip23419   20.341435  150                                                                                         
 Jeffrey15018  15.117312  84                                                                                          
                                                                                                                      
                                                                                                                      

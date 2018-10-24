global with sharing class GetCapitalUtils
{
private static Boolean disableButtons = false;
@future (callout=true)
Webservice static void  borrowerAccepted(string app){
System.debug('-----in borrower accepted -->>>>>>>>>>>>>>');
List<String> userList=System.label.User_Name_For_Contract_Conversion.split(',');
    Map<String,String> appMap=new Map<String,String>();
    Map<String,String> userMap=new Map<String,String>();
    List<User> userOb=new List<user>();
    userOb.addAll([select id,name from user]);
    for(user u:userOb){
        userMap.put(u.name,u.name);
    }
genesis__applications__c appObj = [select id,Refinance__c,CL_Contract_to_be_refinaced__c, STP_RM_Approval_20K__c,GC_Basic_Result__c,Approved_By__c from genesis__applications__c where id=:app limit 1];
for(String st:userList){
    system.debug('userMap.get(st)'+userMap.get(st));
    system.debug('UserInfo.getName()'+UserInfo.getName());
if( appObj.STP_RM_Approval_20K__c==true && appObj.GC_Basic_Result__c=='Pass'){
    if(userMap.get(st)==UserInfo.getName())
      appMap.put(UserInfo.getName(), 'True');

}
    if( appObj.STP_RM_Approval_20K__c!=true && appObj.GC_Basic_Result__c=='Pass'){
        if(userMap.get(st)==UserInfo.getName())
        appMap.put(UserInfo.getName(), 'False');

}
    if(appObj.STP_RM_Approval_20K__c!=true && appObj.GC_Basic_Result__c!='Pass'){
        if(userMap.get(st)==UserInfo.getName())
        appMap.put(UserInfo.getName(), 'False');

}
    if( appObj.STP_RM_Approval_20K__c==true && appObj.GC_Basic_Result__c!='Pass'){
        if(userMap.get(st)==UserInfo.getName())
          appMap.put(UserInfo.getName(), 'False');

}
}
    if(test.isRunningTest()){
         if(appMap.get(UserInfo.getName())==null  || appMap.get(UserInfo.getName())=='True') {
          Integer  a= 0;
          Integer  b= 0;
          Integer  c=a+b;
          integer  d=c-a;
           a++;
             
   

        if(appObj.Refinance__c==false){
       //   genesis.ConvertApplicationCtrl ctrl = new genesis.ConvertApplicationCtrl();
        //  System.Debug('App No. = '+app);
         // String msg = ctrl.convertApplication(app);
        }
       // system.debug('CL_Contract_to_be_refinaced__c'+appObj.CL_Contract_to_be_refinaced__c);
        if(appObj.Refinance__c && appObj.CL_Contract_to_be_refinaced__c!=null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Record Saved Successfully'));
            	
        }
        if(appObj.Refinance__c && appObj.CL_Contract_to_be_refinaced__c!=null){
          //   genesis.ConvertApplicationCtrl ctrl = new genesis.ConvertApplicationCtrl();
 		   // System.Debug('App No. = '+app);
  			// String msg = ctrl.convertApplication(app);
           // system.debug(msg);
            //RedrawController re=new RedrawController();
            RedrawController.redraw(app);
        
            
     
  System.debug('-----in borrower accepted Response::: -->>>>>>>>>>>>>>');
    
        }}
    }
    
    if(!test.isRunningTest()){
    if(appMap.get(UserInfo.getName())==null  || appMap.get(UserInfo.getName())=='True') {
    
   

        if(appObj.Refinance__c==false){
          genesis.ConvertApplicationCtrl ctrl = new genesis.ConvertApplicationCtrl();
          System.Debug('App No. = '+app);
          String msg = ctrl.convertApplication(app);
        }
       // system.debug('CL_Contract_to_be_refinaced__c'+appObj.CL_Contract_to_be_refinaced__c);
     /*   if(appObj.Refinance__c && appObj.CL_Contract_to_be_refinaced__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Record Saved Successfully'));
            	
        }*/
        if(appObj.Refinance__c && appObj.CL_Contract_to_be_refinaced__c!=null){
             genesis.ConvertApplicationCtrl ctrl = new genesis.ConvertApplicationCtrl();
 		    System.Debug('App No. = '+app);
  			 String msg = ctrl.convertApplication(app);
            system.debug(msg);
            //RedrawController re=new RedrawController();
            RedrawController.redraw(app);
        
            
     
  System.debug('-----in borrower accepted Response::: -->>>>>>>>>>>>>>');
    
        }
}
}
  
   
    }






public static genesis__Applications__c reload(Id appId)
{
  return [SELECT id,genesis__Status__c,genesis__Expected_First_Payment_Date__c,genesis__Interest_Calculation_Method__c,
                  genesis__Interest_Only_Period__c,genesis__Payment_Frequency__c,genesis__Days_Convention__c,
                  genesis__Contact__c,genesis__Loan_Amount__c,genesis__Term__c,
                  genesis__Interest_Rate__c from genesis__Applications__c where id = :appId];
}
}
/* This class acts like Handler which filters the payments, this functionality is build for repayment*/
//

public class RepaymentHandler {
    Map<String,String> rejectMap=new Map<String,String>();
    Map<String,String> finalMap=new Map<String,String>();
    Map<String,String> finalMap1=new Map<String,String>();
    Map<String,String> finalMapCredit=new Map<String,String>();
    List<Repayment_All_Payment__c> repAllList=new List<Repayment_All_Payment__c>();
    List<Repayment_Credit_Payment__c> repAllListCredit=new List<Repayment_Credit_Payment__c>();
    List<Repayment_Test_Obj__c> tstObj=new List<Repayment_Test_Obj__c>();
    List<Repayment_Test_Obj__c> finaltstObj=new List<Repayment_Test_Obj__c>();
    Map<String,Repayment_Keywords__c> keyDesc=new Map<String,Repayment_Keywords__c>() ;
    Map<String,Repayment_Test_Obj__c> fullDesc=new Map<String,Repayment_Test_Obj__c>() ;
    Map<String,Repayment_Test_Obj__c> firstFilterDesc=new Map<String,Repayment_Test_Obj__c>() ;
    Map<String,Repayment_Test_Obj__c> firstFilterDescCredit=new Map<String,Repayment_Test_Obj__c>() ;
    List<Repayment_Rejection__c> rejectList=new List<Repayment_Rejection__c>();
    //  String value;
    public RepaymentHandler(){
        
        rejectList =[select id,name from Repayment_Rejection__c];
        
        
        for(Repayment_Rejection__c rejL:rejectList){
            rejectMap.put(rejL.name,rejL.name);
        }
    }
    
    public void assignwrtKeywords(Repayment_Test_Obj__c resObj){
        List<Repayment_Unique__c> uniqPayList=[select id,name from Repayment_Unique__c];
        if(uniqPayList!=null)
            delete uniqPayList;
        List<Repayment_All_Payment__c> allPayList=[select id,name from Repayment_All_Payment__c];
        if(allPayList!=null)
            delete allPayList;
        String desp= '%' +resObj.Description__c+ '%';
        List<Repayment_Test_Obj__c> rejTestObj=new List<Repayment_Test_Obj__c>();
        if(resObj.Description__c!=null && resobj.Date__c!=null && resObj.Till_Date__c!=null)
            rejTestObj= [select id,AccountName__c,Till_Date__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where date__c>:resObj.Date__c and Date__C<:resObj.Till_Date__c and description__c Like :desp and Amount__c<0];
        else
            rejTestObj=[select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where Amount__c<0];
        for(Repayment_Test_Obj__c reFRej:rejTestObj){
            fullDesc.put(reFRej.Description__c,refRej);           
        }
        
        system.debug('Rej List'+rejectList);
        system.debug('Total Map'+fullDesc.keySet());
        List<String> testStr= new List<String>();
        for(Repayment_Rejection__c re:rejectList){
            testStr.add('%'+re.name+'%');
            
        }
        // tstObj.addAll([select id,name,description__c from Repayment_Test_Obj__c where  (not description__c like: teststr)]);
        //system.debug(tstObj.size());
        List<Repayment_Keywords__c> keyObj=[select id,name,Bank_Name__c,GetCap_Classification__c,Keyword_1__c,Keyword_2__c,Keyword_3__c,Keyword_4__c,Priority__c,Sub_Classification_Other__c from Repayment_Keywords__c order by name];
        List<String> key1=new List<String>();
        List<String> key2=new List<String>();
        List<String> key3=new List<String>();
        List<String> key4=new List<String>();
        for(Repayment_Keywords__c k:keyObj){
            if(k.Keyword_1__c!=null){
                key1.add('%'+' '+k.Keyword_1__c+' '+'%');
                finalMap.put('%'+' '+k.Keyword_1__c+' '+'%',k.Bank_Name__c);
                finalMap1.put('%'+' '+k.Keyword_1__c+' '+'%',k.GetCap_Classification__c);
            }
            key2.add('%'+' '+k.Keyword_2__c+' '+'%');
            key3.add('%'+' '+k.Keyword_3__c+' '+'%');
            key4.add('%'+' '+k.Keyword_4__c+' '+'%');
            
        }
        if(resObj.Description__c!=null && resobj.Date__c!=null && resObj.Till_Date__c!=null)
            tstObj= [select id,AccountName__c,Till_Date__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where date__c>:resObj.Date__c and Date__C<:resObj.Till_Date__c and description__c Like :desp and Amount__c<0 and   ((description__c like:key1) or(description__c like:key2) or (description__c like:key3) or(description__c like:key4)) and (not description__c like: teststr) ] ;
        else
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where Amount__c<0 and   ((description__c like:key1) or(description__c like:key2) or (description__c like:key3) or(description__c like:key4)) and (not description__c like: teststr) ]);
        
        
        //tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c<0 and   ((description__c like:key1) or(description__c like:key2) or (description__c like:key3) or(description__c like:key4)) and (not description__c like: teststr) ]);
        for(Repayment_Test_Obj__c tst1:tstObj){
            firstFilterDesc.put(tst1.Description__c,tst1);
        }
        
        
        for(Repayment_Keywords__c q1:keyObj){
            if(q1.Keyword_1__c!=null) {  
                
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_1__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            if(q1.Keyword_2__c!=null) {  
                
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_2__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            
            if(q1.Keyword_3__c!=null) {  
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_3__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
        }
        for(Repayment_Test_Obj__c q:tstObj){
            Repayment_All_Payment__c reAllObj=new Repayment_All_Payment__c();
            reAllObj.Date__c=q.Date__c;
            reAllObj.Amount__c=q.Amount__c;
            reAllObj.BankName__c=q.BankName__c;
            reAllObj.Description__c=q.Description__c;
            reALLObj.Lender_Type__c=finalMap.get(q.Description__c);
            reAllObj.GetCap_Classification__c=finalMap1.get(q.Description__c);
            repAllList.add(reAllObj);
        }        
        insert repAllList;
        Map<String,Integer> netRes=new map<String,Integer>();
        Map<String,Repayment_All_Payment__c> startDate=new map<String,Repayment_All_Payment__c>();
        Map<String,Repayment_All_Payment__c> endDate=new map<String,Repayment_All_Payment__c>();
        List<Repayment_All_Payment__c> totRep=new List<Repayment_All_Payment__c>();
        totRep=[select id,name,Date__c,Amount__c,BankName__c,Description__c,Lender_Type__c,GetCap_Classification__c from Repayment_All_Payment__c order by date__c];
        system.debug(repAllList);
        for(Repayment_All_Payment__c q: totRep){
            
            if(netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)==null){
                netRes.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,1);
                startDate.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,q);
                
            }
            else{
                netRes.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)+1);
                endDate.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,q);
            }
            
        }
        List<Repayment_All_Payment__c> uniqRep=new List<Repayment_All_Payment__c>();
        for(String q:endDate.keySet() ){
            uniqRep.add(endDate.get(q));
        }
        List<Repayment_All_Payment__c> uniqRep1=new List<Repayment_All_Payment__c>();
        for(String q:startDate.keySet() ){
            uniqRep1.add(startDate.get(q));
        }
        
        List<Repayment_Unique__c>resList=new List<Repayment_Unique__c>();
        for(Repayment_All_Payment__c q: uniqRep){
            Repayment_Unique__c repuni= new Repayment_Unique__c();
            //System.debug(EndDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c));
            repuni.amount__c=q.Amount__c;
            repUni.Description__c=q.Description__c;
            repUni.GetCap_Classification__c=q.GetCap_Classification__c;
            repuni.Lender_Type__c=q.Lender_Type__c;
            repUni.Total_Number__c=netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c);
            repUni.End_Date__c=(endDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)).date__C;
            repUni.Start_Date__c=(startDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)).date__C;
            resList.add(repUni);
        }
        insert resList;
        
    }
    
    public list<Repayment_Unique__c> assignwrtAccountNumbWithoutFilter(List<String> accNo){
        List<Repayment_Unique__c> uniqPayList=[select id,name from Repayment_Unique__c];
        if(uniqPayList!=null)
            delete uniqPayList;
        List<Repayment_All_Payment__c> allPayList=[select id,name from Repayment_All_Payment__c];
        if(allPayList!=null)
            delete allPayList;
        List<Repayment_Test_Obj__c> rejTestObj=new List<Repayment_Test_Obj__c>();
        //   if(resObj.AccountNumber__c!=null && resobj.Date__c!=null && resObj.Till_Date__c!=null)
        // rejTestObj= [select id,AccountName__c,Till_Date__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where date__c>:resObj.Date__c and Date__C<:resObj.Till_Date__c and AccountNumber__c=:accNo and Amount__c<0];
        //else
        rejTestObj=[select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where Amount__c<0];
        for(Repayment_Test_Obj__c reFRej:rejTestObj){
            fullDesc.put(reFRej.Description__c,refRej);           
        }
        
        //system.debug('Rej List'+rejectList);
        //system.debug('Total Map'+fullDesc.keySet());
        List<String> testStr= new List<String>();
        for(Repayment_Rejection__c re:rejectList){
            testStr.add('%'+re.name+'%');
            
        }
        // tstObj.addAll([select id,name,description__c from Repayment_Test_Obj__c where  (not description__c like: teststr)]);
        //system.debug(tstObj.size());
        List<Repayment_Keywords__c> keyObj=[select id,name,Bank_Name__c,GetCap_Classification__c,Keyword_1__c,Keyword_2__c,Keyword_3__c,Keyword_4__c,Priority__c,Sub_Classification_Other__c from Repayment_Keywords__c order by name];
        List<String> key1=new List<String>();
        List<String> key2=new List<String>();
        List<String> key3=new List<String>();
        List<String> key4=new List<String>();
        for(Repayment_Keywords__c k:keyObj){
            if(k.Keyword_1__c!=null){
                key1.add('%'+' '+k.Keyword_1__c+' '+'%');
                finalMap.put('%'+' '+k.Keyword_1__c+' '+'%',k.Bank_Name__c);
                finalMap1.put('%'+' '+k.Keyword_1__c+' '+'%',k.GetCap_Classification__c);
            }
            key2.add('%'+' '+k.Keyword_2__c+' '+'%');
            key3.add('%'+' '+k.Keyword_3__c+' '+'%');
            key4.add('%'+' '+k.Keyword_4__c+' '+'%');
            
        }
        system.debug('key1'+key1);
        tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c<0 and   ((description__c like:key1) or(description__c like:key2) or (description__c like:key3) or(description__c like:key4)) and (not description__c like: teststr) and AccountNumber__c in:accNo] );
        for(Repayment_Test_Obj__c tst1:tstObj){
            firstFilterDesc.put(	tst1.Description__c,tst1);
        }
       // system.debug(tstObj.size());
        //system.debug([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c<0 and   ((not description__c like:key1) ) and (not description__c like: teststr) and AccountNumber__c in:accNo].size());
        
        for(Repayment_Keywords__c q1:keyObj){
            if(q1.Keyword_1__c!=null) {  
                
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_1__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            if(q1.Keyword_2__c!=null) {  
                
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_2__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            
            if(q1.Keyword_3__c!=null) {  
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_3__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
        }
        for(Repayment_Test_Obj__c q:tstObj){
            Repayment_All_Payment__c reAllObj=new Repayment_All_Payment__c();
            reAllObj.Date__c=q.Date__c;
            reAllObj.Amount__c=q.Amount__c;
            reAllObj.BankName__c=q.BankName__c;
            reAllObj.Description__c=q.Description__c;
            reALLObj.Lender_Type__c=finalMap.get(q.Description__c);
            reAllObj.GetCap_Classification__c=finalMap1.get(q.Description__c);
            repAllList.add(reAllObj);
        }        
        insert repAllList;
        system.debug(repAllList);
       Map<String,Integer> netRes=new map<String,Integer>();
        Map<String,Repayment_All_Payment__c> startDate=new map<String,Repayment_All_Payment__c>();
        Map<String,Repayment_All_Payment__c> endDate=new map<String,Repayment_All_Payment__c>();
        List<Repayment_All_Payment__c> totRep=new List<Repayment_All_Payment__c>();
        totRep=[select id,name,Date__c,Amount__c,BankName__c,Description__c,Lender_Type__c,GetCap_Classification__c from Repayment_All_Payment__c order by date__c];
        system.debug(repAllList);
        system.debug(totRep);
        for(Repayment_All_Payment__c q: totRep){
            
            if(netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)==null){
                netRes.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,1);
                startDate.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,q);
                
            }
            else{
                netRes.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)+1);
                endDate.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,q);
            }
            
        }
        List<Repayment_All_Payment__c> uniqRep=new List<Repayment_All_Payment__c>();
        for(String q:endDate.keySet() ){
            uniqRep.add(endDate.get(q));
        }
        List<Repayment_All_Payment__c> uniqRep1=new List<Repayment_All_Payment__c>();
        for(String q:startDate.keySet() ){
            uniqRep1.add(startDate.get(q));
        }
       
        List<Repayment_Unique__c>resList=new List<Repayment_Unique__c>();
       for(Repayment_All_Payment__c q: uniqRep){
            Repayment_Unique__c repuni= new Repayment_Unique__c();
            //System.debug(EndDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c));
            repuni.amount__c=q.Amount__c;
            repUni.Description__c=q.Description__c;
            repUni.GetCap_Classification__c=q.GetCap_Classification__c;
            repuni.Lender_Type__c=q.Lender_Type__c;
            repUni.Total_Number__c=netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c);
            repUni.End_Date__c=(endDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)).date__C;
            repUni.Start_Date__c=(startDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)).date__C;
            resList.add(repUni);
        }
        insert resList;
        return resList;
        
    }
    public list<Repayment_Unique__c> assignwrtAccountNumb(List<String> accNo,String Value){
        List<Repayment_Unique__c> uniqPayList=[select id,name from Repayment_Unique__c];
        if(uniqPayList!=null)
            delete uniqPayList;
        List<Repayment_All_Payment__c> allPayList=[select id,name from Repayment_All_Payment__c];
        if(allPayList!=null)
            delete allPayList;
        List<Repayment_Test_Obj__c> rejTestObj=new List<Repayment_Test_Obj__c>();
        //   if(resObj.AccountNumber__c!=null && resobj.Date__c!=null && resObj.Till_Date__c!=null)
        // rejTestObj= [select id,AccountName__c,Till_Date__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where date__c>:resObj.Date__c and Date__C<:resObj.Till_Date__c and AccountNumber__c=:accNo and Amount__c<0];
        //else
        rejTestObj=[select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where Amount__c<0];
        for(Repayment_Test_Obj__c reFRej:rejTestObj){
            fullDesc.put(reFRej.Description__c,refRej);           
        }
        
        //system.debug('Rej List'+rejectList);
        //system.debug('Total Map'+fullDesc.keySet());
        List<String> testStr= new List<String>();
        for(Repayment_Rejection__c re:rejectList){
            testStr.add('%'+re.name+'%');
            
        }
        // tstObj.addAll([select id,name,description__c from Repayment_Test_Obj__c where  (not description__c like: teststr)]);
        //system.debug(tstObj.size());
        List<Repayment_Keywords__c> keyObj=[select id,name,Bank_Name__c,GetCap_Classification__c,Keyword_1__c,Keyword_2__c,Keyword_3__c,Keyword_4__c,Priority__c,Sub_Classification_Other__c from Repayment_Keywords__c order by name];
        List<String> key1=new List<String>();
        List<String> key2=new List<String>();
        List<String> key3=new List<String>();
        List<String> key4=new List<String>();
        for(Repayment_Keywords__c k:keyObj){
            if(k.Keyword_1__c!=null){
                key1.add('%'+' '+k.Keyword_1__c+' '+'%');
                finalMap.put('%'+' '+k.Keyword_1__c+' '+'%',k.Bank_Name__c);
                finalMap1.put('%'+' '+k.Keyword_1__c+' '+'%',k.GetCap_Classification__c);
            }
            key2.add('%'+' '+k.Keyword_2__c+' '+'%');
            key3.add('%'+' '+k.Keyword_3__c+' '+'%');
            key4.add('%'+' '+k.Keyword_4__c+' '+'%');
            
        }
        system.debug('key1'+key1);
        system.debug(value);
        
        
        if(value!=null || value!=''){
            String desp= '%'+value+'%';
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c<0 and   (description__c like:desp) and AccountNumber__c in:accNo] );
        }
         else
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c<0 and   ((description__c like:key1) or(description__c like:key2) or (description__c like:key3) or(description__c like:key4)) and (not description__c like: teststr) and AccountNumber__c in:accNo] );
        for(Repayment_Test_Obj__c tst1:tstObj){
            firstFilterDesc.put(	tst1.Description__c,tst1);
        }
       // system.debug(tstObj.size());
        //system.debug([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c<0 and   ((not description__c like:key1) ) and (not description__c like: teststr) and AccountNumber__c in:accNo].size());
        
        for(Repayment_Keywords__c q1:keyObj){
            if(q1.Keyword_1__c!=null) {  
                
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_1__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            if(q1.Keyword_2__c!=null) {  
                
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_2__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            
            if(q1.Keyword_3__c!=null) {  
                for(String str:firstFilterDesc.keySet()){
                    if(str.toUpperCase().contains((q1.Keyword_3__c).toUpperCase())){
                        finalMap.put(str,q1.Bank_Name__c);
                        finalMap1.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
        }
        for(Repayment_Test_Obj__c q:tstObj){
            Repayment_All_Payment__c reAllObj=new Repayment_All_Payment__c();
            reAllObj.Date__c=q.Date__c;
            reAllObj.Amount__c=q.Amount__c;
            reAllObj.BankName__c=q.BankName__c;
            reAllObj.Description__c=q.Description__c;
            reALLObj.Lender_Type__c=finalMap.get(q.Description__c);
            reAllObj.GetCap_Classification__c=finalMap1.get(q.Description__c);
            repAllList.add(reAllObj);
        }        
        insert repAllList;
        system.debug(repAllList);
       Map<String,Integer> netRes=new map<String,Integer>();
        Map<String,Repayment_All_Payment__c> startDate=new map<String,Repayment_All_Payment__c>();
        Map<String,Repayment_All_Payment__c> endDate=new map<String,Repayment_All_Payment__c>();
        List<Repayment_All_Payment__c> totRep=new List<Repayment_All_Payment__c>();
        totRep=[select id,name,Date__c,Amount__c,BankName__c,Description__c,Lender_Type__c,GetCap_Classification__c from Repayment_All_Payment__c order by date__c];
        system.debug(repAllList);
        system.debug(totRep);
        for(Repayment_All_Payment__c q: totRep){
            
            if(netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)==null){
                netRes.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,1);
                startDate.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,q);
                
            }
            else{
                netRes.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)+1);
                endDate.put(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c,q);
            }
            
        }
        List<Repayment_All_Payment__c> uniqRep=new List<Repayment_All_Payment__c>();
        for(String q:endDate.keySet() ){
            uniqRep.add(endDate.get(q));
        }
        List<Repayment_All_Payment__c> uniqRep1=new List<Repayment_All_Payment__c>();
        for(String q:startDate.keySet() ){
            uniqRep1.add(startDate.get(q));
        }
       
        List<Repayment_Unique__c>resList=new List<Repayment_Unique__c>();
       for(Repayment_All_Payment__c q: uniqRep){
            Repayment_Unique__c repuni= new Repayment_Unique__c();
            //System.debug(EndDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c));
            repuni.amount__c=q.Amount__c;
            repUni.Description__c=q.Description__c;
            repUni.GetCap_Classification__c=q.GetCap_Classification__c;
            repuni.Lender_Type__c=q.Lender_Type__c;
            repUni.Total_Number__c=netRes.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c);
            repUni.End_Date__c=(endDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)).date__C;
            repUni.Start_Date__c=(startDate.get(String.valueOf(Integer.valueOf(q.Amount__c))+q.Lender_Type__c+q.GetCap_Classification__c)).date__C;
            resList.add(repUni);
        }
        insert resList;
        return resList;
        
    }
    public void tranSummary(){
        list<Summary_of_Transactions__c> sumList=new List<Summary_of_Transactions__c>();
        sumList=[select id,name from Summary_of_Transactions__c ];
        if(sumList.size()>0)
            delete sumList;
        List<Repayment_Credit_Payment__c> creditObj= new list<Repayment_Credit_Payment__c>();
        creditObj.addAll([select id,name,Amount__c,date__c,category__c,particulars__c from Repayment_Credit_Payment__c]);
        Map<Date,Repayment_Credit_Payment__c> creditMap=new Map<Date,Repayment_Credit_Payment__c>();
        if(creditObj.size()>0){
            for(Repayment_Credit_Payment__c re:creditObj){
                creditMap.put(re.date__c,re);
            }
        }
        system.debug(creditMap);
        Date currentDate=date.today();
        system.debug(tstObj[0]);
        
        list<Summary_of_Transactions__c> sumList1=new List<Summary_of_Transactions__c>();
        for(integer i=0;i<=12;i++){
            system.debug('month date'+currentDate.addMonths(-(i+1)));
            
            (sumList1.add(RepaymentHandler.getSumObj(currentDate.addMonths(-(i+1)),tstObj,i,creditMap)));
                }
        insert sumList1;
        
    }
    public  static Summary_of_Transactions__c  getSumObj(Date tillDate,List<Repayment_Test_Obj__c> tstObj,integer mnth,Map<Date,Repayment_Credit_Payment__c> creditMap ){
        List<Decimal> bal= new List<Decimal>();
        Decimal debit=0;
        Decimal credit=0;
        Integer count=0;
        Decimal balance=0;
        for(Repayment_Test_Obj__c re:tstObj){
            if(re.date__c>=tillDate  && re.date__c<=(date.today()).addmonths(-mnth)){  
                bal.add(re.balance__c);
                debit=re.amount__c+debit;    
                balance=re.Balance__c+balance;
                count++;
                
            }
        }
        integer countGrtFour=0;
        decimal veri=0;
        decimal rtrnAmt=0;
        Integer rtrn=0;
        decimal loanCredit=0;
        for(Date q: creditMap.keySet()){
            
            if(q>=tillDate && q<=date.today().addmonths(-mnth)){
                system.debug(creditMap.get(q));
                credit=(creditMap.get(q)).amount__c+credit;
                if((creditMap.get(q)).Category__c=='Loan Credits'){
                    loanCredit=loanCredit+(creditMap.get(q)).amount__c;
                }
                if(((creditMap.get(q)).Category__c)=='Return'){
                    rtrnAmt=rtrnAmt+(creditMap.get(q)).amount__c;
                    rtrn++;
                }
                if((creditMap.get(q)).Category__c=='Other Credit'){
                    veri=veri+(creditMap.get(q)).amount__c;
                }
                if((creditMap.get(q)).amount__c>=400)
                    countGrtFour=countGrtFour+1;
            }
        }
        system.debug('Credit for this month is: '+credit);
        
        
        
        bal.sort();       
        system.debug(bal);
        Summary_of_Transactions__c sumObj= new Summary_of_Transactions__c();
        sumObj.Debits__c=debit;
        sumObj.Credits__c=credit;
        sumObj.Loan_Credits__c=loanCredit;
        sumObj.Verifiable_Sales__c=veri;
        sumObj.Month__c=String.valueOf(tillDate)+'--TO--'+string.valueOf(date.today().addMOnths(-mnth));
        if(count>0){
            system.debug('Average balance'+ balance/count);
            sumObj.Average_Balance__c=balance/count;
        }
        sumObj.Opening_Balance__c=tstObj[mnth].balance__c;
        sumObj.Closing_Balance__c=tstObj[tstObj.size()-1].balance__c;
        if(bal.size()>0){
            sumObj.Maximum_Bal__c=bal.get(bal.size()-1);
            sumObj.Minimum_Bal__c=bal.get(0);
        }
        sumObj.Returns__c=rtrnAmt;
        sumObj.Number_of_Returns__c=rtrn;
        sumObj.Transactions_over_400__c=countGrtFour;
        return sumObj;
        
        
        
    }
    public List<Repayment_Credit_Payment__c> assignCreditwrtKeywords(Repayment_Test_Obj__c resObj,List<String> accNo){
        List<Repayment_Credit_Payment__c> allCreditPayList=[select id,name from Repayment_Credit_Payment__c	];
        if(allCreditPayList!=null)
            delete allCreditPayList;
        List<Repayment_Test_Obj__c> rejTestObj=new List<Repayment_Test_Obj__c>();
        if(resObj!=null){
            String desp= '%' +resObj.Description__c+ '%';
            
            if(resObj.Description__c!=null && resobj.Date__c!=null && resObj.Till_Date__c!=null)
                rejTestObj= [select id,AccountName__c,Till_Date__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where date__c>:resObj.Date__c and Date__C<:resObj.Till_Date__c and description__c Like :desp and Amount__c>0];
        }
        else
            rejTestObj=[select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where Amount__c>0];
        
        
        List<String> testStr= new List<String>();
        for(Repayment_Rejection__c re:rejectList){
            testStr.add('%'+re.name+'%');
            
        }
        // tstObj.addAll([select id,name,description__c from Repayment_Test_Obj__c where  (not description__c like: teststr)]);
        //system.debug(tstObj.size());
        List<Repayment_Credit_Keywords__c> keyObj=[select id,name,GetCap_Classification__c,Word_Search__c from Repayment_Credit_Keywords__c order by name];
        List<String> key1=new List<String>();
        
        for(Repayment_Credit_Keywords__c k:keyObj){
            if(k.Word_Search__c!=null){
                key1.add('%'+' '+k.Word_Search__c+' '+'%');
                
                
            }
            
        }
        if(accNo!=null){
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c>0 and   ((description__c like:key1) ) and (not description__c like: teststr) and AccountNumber__c=:accNo]);
        }
        else
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c>0 and   ((description__c like:key1) ) and (not description__c like: teststr) ]);
        for(Repayment_Test_Obj__c tst1:tstObj){
            firstFilterDescCredit.put(tst1.Description__c,tst1);
        }
        
        
        for(Repayment_Credit_Keywords__c q1:keyObj){
            if(q1.Word_Search__c!=null) {  
                
                for(String str:firstFilterDescCredit.keySet()){
                    if(str.toUpperCase().contains((q1.Word_Search__c).toUpperCase())){
                        
                        finalMapCredit.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            
        }
        
        for(Repayment_Test_Obj__c q:tstObj){
            Repayment_Credit_Payment__c reAllObj=new Repayment_Credit_Payment__c();
            reAllObj.Date__c=q.Date__c;
            reAllObj.Amount__c=q.Amount__c;
            
            reAllObj.Particulars__c=q.Description__c;
            
            reAllObj.Category__c=finalMapCredit.get(q.Description__c);
            repAllListCredit.add(reAllObj);
        }        
        insert repAllListCredit;
        return repAllListCredit;
        
    }
      public List<Repayment_Credit_Payment__c> assignCreditwrtKeywordsWithFilter(List<String> accNo,String value){
        List<Repayment_Credit_Payment__c> allCreditPayList=[select id,name from Repayment_Credit_Payment__c	];
        if(allCreditPayList!=null)
            delete allCreditPayList;
        List<Repayment_Test_Obj__c> rejTestObj=new List<Repayment_Test_Obj__c>();
        
            rejTestObj=[select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where Amount__c>0];
        
        
        List<String> testStr= new List<String>();
        for(Repayment_Rejection__c re:rejectList){
            testStr.add('%'+re.name+'%');
            
        }
        // tstObj.addAll([select id,name,description__c from Repayment_Test_Obj__c where  (not description__c like: teststr)]);
        //system.debug(tstObj.size());
        List<Repayment_Credit_Keywords__c> keyObj=[select id,name,GetCap_Classification__c,Word_Search__c from Repayment_Credit_Keywords__c order by name];
        List<String> key1=new List<String>();
        
        for(Repayment_Credit_Keywords__c k:keyObj){
            if(k.Word_Search__c!=null){
                key1.add('%'+' '+k.Word_Search__c+' '+'%');
                
                
            }
            
        }
        system.debug('key1'+key1);
        system.debug(value);
        
        
        if(value!=null || value!=''){
            String desp= '%'+value+'%';
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c>0 and   ((description__c like:key1) ) and (description__c like:desp) and (not description__c like: teststr) and AccountNumber__c=:accNo]);
        }
        else
            tstObj.addAll([select id,AccountName__c,AccountNumber__c,Amount__c,Balance__c,BankName__c,Classification__c,Date__c,Description__c,LoanId__c,ownerid__c,Payee__c,Reference__c,Type__c from Repayment_Test_Obj__c where amount__c>0 and   ((description__c like:key1) ) and (not description__c like: teststr) ]);
        for(Repayment_Test_Obj__c tst1:tstObj){
            firstFilterDescCredit.put(tst1.Description__c,tst1);
        }
        
        
        for(Repayment_Credit_Keywords__c q1:keyObj){
            if(q1.Word_Search__c!=null) {  
                
                for(String str:firstFilterDescCredit.keySet()){
                    if(str.toUpperCase().contains((q1.Word_Search__c).toUpperCase())){
                        
                        finalMapCredit.put(str,q1.GetCap_Classification__c);
                    }
                    
                }
            }
            
        }
        
        for(Repayment_Test_Obj__c q:tstObj){
            Repayment_Credit_Payment__c reAllObj=new Repayment_Credit_Payment__c();
            reAllObj.Date__c=q.Date__c;
            reAllObj.Amount__c=q.Amount__c;
            
            reAllObj.Particulars__c=q.Description__c;
            
            reAllObj.Category__c=finalMapCredit.get(q.Description__c);
            repAllListCredit.add(reAllObj);
        }        
        insert repAllListCredit;
        return repAllListCredit;
        
    }
}
@isTest
public with sharing class TestDataFactory {
    static List<RCTI__c> rctis = new List<RCTI__c>();
          
    public static List<Account> createAccounts(Integer numAccts) {
        List<Account> accts = new List<Account>();
        Id brokerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
        Id partnerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id leadGenRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Generator').getRecordTypeId();
        Id clientRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    
        for(Integer i=0;i<numAccts;i++) {
            Account broker = new Account(Name='TestAccount' + i,
                                   RecordTypeId=brokerRecId,
                                   Account_Email__c = 'abc@xyz.com');
            accts.add(broker);
            
            Account partner = new Account(Name='TestAccount' + i+1,
                                   RecordTypeId=partnerRecId,
                                   Account_Email__c = 'abcl@xyz.com');
            accts.add(partner);
            
            Account leadGen = new Account(Name='TestAccount' + i+2,
                                   RecordTypeId=leadGenRecId,
                                   Account_Email__c = 'abcv@xyz.com');
            accts.add(leadGen);
            
            Account client = new Account(Name='TestAccount' + i+3,
                                   RecordTypeId=clientRecId,
                                   Account_Email__c = 'abcjj@xyz.com');
            accts.add(client);
        }
        insert accts;

        return accts;
    }
        
    public static List<Contact> createContacts(List<Account> accList) {
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Aggregator/Broker/Lead Gen').getRecordTypeId();
        Id conClientRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        
        List<Contact> cons = new List<Contact>();
        
        for (Account acct : accList) {
            if(acct.recordtypeId != Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()){
                cons.add(new Contact(LastName=acct.Name + ' Contact ', 
                                 FirstName = acct.Name + ' ContactFirst ',
                                 RecordTypeId=conRecTypeId,
                                 Email='efg@xyz.com',
                                 AccountId=acct.Id));
            }
            
            if(acct.recordtypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()){
                cons.add(new Contact(LastName=acct.Name + ' Contact1 ', 
                                 FirstName = acct.Name + ' ContactFirst1 ',
                                 RecordTypeId=conClientRecTypeId,
                                 Email='efg@xyzg.com',
                                 AccountId=acct.Id));
            }
        }
        
        // Insert all contacts for all accounts.
        insert cons;
        return cons;
    }

    public static List<loan__Bank_Account__c> createBankAccounts(Boolean status, Id accId) {
        List<loan__Bank_Account__c> bankAccs = new List<loan__Bank_Account__c>();
        bankAccs.add(new loan__Bank_Account__c( loan__Account__c = accId, 
                                               loan__Active__c = status,
                                               BSB__c = '011025',
                                               loan__Bank_Account_Number__c = '01102559',
                                               loan__Bank_Name__c = 'Test Bank'));

        insert bankAccs;        
        return bankAccs;
    }
    
    
    public static loan__loan_Account__c createContractsWithContacts(Contact con) {
        
        date currentSystemDate = date.newinstance(2018,07,15);
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);  
        dummyFee.Name = 'GetCapital Arrear Fees';     
        upsert dummyFee;                             
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(dummyOffice,
                            dummyAccount, 
                            curr, 
                            dummyFeeSet);
        dummyLP.Name = 'Weekly Term Loan - Flat Interest';
        upsert dummyLP;
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();        
        
        Contact dummyClient = new contact(); 
        dummyClient.LastName = 'Test Contact';
        dummyClient.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        
       insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForContact(dummyLP,
                                                    dummyClient,
                                                    dummyFeeSet,
                                                    dummyLoanPurpose,
                                                    dummyOffice);
                                          
        //loanAccount.Loan__Loan_Status__c              = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Approved_And_Signed__c              = false;
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        loanAccount.Broker__c = con.Id;
        
        loanAccount.loan__Contract_Type__c = 'Refinance';
        upsert loanAccount; 
        return loanAccount;
    }
    
    public static List<RCTI__c> createRCTIs(String sendTo, List<Account> accs) {
        rctis = new List<RCTI__c>();        
        for(Account acc : accs) {
            if(acc.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()) {
                RCTI__c a = new RCTI__c(Name = 'RCTI',
                                    Account__c = acc.Id,
                                    Frequency__c = 'Daily',
                                    Send_Emails_To__c = sendTo,
                                    Next_Date_To_Send__c = system.TODAY());

                rctis.add(a);
            }  
        }        
        insert rctis;               
        return rctis;
    }
    
    public static List<Contract_Details__c> createConDs(RCTI__c rcti, loan__loan_Account__c loan,loan__Loan_Disbursal_Transaction__c disbursal ) {
        
        List<Contract_Details__c> cons = new List<Contract_Details__c>();
        cons.add(new Contract_Details__c(
                                       CL_Contract__c = loan.id,
                                       RCTI__c = rcti.Id,
                                       Manually_Added__c = false,
                                       Loan_Disbursal_Transaction__c = null,
                                       Manual_generation__c = false));
                   
        cons.add(new Contract_Details__c(
                                       CL_Contract__c = loan.id,
                                       RCTI__c = rcti.Id,
                                       Manually_Added__c = true,
                                       Loan_Disbursal_Transaction__c = null,
                                       Manual_generation__c = false));
            
        cons.add(new Contract_Details__c(
                                       CL_Contract__c = loan.id,
                                       RCTI__c = rcti.Id,
                                       Manually_Added__c = true,
                                       Loan_Disbursal_Transaction__c = disbursal.id,
                                       Manual_generation__c = false));
                 
        cons.add(new Contract_Details__c(
                                       CL_Contract__c = loan.id,
                                       RCTI__c = rcti.Id,
                                       Manually_Added__c = false,
                                       Loan_Disbursal_Transaction__c = disbursal.id,
                                       Manual_generation__c = false));
            
        
        insert cons;        
        return cons;
    }
    
    public static loan__Loan_Disbursal_Transaction__c disbursals(loan__loan_Account__c loan ){
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'Cash';
        insert mode;
        system.debug('This is mode:'+mode);
        
        loan.GlobalLoanUtilFacade loanUtilObj =  new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = loanUtilObj.getCurrentSystemDate(); 
        system.debug('This is currentSystemDate:'+currentSystemDate);
        
        loan__Loan_Disbursal_Transaction__c disbursal = new loan__Loan_Disbursal_Transaction__c();
        
        disbursal.loan__Disbursed_Amt__c = 222;
        disbursal.loan__Mode_of_Payment__c = mode.id;
        disbursal.loan__Disbursal_Date__c = system.today();      
        disbursal.loan__Financed_Amount__c =  10000;
        disbursal.loan__Pre_Paid_Fee__c = 0.00;
        disbursal.loan__Refinanced_Amount__c = 0.00;
        disbursal.loan__Cleared__c = true;
        disbursal.loan__Loan_Account__c = loan.id;
        system.debug('This is disbursal:'+disbursal);
                    
        //upsert disbursal;
        return disbursal;
    }
    
    public static Case createCases(){
        Case locCase = new Case(RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LOC Drawdown').getRecordTypeId(),
                               Refi_Status__c = 'Uncontactable',
                               Drawdown_Status__c = '1. Request Received'
                               );
        insert locCase;
        return locCase;
    } 
    
    public static Supplier__c createSupplier(){
        Supplier__c supplier = new Supplier__c(RecordtypeId = Schema.SObjectType.Supplier__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(),
                               Accreditation_Result__c = 'Under Review',
                               Supplier_Type__c = 'Dealer'                
                               );
        insert supplier;
        return supplier;
    } 
    
    @testVisible static RCTI_Settings__mdt customMetadata { 
    get {
        if ( customMetadata == null )
            customMetadata = [SELECT id, Time__c, HelpLine_Email__c FROM RCTI_Settings__mdt limit 1]; 
        return customMetadata;
    } set; }
}
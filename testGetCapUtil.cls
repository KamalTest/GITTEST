@isTest
global class testGetCapUtil{ 
    
    // This method tests the ApplicationToContractConverterCL,CreateLoanAccountForLoanTypeHandlerCL and GetCapitalUtils class
    static testmethod void testLoan(){
        
        loan__Trigger_Parameters__c trig = new loan__Trigger_Parameters__c();
        trig.Dishonour_Fees_Creation_Trigger__c = True;
        trig.Add_Charge_To_Fields_Trigger__c = True;
        trig.Interest_Factor_And_Rate_Conversion__c = True;
        trig.Interest_Rate_And_Factor_Conversion__c = True;
        insert trig;
        
        Test.startTest();
        
        Default__c defaulta = new Default__c();
        defaulta.name = 'GetCaptal_Default';
        defaulta.Line_Of_Credit__c = 'ABC';
        insert defaulta;
        
        
        
        genesis__Org_Parameters__c orgParam = new genesis__Org_Parameters__c();
        orgParam.genesis__Disable_Triggers__c = True;
        insert orgParam;
        
        loan__Org_Parameters__c orgParams = new loan__Org_Parameters__c();
        orgParams.loan__Disable_Triggers__c = True;
        insert orgParams;
        
        genesis__Company__c company = new genesis__Company__c();
        company.Name = 'Alternative Capital Solutions Pte Ltd/TA GetCapital';
        company.genesis__Short_Name__c = 'HQ';
        insert company;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'GetCapital Product';
        clProduct.clcommon__Class__c = 'Commercial';
        insert clProduct; 
        
        Account accnt = new Account();
        accnt.Name = 'Arnab Mukherjee';
        insert accnt;
        
        Contact con = new Contact();
        con.AccountId = accnt.id;
        con.LastName = 'Mukherjee';
        insert con;
        
        loan__Bank_Account__c bankAcc = new loan__Bank_Account__c();
        bankAcc.loan__Account__c = accnt.id;
        bankAcc.loan__Active__c = TRUE;
        bankAcc.BSB__c = '011025';
        bankAcc.loan__Bank_Account_Number__c = '123456789';
        bankAcc.loan__Bank_Name__c = 'Test Bank';
        insert bankAcc;
        
        genesis__Loan_Product__c lendingProduct = new genesis__Loan_Product__c();
        lendingProduct.Name = 'GC Monthly - Chattel Mortgage';
        lendingProduct.Payment_Frequency__c='weekly';
        insert lendingProduct;
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                    
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
        
        contact dummyClient = new contact(); 
        dummyClient.LastName = 'Test Contact';
        
        insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForContact(dummyLP,
                                                                                        dummyClient,
                                                                                        dummyFeeSet,
                                                                                        dummyLoanPurpose,
                                                                                        dummyOffice);
        
        //loanAccount.Loan__Loan_Status__c                = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Loan__Loan_Status__c = 'Approved';
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        loanAccount.loan__Product_Type__c = 'XYZ';
        upsert loanAccount;
        
        genesis__Applications__c appliFlat = new genesis__Applications__c();
        appliFlat.genesis__CL_Product__c = clProduct.id;
        appliFlat.genesis__Account__c = accnt.id;
        appliFlat.genesis__Company__c = company.id;
        appliFlat.genesis__Contact__c = con.id;
        appliFlat.genesis__Product_Type__c = 'Loan';
        appliFlat.genesis__Lending_Product__c = lendingProduct.id;
        appliFlat.genesis__Days_Convention__c = '365/365';
        appliFlat.genesis__Term__c = 30;
        appliFlat.genesis__Payment_Frequency__c = 'Weekly';
        appliFlat.genesis__Interest_Calculation_Method__c = 'Declining Balance';
        appliFlat.genesis__Interest_Rate__c =20;
        appliFlat.genesis__Loan_Amount__c = 10000;
        appliFlat.genesis__Credit_Limit__c =30000;
        appliFlat.genesis__Draw_Term__c = 30;
        appliFlat.STP_RM_Approval_20K__c=true;
        appliFlat.GC_Basic_Result__c='Pass';
        insert appliFlat;           
        
        
        loan__Loan_Account__c contract = new loan__Loan_Account__c();
        contract.loan__Loan_Amount__c = appliFlat.genesis__Loan_Amount__c;
        contract.loan__Disbursal_Date__c = appliFlat.genesis__Expected_Start_Date__c;
        contract.loan__First_Installment_Date__c = appliFlat.genesis__Expected_First_Payment_Date__c;
        contract.loan__Product_Type__c =appliFlat.genesis__Product_Type__c;
        
        
        
        Contact con1 = new Contact();
        con1.AccountId = accnt.id;
        con1.LastName = 'Mukherjee';
        insert con1;
        appliFlat.Guarantor_1__c = con1.id;
        
        Contact con2 = new Contact();
        con2.AccountId = accnt.id;
        con2.LastName = 'Mukherjee';
        insert con2;
        appliFlat.Guarantor_2__c = con2.id;
        
        Contact con3 = new Contact();
        con3.AccountId = accnt.id;
        con3.LastName = 'Mukherjee';
        insert con3;
        appliFlat.Guarantor_3__c = con3.id;
        
        Contact con4 = new Contact();
        con4.AccountId = accnt.id;
        con4.LastName = 'Mukherjee';
        insert con4;
        appliFlat.Guarantor_4__c = con4.id;
        
        Contact con5 = new Contact();
        con5.AccountId = accnt.id;
        con5.LastName = 'Mukherjee';
        insert con5;
        appliFlat.Guarantor_5__c = con5.id;
        
        appliFlat.Mortgage__c = true;
        appliFlat.Additional_eqipment__c = true;
        appliFlat.Additional_Vehicle__c = true;        
        GetCapital_Equipment__c gen=new GetCapital_Equipment__c();
        gen.name='Ford';
        gen.Application__c=appliFlat.id;
        insert gen;
        String iden = appliFlat.id;
        GetCapitalUtils.borrowerAccepted(iden);
        GetCapitalUtils.reload(appliFlat.id);
        
        
        Test.stopTest();
    }
    static testmethod void testLoan1(){
        
        loan__Trigger_Parameters__c trig = new loan__Trigger_Parameters__c();
        trig.Dishonour_Fees_Creation_Trigger__c = True;
        trig.Add_Charge_To_Fields_Trigger__c = True;
        trig.Interest_Factor_And_Rate_Conversion__c = True;
        trig.Interest_Rate_And_Factor_Conversion__c = True;
        insert trig;
        
        Test.startTest();
        
        Default__c defaulta = new Default__c();
        defaulta.name = 'GetCaptal_Default';
        defaulta.Line_Of_Credit__c = 'ABC';
        insert defaulta;
        
        
        
        genesis__Org_Parameters__c orgParam = new genesis__Org_Parameters__c();
        orgParam.genesis__Disable_Triggers__c = True;
        insert orgParam;
        
        loan__Org_Parameters__c orgParams = new loan__Org_Parameters__c();
        orgParams.loan__Disable_Triggers__c = True;
        insert orgParams;
        
        genesis__Company__c company = new genesis__Company__c();
        company.Name = 'Alternative Capital Solutions Pte Ltd/TA GetCapital';
        company.genesis__Short_Name__c = 'HQ';
        insert company;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'GetCapital Product';
        clProduct.clcommon__Class__c = 'Commercial';
        insert clProduct; 
        
        Account accnt = new Account();
        accnt.Name = 'Arnab Mukherjee';
        insert accnt;
        
        Contact con = new Contact();
        con.AccountId = accnt.id;
        con.LastName = 'Mukherjee';
        insert con;
        
        loan__Bank_Account__c bankAcc = new loan__Bank_Account__c();
        bankAcc.loan__Account__c = accnt.id;
        bankAcc.loan__Active__c = TRUE;
        bankAcc.BSB__c = '011025';
        bankAcc.loan__Bank_Account_Number__c = '123456789';
        bankAcc.loan__Bank_Name__c = 'Test Bank';
        insert bankAcc;
        
        genesis__Loan_Product__c lendingProduct = new genesis__Loan_Product__c();
        lendingProduct.Name = 'Weekly Term Loan - Flat Interest';
        lendingProduct.Payment_Frequency__c='weekly';
        insert lendingProduct;
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                    
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
        
        contact dummyClient = new contact(); 
        dummyClient.LastName = 'Test Contact';
        
        insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForContact(dummyLP,
                                                                                        dummyClient,
                                                                                        dummyFeeSet,
                                                                                        dummyLoanPurpose,
                                                                                        dummyOffice);
        
        //loanAccount.Loan__Loan_Status__c                = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Loan__Loan_Status__c = 'Approved';
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        loanAccount.loan__Product_Type__c = 'XYZ';
        upsert loanAccount;
        
        genesis__Applications__c appliFlat = new genesis__Applications__c();
        appliFlat.genesis__CL_Product__c = clProduct.id;
        appliFlat.genesis__Account__c = accnt.id;
        appliFlat.genesis__Company__c = company.id;
        appliFlat.genesis__Contact__c = con.id;
        appliFlat.genesis__Product_Type__c = 'Loan';
        appliFlat.genesis__Lending_Product__c = lendingProduct.id;
        appliFlat.genesis__Days_Convention__c = '365/365';
        appliFlat.genesis__Term__c = 30;
        appliFlat.genesis__Payment_Frequency__c = 'Weekly';
        appliFlat.genesis__Interest_Calculation_Method__c = 'Declining Balance';
        appliFlat.genesis__Interest_Rate__c =20;
        appliFlat.genesis__Loan_Amount__c = 10000;
        appliFlat.genesis__Credit_Limit__c =30000;
        appliFlat.genesis__Draw_Term__c = 30;
        appliFlat.STP_RM_Approval_20K__c=false;
        appliFlat.GC_Basic_Result__c='Pass';
        insert appliFlat;           
        
        
        loan__Loan_Account__c contract = new loan__Loan_Account__c();
        contract.loan__Loan_Amount__c = appliFlat.genesis__Loan_Amount__c;
        contract.loan__Disbursal_Date__c = appliFlat.genesis__Expected_Start_Date__c;
        contract.loan__First_Installment_Date__c = appliFlat.genesis__Expected_First_Payment_Date__c;
        contract.loan__Product_Type__c =appliFlat.genesis__Product_Type__c;
        
        
        
        Contact con1 = new Contact();
        con1.AccountId = accnt.id;
        con1.LastName = 'Mukherjee';
        insert con1;
        appliFlat.Guarantor_1__c = con1.id;
        
        Contact con2 = new Contact();
        con2.AccountId = accnt.id;
        con2.LastName = 'Mukherjee';
        insert con2;
        appliFlat.Guarantor_2__c = con2.id;
        
        Contact con3 = new Contact();
        con3.AccountId = accnt.id;
        con3.LastName = 'Mukherjee';
        insert con3;
        appliFlat.Guarantor_3__c = con3.id;
        
        Contact con4 = new Contact();
        con4.AccountId = accnt.id;
        con4.LastName = 'Mukherjee';
        insert con4;
        appliFlat.Guarantor_4__c = con4.id;
        
        Contact con5 = new Contact();
        con5.AccountId = accnt.id;
        con5.LastName = 'Mukherjee';
        insert con5;
        appliFlat.Guarantor_5__c = con5.id;
        
        appliFlat.Mortgage__c = true;
        appliFlat.Additional_eqipment__c = true;
        appliFlat.Additional_Vehicle__c = true;
        
        
        String iden = appliFlat.id;
        GetCapitalUtils.borrowerAccepted(iden);
        GetCapitalUtils.reload(appliFlat.id);
        
        
        Test.stopTest();
    }
    static testmethod void testLoan2(){
        
        loan__Trigger_Parameters__c trig = new loan__Trigger_Parameters__c();
        trig.Dishonour_Fees_Creation_Trigger__c = True;
        trig.Add_Charge_To_Fields_Trigger__c = True;
        trig.Interest_Factor_And_Rate_Conversion__c = True;
        trig.Interest_Rate_And_Factor_Conversion__c = True;
        insert trig;
        
        Test.startTest();
        
        Default__c defaulta = new Default__c();
        defaulta.name = 'GetCaptal_Default';
        defaulta.Line_Of_Credit__c = 'ABC';
        insert defaulta;
        
        
        
        genesis__Org_Parameters__c orgParam = new genesis__Org_Parameters__c();
        orgParam.genesis__Disable_Triggers__c = True;
        insert orgParam;
        
        loan__Org_Parameters__c orgParams = new loan__Org_Parameters__c();
        orgParams.loan__Disable_Triggers__c = True;
        insert orgParams;
        
        genesis__Company__c company = new genesis__Company__c();
        company.Name = 'Alternative Capital Solutions Pte Ltd/TA GetCapital';
        company.genesis__Short_Name__c = 'HQ';
        insert company;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'GetCapital Product';
        clProduct.clcommon__Class__c = 'Commercial';
        insert clProduct; 
        
        Account accnt = new Account();
        accnt.Name = 'Arnab Mukherjee';
        insert accnt;
        
        Contact con = new Contact();
        con.AccountId = accnt.id;
        con.LastName = 'Mukherjee';
        insert con;
        
        loan__Bank_Account__c bankAcc = new loan__Bank_Account__c();
        bankAcc.loan__Account__c = accnt.id;
        bankAcc.loan__Active__c = TRUE;
        bankAcc.BSB__c = '011025';
        bankAcc.loan__Bank_Account_Number__c = '123456789';
        bankAcc.loan__Bank_Name__c = 'Test Bank';
        insert bankAcc;
        
        genesis__Loan_Product__c lendingProduct = new genesis__Loan_Product__c();
        lendingProduct.Name = 'Weekly Term Loan - Flat Interest';
        lendingProduct.Payment_Frequency__c='weekly';
        insert lendingProduct;
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                    
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
        
        contact dummyClient = new contact(); 
        dummyClient.LastName = 'Test Contact';
        
        insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForContact(dummyLP,
                                                                                        dummyClient,
                                                                                        dummyFeeSet,
                                                                                        dummyLoanPurpose,
                                                                                        dummyOffice);
        
        //loanAccount.Loan__Loan_Status__c                = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Loan__Loan_Status__c = 'Approved';
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        loanAccount.loan__Product_Type__c = 'XYZ';
        upsert loanAccount;
        
        genesis__Applications__c appliFlat = new genesis__Applications__c();
        appliFlat.genesis__CL_Product__c = clProduct.id;
        appliFlat.genesis__Account__c = accnt.id;
        appliFlat.genesis__Company__c = company.id;
        appliFlat.genesis__Contact__c = con.id;
        appliFlat.genesis__Product_Type__c = 'Loan';
        appliFlat.genesis__Lending_Product__c = lendingProduct.id;
        appliFlat.genesis__Days_Convention__c = '365/365';
        appliFlat.genesis__Term__c = 30;
        appliFlat.genesis__Payment_Frequency__c = 'Weekly';
        appliFlat.genesis__Interest_Calculation_Method__c = 'Declining Balance';
        appliFlat.genesis__Interest_Rate__c =20;
        appliFlat.genesis__Loan_Amount__c = 10000;
        appliFlat.genesis__Credit_Limit__c =30000;
        appliFlat.genesis__Draw_Term__c = 30;
        appliFlat.STP_RM_Approval_20K__c=false;
        appliFlat.GC_Basic_Result__c='Fail';
        insert appliFlat;           
        
        
        loan__Loan_Account__c contract = new loan__Loan_Account__c();
        contract.loan__Loan_Amount__c = appliFlat.genesis__Loan_Amount__c;
        contract.loan__Disbursal_Date__c = appliFlat.genesis__Expected_Start_Date__c;
        contract.loan__First_Installment_Date__c = appliFlat.genesis__Expected_First_Payment_Date__c;
        contract.loan__Product_Type__c =appliFlat.genesis__Product_Type__c;
        
        
        
        Contact con1 = new Contact();
        con1.AccountId = accnt.id;
        con1.LastName = 'Mukherjee';
        insert con1;
        appliFlat.Guarantor_1__c = con1.id;
        
        Contact con2 = new Contact();
        con2.AccountId = accnt.id;
        con2.LastName = 'Mukherjee';
        insert con2;
        appliFlat.Guarantor_2__c = con2.id;
        
        Contact con3 = new Contact();
        con3.AccountId = accnt.id;
        con3.LastName = 'Mukherjee';
        insert con3;
        appliFlat.Guarantor_3__c = con3.id;
        
        Contact con4 = new Contact();
        con4.AccountId = accnt.id;
        con4.LastName = 'Mukherjee';
        insert con4;
        appliFlat.Guarantor_4__c = con4.id;
        
        Contact con5 = new Contact();
        con5.AccountId = accnt.id;
        con5.LastName = 'Mukherjee';
        insert con5;
        appliFlat.Guarantor_5__c = con5.id;
        
        appliFlat.Mortgage__c = true;
        appliFlat.Additional_eqipment__c = true;
        appliFlat.Additional_Vehicle__c = true;
        
        
        String iden = appliFlat.id;
        GetCapitalUtils.borrowerAccepted(iden);
        GetCapitalUtils.reload(appliFlat.id);
        
        
        Test.stopTest();
    }
     static testmethod void testVehLoan(){
        
        loan__Trigger_Parameters__c trig = new loan__Trigger_Parameters__c();
        trig.Dishonour_Fees_Creation_Trigger__c = True;
        trig.Add_Charge_To_Fields_Trigger__c = True;
        trig.Interest_Factor_And_Rate_Conversion__c = True;
        trig.Interest_Rate_And_Factor_Conversion__c = True;
        insert trig;
        
        Test.startTest();
        
        Default__c defaulta = new Default__c();
        defaulta.name = 'GetCaptal_Default';
        defaulta.Line_Of_Credit__c = 'ABC';
        insert defaulta;
        
        
        
        genesis__Org_Parameters__c orgParam = new genesis__Org_Parameters__c();
        orgParam.genesis__Disable_Triggers__c = True;
        insert orgParam;
        
        loan__Org_Parameters__c orgParams = new loan__Org_Parameters__c();
        orgParams.loan__Disable_Triggers__c = True;
        insert orgParams;
        
        genesis__Company__c company = new genesis__Company__c();
        company.Name = 'Alternative Capital Solutions Pte Ltd/TA GetCapital';
        company.genesis__Short_Name__c = 'HQ';
        insert company;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'GetCapital Product';
        clProduct.clcommon__Class__c = 'Commercial';
        insert clProduct; 
        
        Account accnt = new Account();
        accnt.Name = 'Arnab Mukherjee';
        insert accnt;
        
        Contact con = new Contact();
        con.AccountId = accnt.id;
        con.LastName = 'Mukherjee';
        insert con;
        
        loan__Bank_Account__c bankAcc = new loan__Bank_Account__c();
        bankAcc.loan__Account__c = accnt.id;
        bankAcc.loan__Active__c = TRUE;
        bankAcc.BSB__c = '011025';
        bankAcc.loan__Bank_Account_Number__c = '123456789';
        bankAcc.loan__Bank_Name__c = 'Test Bank';
        insert bankAcc;
        
        genesis__Loan_Product__c lendingProduct = new genesis__Loan_Product__c();
        lendingProduct.Name = 'GC Monthly - Chattel Mortgage';
        lendingProduct.Payment_Frequency__c='weekly';
        insert lendingProduct;
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                    
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
        
        contact dummyClient = new contact(); 
        dummyClient.LastName = 'Test Contact';
        
        insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForContact(dummyLP,
                                                                                        dummyClient,
                                                                                        dummyFeeSet,
                                                                                        dummyLoanPurpose,
                                                                                        dummyOffice);
        
        //loanAccount.Loan__Loan_Status__c                = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Loan__Loan_Status__c = 'Approved';
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        loanAccount.loan__Product_Type__c = 'XYZ';
        upsert loanAccount;
        
        genesis__Applications__c appliFlat = new genesis__Applications__c();
        appliFlat.genesis__CL_Product__c = clProduct.id;
        appliFlat.genesis__Account__c = accnt.id;
        appliFlat.genesis__Company__c = company.id;
        appliFlat.genesis__Contact__c = con.id;
        appliFlat.genesis__Product_Type__c = 'Loan';
        appliFlat.genesis__Lending_Product__c = lendingProduct.id;
        appliFlat.genesis__Days_Convention__c = '365/365';
        appliFlat.genesis__Term__c = 30;
        appliFlat.genesis__Payment_Frequency__c = 'Weekly';
        appliFlat.genesis__Interest_Calculation_Method__c = 'Declining Balance';
        appliFlat.genesis__Interest_Rate__c =20;
        appliFlat.genesis__Loan_Amount__c = 10000;
        appliFlat.genesis__Credit_Limit__c =30000;
        appliFlat.genesis__Draw_Term__c = 30;
        appliFlat.STP_RM_Approval_20K__c=true;
        appliFlat.GC_Basic_Result__c='Pass';
        insert appliFlat;           
        
        
        loan__Loan_Account__c contract = new loan__Loan_Account__c();
        contract.loan__Loan_Amount__c = appliFlat.genesis__Loan_Amount__c;
        contract.loan__Disbursal_Date__c = appliFlat.genesis__Expected_Start_Date__c;
        contract.loan__First_Installment_Date__c = appliFlat.genesis__Expected_First_Payment_Date__c;
        contract.loan__Product_Type__c =appliFlat.genesis__Product_Type__c;
        
        
        
        Contact con1 = new Contact();
        con1.AccountId = accnt.id;
        con1.LastName = 'Mukherjee';
        insert con1;
        appliFlat.Guarantor_1__c = con1.id;
        
        Contact con2 = new Contact();
        con2.AccountId = accnt.id;
        con2.LastName = 'Mukherjee';
        insert con2;
        appliFlat.Guarantor_2__c = con2.id;
        
        Contact con3 = new Contact();
        con3.AccountId = accnt.id;
        con3.LastName = 'Mukherjee';
        insert con3;
        appliFlat.Guarantor_3__c = con3.id;
        
        Contact con4 = new Contact();
        con4.AccountId = accnt.id;
        con4.LastName = 'Mukherjee';
        insert con4;
        appliFlat.Guarantor_4__c = con4.id;
        
        Contact con5 = new Contact();
        con5.AccountId = accnt.id;
        con5.LastName = 'Mukherjee';
        insert con5;
        appliFlat.Guarantor_5__c = con5.id;
        
        appliFlat.Mortgage__c = true;
        appliFlat.Additional_eqipment__c = true;
        appliFlat.Additional_Vehicle__c = true;
        vehicle__c veh=new vehicle__c();
        veh.name='Ford';
        veh.Applications__c=appliFlat.id;
        insert veh;
        
        String iden = appliFlat.id;
        GetCapitalUtils.borrowerAccepted(iden);
        GetCapitalUtils.reload(appliFlat.id);
        
        
        Test.stopTest();
    }
    static testmethod void test1Loan(){
  
        loan__Trigger_Parameters__c trig = new loan__Trigger_Parameters__c();
        trig.Dishonour_Fees_Creation_Trigger__c = True;
        trig.Add_Charge_To_Fields_Trigger__c = True;
        trig.Interest_Factor_And_Rate_Conversion__c = True;
        trig.Interest_Rate_And_Factor_Conversion__c = True;
        insert trig;
  
        Test.startTest();
        
        Default__c defaulta = new Default__c();
        defaulta.name = 'GetCaptal_Default';
        defaulta.Line_Of_Credit__c = 'ABC';
        insert defaulta;
        
        
        
        genesis__Org_Parameters__c orgParam = new genesis__Org_Parameters__c();
        orgParam.genesis__Disable_Triggers__c = True;
        insert orgParam;
        
        loan__Org_Parameters__c orgParams = new loan__Org_Parameters__c();
        orgParams.loan__Disable_Triggers__c = True;
        insert orgParams;
        
        genesis__Company__c company = new genesis__Company__c();
        company.Name = 'Alternative Capital Solutions Pte Ltd/TA GetCapital';
        company.genesis__Short_Name__c = 'HQ';
        insert company;
        
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        clProduct.clcommon__Product_Name__c = 'GetCapital Product';
        clProduct.clcommon__Class__c = 'Commercial';
        insert clProduct; 
        
        Account accnt = new Account();
        accnt.Name = 'Arnab Mukherjee';
        insert accnt;
        
        Contact con = new Contact();
        con.AccountId = accnt.id;
        con.LastName = 'Mukherjee';
        insert con;
        
        loan__Bank_Account__c bankAcc = new loan__Bank_Account__c();
        bankAcc.loan__Account__c = accnt.id;
        bankAcc.loan__Active__c = TRUE;
        bankAcc.BSB__c = '011025';
        bankAcc.loan__Bank_Account_Number__c = '123456789';
        bankAcc.loan__Bank_Name__c = 'Test Bank';
        insert bankAcc;
        
        genesis__Loan_Product__c lendingProduct = new genesis__Loan_Product__c();
        lendingProduct.Name = 'Weekly Term Loan - Flat Interest';
       lendingProduct.Payment_Frequency__c='weekly';
        insert lendingProduct;
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                    
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
        
        contact dummyClient = new contact(); 
        dummyClient.LastName = 'Test Contact';
        
       insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForContact(dummyLP,
                                                    dummyClient,
                                                    dummyFeeSet,
                                                    dummyLoanPurpose,
                                                    dummyOffice);
                                          
        //loanAccount.Loan__Loan_Status__c                = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Loan__Loan_Status__c = 'Approved';
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        loanAccount.loan__Product_Type__c = 'XYZ';
        upsert loanAccount;
        
        genesis__Applications__c appliFlat = new genesis__Applications__c();
        appliFlat.genesis__CL_Product__c = clProduct.id;
        appliFlat.genesis__Account__c = accnt.id;
        appliFlat.genesis__Company__c = company.id;
        appliFlat.genesis__Contact__c = con.id;
        appliFlat.genesis__Product_Type__c = 'Loan';
        appliFlat.genesis__Lending_Product__c = lendingProduct.id;
        appliFlat.genesis__Days_Convention__c = '365/365';
        appliFlat.genesis__Term__c = 30;
        appliFlat.genesis__Payment_Frequency__c = 'Weekly';
        appliFlat.genesis__Interest_Calculation_Method__c = 'Declining Balance';
        appliFlat.genesis__Interest_Rate__c =20;
        appliFlat.genesis__Loan_Amount__c = 10000;
        appliFlat.genesis__Credit_Limit__c =30000;
        appliFlat.genesis__Draw_Term__c = 30;
        appliFlat.STP_RM_Approval_20K__c=true;
        appliFlat.GC_Basic_Result__c='Pass';
        insert appliFlat;           
        
         
        loan__Loan_Account__c contract = new loan__Loan_Account__c();
        contract.loan__Loan_Amount__c = appliFlat.genesis__Loan_Amount__c;
        contract.loan__Disbursal_Date__c = appliFlat.genesis__Expected_Start_Date__c;
        contract.loan__First_Installment_Date__c = appliFlat.genesis__Expected_First_Payment_Date__c;
        contract.loan__Product_Type__c =appliFlat.genesis__Product_Type__c;
        
        
        
        Contact con1 = new Contact();
        con1.AccountId = accnt.id;
        con1.LastName = 'Mukherjee';
        insert con1;
        appliFlat.Guarantor_1__c = con1.id;
        
        Contact con2 = new Contact();
        con2.AccountId = accnt.id;
        con2.LastName = 'Mukherjee';
        insert con2;
        appliFlat.Guarantor_2__c = con2.id;
        
        Contact con3 = new Contact();
        con3.AccountId = accnt.id;
        con3.LastName = 'Mukherjee';
        insert con3;
        appliFlat.Guarantor_3__c = con3.id;
        
        Contact con4 = new Contact();
        con4.AccountId = accnt.id;
        con4.LastName = 'Mukherjee';
        insert con4;
        appliFlat.Guarantor_4__c = con4.id;
        
        Contact con5 = new Contact();
        con5.AccountId = accnt.id;
        con5.LastName = 'Mukherjee';
        insert con5;
        appliFlat.Guarantor_5__c = con5.id;
        
        appliFlat.Mortgage__c = true;
        appliFlat.Additional_eqipment__c = true;
        appliFlat.Additional_Vehicle__c = true;
        
        
        String iden = appliFlat.id;
        GetCapitalUtils.borrowerAccepted(iden);
        GetCapitalUtils.reload(appliFlat.id);
     
        
        Test.stopTest();
        }
    static testMethod void catchCondition(){
        Case theCase = TestDataFactory.createCases();
        Supplier__c supp = TestDataFactory.createSupplier();
        supp.Accreditation_Result__c = 'Accredited';
        update supp;
        
        delete [Select id from Case_Supplier__c];
    }
}
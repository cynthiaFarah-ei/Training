public with sharing class Exercise3 {
    
    public static void preventAccountDuplicateInCompetitor(List<Competitor__c> newList, Map<Id,Competitor__c> oldMap, 
                                                            Map<Id,Competitor__c> newMap){
        // new map used eza acc1 opp1 badala 3a opp2 ta tmche 
        // Creating a map of Account IDs to Competitors. One for the quotes and one for the opps

        // to save AccountId and Competitor Acc + Quote
        Map<Id,Competitor__c> accountIdsToCompetitorForQuotesMap = new Map<Id,Competitor__c>();
        Map<Id,Competitor__c> accountIdsToCompetitorForOppsMap = new Map<Id,Competitor__c>();
        
        // Looping over the new list of created competitors
        for(Competitor__c comp : newList){
            // 3ena 2 lists bdna to fill them separately accId with competitors Acc + Quote / Opp
            
            // If the old map is null (ie: in a create state) or the quote has been changed or the account has been changed
            if(
            (oldMap == null || oldMap.get(comp.Id).Quote__c != comp.Quote__c || oldMap.get(comp.Id).Account__c != comp.Account__c)
            && 
            (comp.Quote__c != null && comp.Account__c != null)
            ) {
                // Add the account Id and the competitor to the corresponsing map
                accountIdsToCompetitorForQuotesMap.put(comp.Account__c,comp);
            }
            // If the old map is null (ie: in a create state) or the opportunity has been changed or the account has been changed
            if(
            (oldMap == null || oldMap.get(comp.Id).Opportunity__c != comp.Opportunity__c || 
                                oldMap.get(comp.Id).Account__c != comp.Account__c)
            &&
            (comp.Opportunity__c != null && comp.Account__c != null)
            ) {
                // Add the account Id and the competitor to the corresponsing map
                accountIdsToCompetitorForOppsMap.put(comp.Account__c,comp);
            }
        }
        
        // If the map isn't empty
        if(!accountIdsToCompetitorForQuotesMap.isEmpty()){
            
            // Looping over all the accounts that have the account ids in the map and quote is not null
            for(Competitor__c comp : [SELECT Id,Account__c FROM Competitor__c 
                                        WHERE Account__c IN :accountIdsToCompetitorForQuotesMap.keySet() AND Quote__c != null]){
                
                // If the comprtitor is not part of the current transaction
                // loop 3l db b3den eza insert get this inserted acc-quote li 3ndo he account id w 3tine error
                //  if update (bl loop eja com 3ndo id 3m n3melo update ma y3ml error)
                if(oldMap == null || !newMap.keySet().contains(comp.Id)){
                    // Getting the competitor from the filled map
                    Competitor__c accountComp = accountIdsToCompetitorForQuotesMap.get(comp.Account__c);
                    
                    // Adding the error
                    accountComp.addError('this acc already linked to a quote');
                }
                
            }
        }
        
        // If the map isn't empty
        if(!accountIdsToCompetitorForOppsMap.isEmpty()){
            
            // Looping over all the accounts that have the account ids in the map and opportunity is not null
            for(Competitor__c comp : [SELECT Id,Account__c FROM Competitor__c 
                                        WHERE Account__c IN :accountIdsToCompetitorForOppsMap.keySet() AND Opportunity__c != null]){
                
                // If the comprtitor is not part of the current transaction
                if(oldMap == null || !newMap.keySet().contains(comp.Id)){
                    // Getting the competitor from the filled map
                    Competitor__c accountComp = accountIdsToCompetitorForOppsMap.get(comp.Account__c);
                    
                    // Adding the error
                    accountComp.addError('this account already linked to an opportunity');
                }
            }
        }
        
    }
    
    public static void createCompetitorForQuote(List<Competitor__c> newList, Map<Id,Competitor__c> oldMap){

        // Creating a quote Id to Account Id map to query the quote and assign them to competitor Account
        Map<Id,Id> quoteIdToAccountId = new Map<Id,Id>();

        // Looping over the new list of competitors
        for(Competitor__c comp : newList){

            // If old map is null or quote has been changed and the quote and account are filled in
            if((oldMap == null || oldMap.get(comp.Id).Quote__c != comp.Quote__c) && comp.Quote__c != null && comp.Account__c != null){

                // Adding the comp quote (key) and comp account (value) to the map
                quoteIdToAccountId.put(comp.Quote__c, comp.Account__c);
            }
        }

        // If the map is not empty (ie: Their has been assignment to a qupte related to account)
        if(!quoteIdToAccountId.isEmpty()){

            // The competitor list that will be inserted
            List<Competitor__c> compList = new List<Competitor__c>();

            // Looping over all the quotes that have the key inside the map in order to get the opportunity related to them
            for(Quote__c quote : [SELECT Opportunity__c,Opportunity__r.Name FROM Quote__c WHERE Id IN :quoteIdToAccountId.keySet()]){

                // Creating the competitor
                Competitor__c comp = new Competitor__c(Account__c = quoteIdToAccountId.get(quote.Id), 
                                                        Opportunity__c = quote.Opportunity__c,Name = 'Comp ' + quote.Opportunity__r.Name);

                // Adding it to the list
                compList.add(comp);
            }

            // Making it as a Database.insert with allOrNone as false because the comp creation might fail if the account is already related to an opportunity
            Database.insert(compList,false);
        }

    }
}
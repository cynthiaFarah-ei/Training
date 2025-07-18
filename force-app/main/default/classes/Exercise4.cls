public with sharing class Exercise4 {
    public static void updateOfferIdentifier( List<Offer__c> newOffersList, Map<Id,Offer__c> IdsToOffersOldMap){
        
        // to save each oppId and its related offers
        Map<Id,List<Offer__c>> oppIdToOffersMap = new Map<Id,List<Offer__c>>();

        for(offer__c offr : newOffersList){
            if(IdsToOffersOldMap == null || IdsToOffersOldMap.get(offr.Id).Opportunity__c != offr.Opportunity__c){
                if(oppIdToOffersMap.containsKey(offr.Opportunity__c)){
                    // oppId has a list and we should add to this list
                    // so get this list and add offer to it
                    oppIdToOffersMap.get(offr.opportunity__c).add(offr);
                } else{ 
                    // first offer for this opp id 
                    oppIdToOffersMap.put(offr.opportunity__c, new List<Offer__c>{offr});
                }
            }
        }

        if(! oppIdToOffersMap.isEmpty()){
            for(Opportunity opp : [SELECT Id, Opportunity_Identifier__c, TECH_Offer_Counter__c FROM Opportunity WHERE Id IN :oppIdToOffersMap.keySet() ]){
                
                Integer identNumber = (Integer)opp.TECH_Offer_Counter__c;

                for(Offer__c off : oppIdToOffersMap.get(opp.Id)){
                    // loop through each off to this opp

                    String identNumberString = String.valueOf(identNumber++);

                    // Shorthand notation of if to set the correct format on the identifier
                    // If the number in the roll up summary is made of 1 digit then add 2 zeros prior else if it has 2 digits then add 1 zero else keep it as it is
                    identNumberString = identNumberString.length() == 1 ? 
                    '00' + identNumberString : identNumberString.length() == 2 ? '0' + identNumberString : identNumberString;

                    off.Offer_Identifier__c = opp.Opportunity_Identifier__c + '-'+ identNumberString;
                }
            }
        }



        // Set<Id> oppsIdsSet = new Set<Id>();
        
        // for(Offer__c offer : newOffersList){
        //     // if insert or update opportunity 
        //     if(IdsToOffersOldMap == null || IdsToOffersOldMap.get(offer.Id).Opportunity__c != offer.Opportunity__c){
        //         oppsIdsSet.add(offer.Opportunity__c); // ids of opportunities linked to offers
        //     }
        // }
        
        // Map<Id, Decimal> OppIdsToCountsMap = new Map<Id, Decimal>();
        // Map<Id, String> OppIdsToIdentifierMap = new Map<Id, String>();
        
        // if(!oppsIdsSet.isEmpty()){
        //     for(Opportunity opp : [SELECT Opportunity_Identifier__c, TECH_Offer_Counter__c FROM Opportunity WHERE Id IN :oppsIdsSet]){
        //         OppIdsToCountsMap.put(opp.Id, opp.TECH_Offer_Counter__c);
        //         OppIdsToIdentifierMap.put(opp.Id, opp.Opportunity_Identifier__c);
        //     }
            
        //     for(Offer__c newOffer : newOffersList){
        //         if(IdsToOffersOldMap != null){ 
        //             // we need old opp id to decrement count 
        //             Offer__c oldOfferVal =IdsToOffersOldMap.get(newOffer.Id);
        //             Id oppId = oldOfferVal.opportunity__c;
        //             Decimal count = OppIdsToCountsMap.get(oppId) - 1;
        //             OppIdsToCountsMap.put(oppId,count);
        //         }
        //         Decimal count = OppIdsToCountsMap.get(newOffer.opportunity__c);
        //         String counter = count.format();
        //         String identifier = OppIdsToIdentifierMap.get(newOffer.opportunity__c);
        //         String offerIdentifier =identifier  + ' - ' + counter;
        //         OppIdsToCountsMap.put(newOffer.opportunity__c, count + 1);
                
        //         newOffer.Offer_Identifier__c = offerIdentifier;
        //     }
        // }
    }
}
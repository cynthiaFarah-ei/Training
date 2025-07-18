public with sharing class Exercise1 {
    public Exercise1() {

    }

    // this method takes a list of names and count for each name nb of occurences and save it in a map and return it 
    public static Map<String,Integer> countNameOccurences(List<String> namesList){
        Map<String,Integer> nameToOccurencesMap = new Map<String,Integer>();
        for( String name : namesList){
            if(nameToOccurencesMap.containsKey(name)){
                nameToOccurencesMap.put(name, nameToOccurencesMap.get(name)+1);
            }else{
                nameToOccurencesMap.put(name, 1);
            }
        }
        return nameToOccurencesMap;
    }
}

// testing in execute anonymous
// List <String> namesList = new List<String>();
// namesList.add('cynthia');
// namesList.add('cynthia');
// namesList.add('perla');
// namesList.add('maria');
// namesList.add('mario');
// namesList.add('perla');
// namesList.add('serge');
// namesList.add('maroun');
// namesList.add('maroun');
// namesList.add('maroun');
// Map<String, Integer> namesToOccurences;
// namesToOccurences = Exercise1.countNameOccurences(namesList);
// System.debug(namesToOccurences);
trigger SetContact on redwing__Achievement_Assignment__c (before update, before insert) {

     if(trigger.isbefore){
          for(redwing__Achievement_Assignment__c ach : trigger.new) {
              ach.Contact__c =  ach.redwing__Contact__c;
          }
  }
}
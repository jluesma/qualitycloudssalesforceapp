/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : Schedule_AutoLeadConversionBatch
Author          : Lister Technologies
Description     : This is a schedule class for auto conversion of lead.
Test Class      : Test_AutoLeadConversionBatch
Batch Class     : AutoLeadConversionBatch
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
global class Schedule_AutoLeadConversionBatch implements Schedulable{
    global void execute(SchedulableContext SC){
        AutoLeadConversionBatch alcb = new AutoLeadConversionBatch();
        database.executeBatch(alcb);
    }
}
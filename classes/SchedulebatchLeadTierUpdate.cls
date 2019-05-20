global class SchedulebatchLeadTierUpdate implements Schedulable {
    global void execute(SchedulableContext SC) {
          batchLeadTierUpdate bo=new batchLeadTierUpdate();
Database.executeBatch(bo,50);
    }
}
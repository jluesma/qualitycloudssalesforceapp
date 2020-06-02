public class NewController {

    List<Account> account;

    public List<Account> getAccounts(){
        accounts = [SELECT Name FROM Account WHERE phone =: null];
        return accounts;
    }
}
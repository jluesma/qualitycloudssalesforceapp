public NewAccountController{

    List<Account> accounts;

    public List<Account> getAccounts(){
        accounts = [SELECT Name FROM Account WHERE phone =: null];
        return accounts;
    }
}
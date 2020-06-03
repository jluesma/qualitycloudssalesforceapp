public class NewAccountController {

	List<Account> accounts;

	public List<Account> getAccounts() {
		accounts = [SELECT Name FROM Account where phone =: null];
		return accounts;
	}

}
class BankAccount
{
    late String accountNumber;
    final String holderName;
    double balance;
    String? bankBranch;
    bool _isInitialized= false;

    BankAccount({
        required this.holderName,
        this.balance=0.0,
        this.bankBranch,
    });

    void initializeAccount(String number)
    {
            accountNumber = number; 
            _isInitialized=true;
        }

    String checkNumber()
    {
        return _isInitialized ? accountNumber : "Not Set Up";
    }
}
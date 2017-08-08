/* CSCI3180 Principles of Programming Languages
   -- Declaration ---
   I declare that the assignment here submitted 
   is original except for source material explicitly
   acknowledged. I also acknowledge that I am aware of
   University policy and regulations on honesty in 
   academic work, and of the disciplinary guidelines
   and procedures applicable to breaches of such policy
   and regulations, as contained in the website
   http://www.cuhk.edu.hk/policy/academichonesty/
   Assignment 3
   Name: 
   Student ID: 
   Email Addr: 
*/
#include <iostream>
using namespace std;



int repayment (char name[], int balance, int repayAmt, int creditLimit)
{

  std::cout << "\n... Repaying debts ...\n";
  std::cout << "Thank you, " << name << "! ";

  balance -= repayAmt;

  std::cout << "You have just repayed [HKD " << repayAmt << "]!\n";

  int currentLimit = creditLimit - balance;
  std::cout << "Now your remaining credit limit is [HKD " << currentLimit << "].\n";

  return balance;
}

int payment (char name[], int balance, int payAmt, int creditLimit)
{

    std::cout << "\n... Consumption payment (Luk Card) ...\n";

    int currentLimit = creditLimit - balance;
    if (currentLimit < payAmt) {
        std::cout << "You have exceeded your credit limit!\n";
        return -1;
    }

    currentLimit -= payAmt;

    balance += payAmt;

    std::cout << "You have just payed a [HKD " << payAmt << "] consumption!\n";

    std::cout << "Now your remaining credit limit is [HKD " << currentLimit << "].\n";

    return balance;
}

int regularClient (char name[], int balance, int repayAmt, int payAmt, int creditLimit = 5000)
{

    // Repaying debts
    balance = repayment(name, balance, repayAmt, creditLimit);

    if (balance >= 0) {
        std::cout << "[Current card balance: HKD " << balance << "]\n";
    }
    else {
        std::cout << "ERROR! You are trying to repay more than your debt amount!\n";
    }


    // Paying for consumption
    balance = payment(name, balance, payAmt, creditLimit);

    if (balance >= 0) {
        std::cout << "[Current card balance: HKD " << balance << "]\n";
    }
    else {
        std::cout << "ERROR! You are trying to pay beyond your credit limit!\n";
    }
}

int premierClient (char name[], int balance, int repayAmt, int payAmt)
{

    int creditLimit = 10000;

    std::cout << "Dear Premier client " << name << ", you have a credit limit of [HKD " << creditLimit << "]! Enjoy!\n";

    regularClient(name, balance, repayAmt, payAmt, creditLimit);
}

int bank (char name[], char ID[], int balance, int repayAmt, int payAmt)
{

    std::cout << "\n** Welcome " << name << " **\n";
    std::cout << "[Your credit card balance: HKD " << balance << "]\n";

    if (strchr(ID,'p')) {
        premierClient(name, balance, repayAmt, payAmt);
    }
    else {
        regularClient(name, balance, repayAmt, payAmt);
    }
}

int main(){
  std::cout << "\t\t### Welcome to the CU Bank ###\n";

  bank("Alice", "r123", 2000, 1000, 3000);
  bank("Bob", "p456", 5000, 2000, 7000);
  bank("Carol","r789", 5000, 2000, 7000);
  
  return 0;
}

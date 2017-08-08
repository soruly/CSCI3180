use feature ':5.10';
use warnings;

$creditLimit = 5000;

sub repayment {
    ($name, $balance, $repayAmt) = @_;

    print "\n... Repaying debts ...\n";
    print "Thank you, $name! ";

    $balance -= $repayAmt;

    print "You have just repayed [HKD $repayAmt]!\n";

    $currentLimit = $creditLimit - $balance ;
    print "Now your remaining credit limit is [HKD $currentLimit].\n";

    return $balance;
}

sub payment {
    ($name, $balance, $payAmt) = @_;

    print "\n... Consumption payment (Luk Card) ...\n";

    $currentLimit = $creditLimit - $balance;
    if ($currentLimit < $payAmt) {
        print "You have exceeded your credit limit!\n";
        return -1;
    }

    $currentLimit -= $payAmt;

    $balance += $payAmt;

    print "You have just payed a [HKD $payAmt] consumption!\n";

    print "Now your remaining credit limit is [HKD $currentLimit].\n";

    return $balance;
}

sub regularClient {
    ($name, $balance, $repayAmt, $payAmt) = @_;

    # Repaying debts
    $balance = repayment($name, $balance, $repayAmt);

    if ($balance >= 0) {
        print "[Current card balance: HKD $balance]\n";
    }
    else {
        print "ERROR! You are trying to repay more than your debt amount!\n"
    }


    # Paying for consumption
    $balance = payment($name, $balance, $payAmt);

    if ($balance >= 0) {
        print "[Current card balance: HKD $balance]\n";
    }
    else {
        print "ERROR! You are trying to pay beyond your credit limit!\n"
    }
}

sub premierClient {
    ($name, $balance, $repayAmt, $payAmt) = @_;

    $creditLimit = 10000;

    print "Dear Premier client $name, you have a credit limit of [HKD $creditLimit]! Enjoy!\n";

    regularClient($name, $balance, $repayAmt, $payAmt);
}

sub bank {
    ($name, $ID, $balance, $repayAmt, $payAmt) = @_;

    print "\n** Welcome $name **\n";
    print "[Your credit card balance: HKD $balance]\n";

    if ($ID =~ /p/) {
        premierClient($name, $balance, $repayAmt, $payAmt);
    }
    else {
        regularClient($name, $balance, $repayAmt, $payAmt);
    }
}


print "\t\t### Welcome to the CU Bank ###\n";

bank("Alice", "r123", 2000, 1000, 3000);
bank("Bob", "p456", 5000, 2000, 7000);
bank("Carol","r789", 5000, 2000, 7000);

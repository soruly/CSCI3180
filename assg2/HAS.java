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
   Assignment 2
   Name: 
   Student ID: 
   Email Addr: 
*/
public class HAS {

	public interface Person {
		public String to_s();
		public void buyFood(String s,int i);
	}

	public abstract class HospitalMember{
		public String name;
		public int nbDrugsDispensed;

		public HospitalMember(String name){
			this(name,0);
		}

		public HospitalMember(String name, int nbDrugsDispensed){
			this.name = name;
			this.nbDrugsDispensed = nbDrugsDispensed;
		}

		public abstract String to_s();

		public void seeDoctor(int num){
			System.out.println(this.to_s()+" is sick! S/he sees a doctor.");
		}

		public void getDrugDispensed(int num){
			int nbDrugDispensed;
			if (this.nbDrugsDispensed < num) {
				nbDrugDispensed = this.nbDrugsDispensed;
				this.nbDrugsDispensed = 0;
			}
			else{
				nbDrugDispensed = num;
				this.nbDrugsDispensed -= num;
			}
			System.out.println("Dispensed "+nbDrugDispensed+" drug items, "+this.nbDrugsDispensed+" items still to be dispensed.");
		}
	}

	public class Doctor extends HospitalMember implements Person {
		String staffID;
		int salary;

		public void buyFood(String foodName, int payment){
			System.out.println("Buy "+foodName+" and pay $"+Integer.toString(payment)+".");
			this.pay(payment);
		}

		public Doctor(String staffID, String name){
			super(name);
			this.staffID = staffID;
			this.salary = 100000;
		}

		public String to_s(){
			return "Doctor "+this.name+" ("+this.staffID+")";
		}

		public void seeDoctor(int num){
			super.seeDoctor(num);
			this.nbDrugsDispensed += num;
			System.out.println("Totally "+this.nbDrugsDispensed+" drug items administered.");
		}

		public void getSalary(int amount){
			this.salary += amount;
			System.out.println(this.to_s()+" has got HK$" + Integer.toString(this.salary) + " salary left.");
		}

		public void pay(int amount){
			this.salary -= amount;
			System.out.println(this.to_s()+" has got HK$" + Integer.toString(this.salary) + " salary left.");
		}

		public void attendClub(){
			System.out.println("Eat and drink in the Club.");
		}
	}

	public class Patient extends HospitalMember implements Person {
		public String stuID;
		public int money;

		public void buyFood(String foodName, int payment){
			System.out.println("Buy "+foodName+" and pay $"+Integer.toString(payment)+".");
			this.pay(payment);
		}

		public Patient(String stuID, String name){
			super(name);
			this.stuID = stuID;
			this.money = 10000;
		}

		public String to_s(){
			return "Patient "+this.name+" ("+this.stuID+")";
		}

		public void seeDoctor(int num){
			super.seeDoctor(num);
			int max = 15;
			if (num < max - this.nbDrugsDispensed)
				this.nbDrugsDispensed += num;
			else
				this.nbDrugsDispensed = max;
		
			System.out.println("Totally "+this.nbDrugsDispensed+" drug items administered.");
		}

		public void pay(int amount){
			this.money -= amount;
			System.out.println(this.to_s()+" has got HK$" + Integer.toString(this.money) + " left in the wallet.");
		}
	}

	public class Visitor implements Person {
		String visitorID;
		int money;

		public void buyFood(String foodName, int payment){
			System.out.println("Buy "+foodName+" and pay $"+Integer.toString(payment)+".");
			this.pay(payment);
		}

		public Visitor(String visitorID){
			this.visitorID = visitorID;
			this.money = 1000;
		}

		public String to_s(){
			return "Visitor "+this.visitorID;
		}

		public void pay(int amount){
			this.money -= amount;
			System.out.println(this.to_s()+" has got HK$" + Integer.toString(this.money) + " left in the wallet.");
		}
	}

	public class Pharmacy{
		String pharmName;

		public Pharmacy(String name){
			this.pharmName = name;
		}

		public String to_s(){
			return this.pharmName+" Pharmacy";
		}

		public void dispenseDrugs(Person person, int numOfDrugs){
			if(person instanceof Patient){
				Patient patient = (Patient) person;
				patient.getDrugDispensed(numOfDrugs);
			}
			else if(person instanceof Doctor){
				Doctor doctor = (Doctor) person;
				doctor.getDrugDispensed(numOfDrugs);
			}
			else{
				System.out.println(person.to_s()+" is not a pharmacy user!");
			}
		}

	}

	public class Canteen {
		String ctnName;

		public Canteen(String name){
			this.ctnName = name;
		}

		public String to_s(){
			return this.ctnName+" Canteen";
		}

		public void sellNoodle(Person person){
			int price = 40;
			person.buyFood("Noodle", price);
		}
	}

	public class Department{
		String deptName;

		public Department(String name){
			this.deptName = name;
		}

		public String to_s(){
			return this.deptName+" Department";
		}

		public void callPatient(Person person, int amount){
			if(person instanceof Patient){
				Patient patient = (Patient) person;
				patient.seeDoctor(amount);
			}
			else if(person instanceof Doctor){
				Doctor doctor = (Doctor) person;
				doctor.seeDoctor(amount);
			}
			else{
				System.out.println(person.to_s()+" has no rights to get see a doctor!");
			}
		}

		public void paySalary(Person person, int amount){
			if(person instanceof Doctor){
				Doctor doctor = (Doctor) person;
				System.out.println(this.to_s()+" pays Salary $"+Integer.toString(amount)+" to "+person.to_s()+".");
				doctor.getSalary(amount);
			}
			else{
				System.out.println(person.to_s()+" has no rights to get salary from "+this.to_s()+"!");
			}
		}

	}


	public class StaffClub{
		public String clubName;

		public StaffClub(String name){
			this.clubName = name;
		}
		public String to_s(){
			return this.clubName+" Club";
		}
		
		public void holdParty(Person person){
			if(person instanceof Doctor){
				Doctor doctor = (Doctor) person;
				doctor.attendClub();
			}
			else{
				System.out.println(person.to_s()+" has no rights to use facilities in the Club!");
			}
		}
	}

	public void run(){
		System.out.println("Hospital Administration System:");
        Patient alice = new Patient("p001", "Alice");
		Doctor bob = new Doctor("d001", "Bob");
		Visitor visitor = new Visitor("v001");
		Pharmacy mainPharm = new Pharmacy("Main");
		Canteen bigCtn = new Canteen("Big Big");
		Department ane = new Department("A&E");
		StaffClub teaClub = new StaffClub("Happy");

		Person[] person_list = new Person[] {alice, bob, visitor};

        for(Person person : person_list){

	    	System.out.println();
	    	System.out.println(person.to_s() + " enters CU Hospital ...");
			//A&E
			System.out.println(person.to_s() + " enters " + ane.to_s() + ".");
			ane.callPatient(person, 20);
			//pharmacy
			System.out.println(person.to_s() + " enters " + mainPharm.to_s() + ".");
			mainPharm.dispenseDrugs(person, 10);
			mainPharm.dispenseDrugs(person, 25);
			//canteen
			System.out.println(person.to_s() + " enters " + bigCtn.to_s() + ".");
			bigCtn.sellNoodle(person);
			//A&E again
			System.out.println(person.to_s() + " enters " + ane.to_s() + " again.");
			ane.paySalary(person, 10000);
			//club
			System.out.println(person.to_s() + " enters " + teaClub.to_s() + ".");
			teaClub.holdParty(person);
		}
	}

    public static void main(String[] args) {
    	HAS has = new HAS();
        has.run();
    }

}
#Hospital Administration System

module FoodBuying
	def buyFood(foodName, payment)
		puts "Buy #{foodName} and pay $#{payment}."
		pay(payment)
	end
end

class HospitalMember
	def initialize(name, nbDrugsDispensed=0)
		@name = name;
		@nbDrugsDispensed = nbDrugsDispensed;
	end
	def seeDoctor(num)
		puts self.to_s + " is sick! S/he sees a doctor."; #This method will be overridden in the subclass!
	end
	def getDrugDispensed(num)
		if @nbDrugsDispensed < num
			nbDrugDispensed = @nbDrugsDispensed;
			@nbDrugsDispensed = 0;
		else
			nbDrugDispensed = num;
			@nbDrugsDispensed -= num;
		end
		puts "Dispensed #{nbDrugDispensed} drug items, #{@nbDrugsDispensed} items still to be dispensed."
	end
end

class Doctor < HospitalMember
	include FoodBuying # include module FoodBuying
	def initialize(staffID, name)
		super(name)
		@staffID = staffID;
		@salary = 100000;
	end
	def to_s
		return "Doctor #{@name} (#{@staffID})"
	end
	def seeDoctor(num)
		super(num);
		@nbDrugsDispensed += num;
		puts "Totally #{@nbDrugsDispensed} drug items administered."
	end
	def getSalary(amount)
		@salary += amount;
		puts self.to_s + " has got HK$" + @salary.to_s + " salary left."
	end
	def pay(amount)
		@salary -= amount;
		puts self.to_s + " has got HK$" + @salary.to_s + " salary left."
	end
	def attendClub()
		puts "Eat and drink in the Club."
	end
end

class Patient < HospitalMember
	include FoodBuying # include module FoodBuying
	def initialize(stuID, name)
		super(name)
		@stuID = stuID;
		@money = 10000;
	end
	def to_s
		return "Patient #{@name} (#{@stuID})"
	end
	def seeDoctor(num)
		super(num);
		max = 15;
		if num < max - @nbDrugsDispensed
			@nbDrugsDispensed += num;
		else
			@nbDrugsDispensed = max;
		end
		puts "Totally #{@nbDrugsDispensed} drug items administered."
	end
	def pay(amount)
		@money -= amount;
		puts self.to_s + " has got HK$" + @money.to_s + " left in the wallet."
	end
end

class Visitor
	include FoodBuying # include module FoodBuying
	def initialize(visitorID)
		@visitorID = visitorID;
		@money = 1000;
	end
	def to_s
		return "Visitor #{@visitorID}"
	end
	def pay(amount)
		@money -= amount;
		puts self.to_s + " has got HK$" + @money.to_s + " left in the wallet."
	end
end

class Pharmacy
	def initialize(name)
		@pharmName = name;
	end
	def to_s
		return "#{@pharmName} Pharmacy"
	end
	def dispenseDrugs(person, numOfDrugs)
		if person.respond_to?(:getDrugDispensed)
			person.getDrugDispensed(numOfDrugs);
		else
			puts "#{person.to_s} is not a pharmacy user!"
		end
	end
end

class Canteen
	def initialize(name)
		@ctnName = name;
	end
	def to_s
		return "#{@ctnName} Canteen"
	end
	def sellNoodle(person)
		price = 40;
		person.buyFood("Noodle", price);
	end
end
class Department
	def initialize(name)
		@deptName = name;
	end
	def to_s
		return "#{@deptName} Department"
	end
	def callPatient(person, amount)
		if person.respond_to?(:seeDoctor)
			person.seeDoctor(amount);
		else
			puts "#{person.to_s} has no rights to get see a doctor!";
		end
	end
	def paySalary(person, amount)
		if person.respond_to?(:getSalary)
			puts to_s + " pays Salary $#{amount} to #{person.to_s}.";
			person.getSalary(amount);
		else
			puts "#{person.to_s} has no rights to get salary from #{to_s}!";
		end
	end
end
class StaffClub
	def initialize(name)
		@clubName = name;
	end
	def to_s
		return "#{@clubName} Club"
	end
	def holdParty(person)
		if person.respond_to?(:attendClub)
			person.attendClub();
		else
			puts "#{person.to_s} has no rights to use facilities in the Club!";
		end
	end
end

# run the system
puts "Hospital Administration System:"

# roles
alice = Patient.new("p001", "Alice");
bob = Doctor.new("d001", "Bob");
visitor = Visitor.new("v001");
mainPharm = Pharmacy.new("Main");
bigCtn = Canteen.new("Big Big");
ane = Department.new("A&E");
teaClub = StaffClub.new("Happy");

# roles in different activities
person_list = [alice, bob, visitor];
person_list.each{|person|
	puts;
	puts person.to_s + " enters CU Hospital ..."
	#A&E
	puts person.to_s + " enters " + ane.to_s + ".";
	ane.callPatient(person, 20);
	#pharmacy
	puts person.to_s + " enters " + mainPharm.to_s + ".";
	mainPharm.dispenseDrugs(person, 10);
	mainPharm.dispenseDrugs(person, 25);
	#canteen
	puts person.to_s + " enters " + bigCtn.to_s + ".";
	bigCtn.sellNoodle(person);
	#A&E again
	puts person.to_s + " enters " + ane.to_s + " again.";
	ane.paySalary(person, 10000);
	#club
	puts person.to_s + " enters " + teaClub.to_s + ".";
	teaClub.holdParty(person);
}

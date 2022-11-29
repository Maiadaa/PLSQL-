/* TYPES */
CREATE OR REPLACE TYPE name_type AS OBJECT (
    FName VARCHAR(20), 
    LName VARCHAR(20)
);

CREATE OR REPLACE TYPE add_type AS OBJECT (
    city VARCHAR(20), 
    country VARCHAR(20)
);

CREATE OR REPLACE TYPE person_type IS OBJECT (
    person_id number, 
    person_name name_type,
    gender CHAR,
    email VARCHAR(20),
    phone_num VARCHAR(13),
    address add_type
)NOT FINAL;

CREATE OR REPLACE TYPE vehicle_agent_type UNDER person_type (
    agency_id number
);

CREATE OR REPLACE TYPE vehicle_type IS OBJECT (
    plate_num VARCHAR(6), 
    model_name VARCHAR(20),
    color VARCHAR(20),
    model_year INT,
    rental_price FLOAT, 
    managed_by REF vehicle_agent_type
);

CREATE OR REPLACE TYPE hotel_agent_type UNDER person_type (
    role VARCHAR(20)
);

CREATE OR REPLACE TYPE hotel_type IS OBJECT (
    hotel_id int, 
    rating FLOAT,
    phone_num VARCHAR(13),
    hotel_name VARCHAR(20),
    hotel_address add_type, 
    managed_by REF hotel_agent_type
);

CREATE OR REPLACE TYPE room_type IS OBJECT (
    room_id int, 
    price FLOAT,
    room_num  INT,
    found_in REF hotel_type
);

CREATE OR REPLACE TYPE airline_agent_type UNDER person_type (
    office_loc add_type
);

CREATE OR REPLACE TYPE airline_type IS OBJECT (
    airline_name VARCHAR(20), 
    airline_type VARCHAR(20), /* private or public */
    branch add_type,
    email VARCHAR(30),
    phone_num VARCHAR(13),
    managed_by REF airline_agent_type 
);

CREATE OR REPLACE TYPE aircraft_type IS OBJECT (
    craft_num INT,
    model_name VARCHAR(20),
    model_year INT,
    manifacturer VARCHAR(20),
    capacity INT,     
    belong_to REF airline_type
);

CREATE OR REPLACE TYPE airport_type IS OBJECT (
    location add_type,
    name VARCHAR(20), 
    code VARCHAR(5)
);

CREATE OR REPLACE TYPE aircraft_airport_type IS OBJECT (
    aircraft_ref REF aircraft_type,
    airport_ref REF airport_type,
    timing VARCHAR(20)
);

CREATE OR REPLACE TYPE trip_type IS OBJECT (
    trip_id INT,
    class_type CHAR, 
    departure_loc VARCHAR(5),
    destination_loc VARCHAR(5),
    departure_time VARCHAR(8),
    arrival_time VARCHAR(8),
    trip_fare FLOAT,
    offered_by REF airline_type
);


CREATE OR REPLACE TYPE manager_type UNDER person_type (
    salary FLOAT
);

CREATE OR REPLACE TYPE user_type UNDER person_type (
    credit_card_num VARCHAR(12) 
);

CREATE OR REPLACE TYPE user_trip_type AS OBJECT (
    seat_num INT,
    user_ref REF user_type,
    trip_ref REF trip_type
);

CREATE OR REPLACE TYPE user_room_type  AS OBJECT(
    user_ref REF user_type,
    room_ref REF room_type,
    checkin VARCHAR(20),
    checkout VARCHAR(20),
    days INT,
    total_price FLOAT
);

CREATE OR REPLACE TYPE user_vehicle_type  AS OBJECT(
    user_ref REF user_type,
    vehicle_ref REF vehicle_type,
    user_license_num INT,
    days INT,
    total_price FLOAT
);

/* TABLES */

CREATE TABLE user_tbl OF user_type(
    CONSTRAINT user_pk PRIMARY KEY(person_id)
);
CREATE TABLE manager OF manager_type(
    CONSTRAINT manager_pk PRIMARY KEY(person_id)
);
CREATE TABLE hotel_agent OF hotel_agent_type(
    CONSTRAINT hotel_agent_pk PRIMARY KEY(person_id)
);
CREATE TABLE vehicle_agent OF vehicle_agent_type(
    CONSTRAINT vehicle_agent_pk PRIMARY KEY(person_id)
);
CREATE TABLE airline_agent OF airline_agent_type(
    CONSTRAINT airline_agent_pk PRIMARY KEY(person_id)
);

CREATE TABLE airline OF airline_type(
    Constraint Airline_Pk1 Primary Key(Airline_Name,Phone_Num),
    managed_by SCOPE IS airline_agent NOT NULL
);

CREATE TABLE trip OF trip_type(
    Constraint Trip_Pk1 Primary Key(Trip_Id),
    offered_by SCOPE IS airline NOT NULL
);

CREATE TABLE airport OF airport_type(
    CONSTRAINT airport_pk1 PRIMARY KEY(code)
);

CREATE TABLE aircraft OF aircraft_type(
    Constraint Aircraft_Pk1 Primary Key(Craft_Num, Model_Name),
    belong_to SCOPE IS airline NOT NULL
);

CREATE TABLE landing OF aircraft_airport_type(
    Constraint Landing_Pk1 Primary Key(Timing),
    Airport_Ref Scope Is Airport Not Null,
    aircraft_ref SCOPE IS aircraft NOT NULL
);

CREATE TABLE tripBooking OF user_trip_type(
    Constraint Tripbook_Pk1 Primary Key(Seat_Num),
    User_Ref Scope Is User_Tbl Not Null,
    trip_ref SCOPE IS trip NOT NULL
);


CREATE TABLE hotel OF hotel_type(
   Constraint Hotel_Pk1 Primary Key(Hotel_Id),
   managed_by SCOPE IS hotel_agent NOT NULL
);

CREATE TABLE room OF room_type(
    Constraint Room_Pk  Primary Key(Room_Id),
    found_in SCOPE IS hotel NOT NULL
);

CREATE TABLE roomReservation OF user_room_type(
    Constraint Roomreserve_Pk1 Primary Key(Checkin),
    User_Ref Scope Is User_Tbl Not Null,
    room_ref SCOPE IS room NOT NULL
);

CREATE TABLE vehicle OF vehicle_type(
    CONSTRAINT vehicle_pk1  PRIMARY KEY(plate_num),
    managed_by SCOPE IS vehicle_agent NOT NULL
);

CREATE TABLE vehicleRental OF user_vehicle_type(
    Constraint Vehiclerent_Pk1 Primary Key(User_License_Num),
    User_Ref Scope Is User_Tbl Not Null,
    vehicle_ref SCOPE IS vehicle NOT NULL
);


/* INSERTIONS */
/* Order of insertions:
   maiada:
	users 
  	managers
   	hotel agents 
   	vehicle agents 
   assem:
	hotel 
   	landing 
   	trip
   	airport
   Hagrass: 
	aircraft 
    airline
   	tripBooking
    airline agent
   Fahmy:
	room
   	roomReservation
  	vehicle 
   	vehicleRental 
/*
/*INSERT INTO user VALUES ('1', name_type('maiada', 'khaled'), 'F', 'maiada', '+201010', add_type('newCairo', 'Egypt'), '5555');*/
/*users*/
Insert Into User_tbl Values ('1', Name_Type('Maiada', 'Khaled'), 'F', 'maiada@aol.com', '+201010101010', Add_Type('newCairo', 'Egypt'), '1111 1111');
INSERT INTO User_tbl VALUES ('2', name_type('Karim', 'Mohsen'), 'M', 'karim@yahoo.com', '+201111111111', add_type('Alex', 'Egypt'), '5555 5555');

/*managers*/
Insert Into Manager Values ('3', Name_Type('Hassan', 'Kamal'), 'M', 'hassan@gmail.com', '+201122222222', Add_Type('Cairo', 'Egypt'), '15000');
Insert Into manager Values ('4', Name_Type('Youssef', 'Wael'), 'M', 'Youssef@outlook.com', '+201133333333', Add_Type('Giza', 'Egypt'), '12000');

/*hotel agents*/
Insert Into Hotel_Agent Values ('5', Name_Type('Mohamed', 'Diab'), 'M', 'mohamed@outlook.com', '+201044444444', Add_Type('AinSokhna', 'Egypt'), 'Receptionnist');
Insert Into Hotel_Agent Values ('6', Name_Type('Ziad', 'Ali'), 'M', 'ziad@outlook.com', '+201055555555', Add_Type('AinSokhna', 'Egypt'), 'Customer service');
Insert Into Hotel_Agent Values ('7', Name_Type('Gasser', 'Ahmed'), 'M', 'gahmed@outlook.com', '+20112222555', Add_Type('AinSokhna', 'Egypt'), 'Customer service');

/*vehicle agents*/
Insert Into vehicle_Agent Values ('7', Name_Type('Islam', 'Saad'), 'M', 'islam@gmail.com', '+201266666666', Add_Type('October', 'Egypt'), '1');
Insert Into vehicle_Agent Values ('8', Name_Type('Sara', 'Hesham'), 'F', 'ziad@aol.com', '+201277777777', Add_Type('October', 'Egypt'), '2');

/*ariline agents*/
INSERT INTO airline_agent VALUES (1, name_type('maiada', 'khaled'), 'F', 'maiada@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (2, name_type('abdelrahman', 'hagrass'), 'M', 'hagrass@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (3, name_type('mahmoud', 'assem'), 'm', 'assem@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (4, name_type('hagrass', 'abdelrahman'), 'M', 'abdelrahman@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (5, name_type('mahmoud', 'medhat'), 'M', 'medhat@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (6, name_type('manar', 'hossam'), 'F', 'manar@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (7, name_type('shahd', 'khaled'), 'F', 'shahd@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (8, name_type('mohamed', 'khaled'), 'M', 'mohamed@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (9, Name_Type('Mahmoud', 'Assem'), 'M' , 'masseem@gmail.com', '+201277777777', Add_Type('Rehab' , 'Egypt'), Add_Type('Nasr-City','Cairo'));
INSERT INTO airline_agent VALUES (10, Name_Type('Mario', 'Medhat'), 'M' , 'mmedhat@gmail.com', '+201277777788', Add_Type('Heliopolis' , 'Egypt'), Add_Type('Fifth-Settlement','Cairo'));
INSERT INTO airline_agent VALUES (11, Name_Type('Hassan', 'Mohamed'), 'M' , 'hmohamed@gmail.com', '+201277777878', Add_Type('Dubai' , 'UAE'), Add_Type('Abu Dhabi','UAE'));
INSERT INTO airline_agent VALUES (12, Name_Type('Sayed', 'Hamed'), 'M' , 'shamed@gmail.com', '+201299998745', Add_Type('Doha' , 'Qatar'), Add_Type('Doha','Qatar'));

/*airlines*/
INSERT INTO airline select (airline_type('Egyptair', 'public', add_type('Cairo', 'Egypt'), 'EgyptAir@air.com@', '01013700990', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 2;
INSERT INTO airline select (airline_type('Alaska', 'public', add_type('Cairo', 'Egypt'), 'Alaska@air.com@', '123456789', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 1;
INSERT INTO airline select (airline_type('American', 'public', add_type('Cairo', 'Egypt'), 'American@air.com@', '321654987', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 3;
INSERT INTO airline select (airline_type('United', 'public', add_type('Cairo', 'Egypt'), 'United@air.com@', '987654321', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 4;
INSERT INTO airline select (airline_type('Delta', 'public', add_type('Cairo', 'Egypt'), 'Delta@air.com@', '019584848', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 5;
INSERT INTO airline select (airline_type('Allegiant', 'public', add_type('Cairo', 'Egypt'), 'Allegiant@air.com@', '012924123', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 6;
INSERT INTO airline select (airline_type('Spirit', 'public', add_type('Cairo', 'Egypt'), 'Spirit@air.com@', '0123643434', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 7;
INSERT INTO airline select (airline_type('Grant Aviation', 'public', add_type('Cairo', 'Egypt'), 'Grant_Aviation@air.com@', '9876736743', ref(HisAgent))) 
from airline_agent HisAgent where HisAgent.person_id = 8;

/*trips*/

INSERT INTO trip select(trip_type(1,'B', 'Cairo' ,'Alex' ,'7:00AM' , '8:34AM' , 550, ref(air)))
from airline air where air.airline_name = 'Egyptair' and air.phone_num = '01013700990';

INSERT INTO trip select(trip_type(2,'F', 'HRG' ,'LUX' ,'10:00AM' , '8:34AM' , 1120, ref(air)))
from airline air where air.airline_name = 'Alaska' and air.phone_num = '123456789';

INSERT INTO trip select(trip_type(3,'E', 'Alex' ,'Cairo' ,'3:00PM' , '4:47AM' , 1050, ref(air)))
from airline air where air.airline_name = 'American' and air.phone_num = '321654987';

INSERT INTO trip select(trip_type(4,'E', 'Cairo' ,'HRG' ,'9:00AM' , '11:14AM' , 1550, ref(air)))
from airline air where air.airline_name = 'United' and air.phone_num = '987654321';

INSERT INTO trip select(trip_type(5,'F', 'Cairo' ,'LUX' ,'7:00AM' , '8:34AM' , 1785, ref(air)))
from airline air where air.airline_name = 'Egyptair' and air.phone_num = '01013700990';

/*airports*/

INSERT INTO airport VALUES (Add_Type('Cairo','Egypt') , 'Cairo Airport', 'EG-01');

INSERT INTO airport VALUES (Add_Type('Cairo','Egypt') , 'Almaza Airport', 'EG-02');

INSERT INTO airport VALUES (Add_Type('Hurghada','Egypt') , 'Hurghada  Airport', 'EG-03');

INSERT INTO airport VALUES (Add_Type('Luxor','Egypt') , 'Luxor  Airport', 'EG-04');

INSERT INTO airport VALUES (Add_Type('Alexandria','Egypt') , 'Borg Arab Airport', 'EG-05');
/*hotels*/

insert into hotel select (hotel_type(2001, 4.5 , '0122222222', 'Radisson', add_type('Cairo', 'Egypt'), ref(hotelAgent)))
from Hotel_Agent hotelAgent where hotelAgent.person_id = 5;

insert into hotel select (hotel_type(2002, 4.5 , '0122222222', 'Meridien', add_type('Hurghada', 'Egypt'), ref(hotelAgent)))
from Hotel_Agent hotelAgent where hotelAgent.person_id = 6;

insert into hotel select (hotel_type(2003, 4.5 , '0122222222', 'Intercontinental', add_type('Cairo', 'Egypt'), ref(hotelAgent)))
from Hotel_Agent hotelAgent where hotelAgent.person_id = 7;

/*aircrafts*/

INSERT INTO aircraft select (aircraft_type(1, 'Traveler', 2013, 'AERONCA', 300, ref(air)))
from airline air where air.airline_name = 'Egyptair' and air.phone_num = '01013700990';

INSERT INTO aircraft select (aircraft_type(2, 'Citabria', 2018, 'BELLANCA', 500, ref(air)))
from airline air where air.airline_name = 'Alaska' and air.phone_num = '123456789';

INSERT INTO aircraft select (aircraft_type(3, 'Tri-Traveler', 2017, 'CHAMPION', 200, ref(air)))
from airline air where air.airline_name = 'American' and air.phone_num = '321654987';

INSERT INTO aircraft select (aircraft_type(4, 'Sky-Trac', 2015, 'CHAMPION', 350, ref(air)))
from airline air where air.airline_name = 'United' and air.phone_num = '987654321';

INSERT INTO aircraft select (aircraft_type(5, 'Master', 2016, ' LUSCOMBE', 250, ref(air)))
from airline air where air.airline_name = 'Delta' and air.phone_num = '019584848';

INSERT INTO aircraft select (aircraft_type(6, 'Colibri', 2014, 'NEW HORIZONS', 550, ref(air)))
from airline air where air.airline_name = 'Allegiant' and air.phone_num = '012924123';

INSERT INTO aircraft select (aircraft_type(7, 'Albertan', 2011, 'ULTIMATE', 100, ref(air)))
from airline air where air.airline_name = 'Spirit' and air.phone_num = '0123643434';

INSERT INTO aircraft select (aircraft_type(8, 'Voyager', 2018, 'STINSON', 150, ref(air)))
from airline air where air.airline_name = 'Grant Aviation' and air.phone_num = '9876736743';

/*landings*/

INSERT INTO landing SELECT (aircraft_airport_type(ref(airc),ref(airp),'5/12/2022 - 5:04PM'))
from aircraft airc , airport airp
where airc.model_name = 'Traveler' and airp.code = 'EG-01';

INSERT INTO landing SELECT (aircraft_airport_type(ref(airc),ref(airp),'7/12/2022 - 4:20PM'))
from aircraft airc , airport airp
where airc.model_name = 'Citabria' and airp.code = 'EG-02';

INSERT INTO landing SELECT (aircraft_airport_type(ref(airc),ref(airp),'7/12/2022 - 8:19PM'))
from aircraft airc , airport airp
where airc.model_name = 'Tri-Traveler' and airp.code = 'EG-03';

INSERT INTO landing SELECT (aircraft_airport_type(ref(airc),ref(airp),'15/12/2022 - 1:10PM'))
from aircraft airc , airport airp
where airc.model_name = 'Sky-Trac' and airp.code = 'EG-04';

INSERT INTO landing SELECT (aircraft_airport_type(ref(airc),ref(airp),'02/01/2022 - 5:04PM'))
from aircraft airc , airport airp
where airc.model_name = 'Master' and airp.code = 'EG-05';


/*tripBookings*/
INSERT INTO tripBooking select (user_trip_type(1, ref(User), ref(Trip)))
from User_Tbl User, trip Trip where User.person_id = 1 and Trip.Trip_Id = 1;
INSERT INTO tripBooking select (user_trip_type(2, ref(User), ref(Trip)))
from User_Tbl User, trip Trip where User.person_id = 2 and Trip.Trip_Id = 2;

/*rooms*/

/*roomReservations*/

/*vehicles*/

/*vehicleRentals*/







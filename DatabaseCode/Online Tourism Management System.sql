/**** TYPES ****/
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
    status varchar(20),
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


/**** TABLES ****/

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


/**** INSERTIONS ****/

/* USERS */
Insert Into User_tbl Values ('1', Name_Type('Maiada', 'Khaled'), 'F', 'maiada@aol.com', '+201010101010', Add_Type('newCairo', 'Egypt'), '1111 1111');
INSERT INTO User_tbl VALUES ('2', name_type('Karim', 'Mohsen'), 'M', 'karim@yahoo.com', '+201111111111', add_type('Alex', 'Egypt'), '5555 5555');

/* MANAGERS*/
Insert Into Manager Values ('3', Name_Type('Hassan', 'Kamal'), 'M', 'hassan@gmail.com', '+201122222222', Add_Type('Cairo', 'Egypt'), '15000');
Insert Into manager Values ('4', Name_Type('Youssef', 'Wael'), 'M', 'Youssef@outlook.com', '+201133333333', Add_Type('Giza', 'Egypt'), '12000');

/* HOTEL AGENTS */
Insert Into Hotel_Agent Values ('5', Name_Type('Mohamed', 'Diab'), 'M', 'mohamed@outlook.com', '+201044444444', Add_Type('AinSokhna', 'Egypt'), 'Receptionnist');
Insert Into Hotel_Agent Values ('6', Name_Type('Ziad', 'Ali'), 'M', 'ziad@outlook.com', '+201055555555', Add_Type('AinSokhna', 'Egypt'), 'Customer service');

/* VEHICLE AGENTS */
Insert Into vehicle_Agent Values ('7', Name_Type('Islam', 'Saad'), 'M', 'islam@gmail.com', '+201266666666', Add_Type('October', 'Egypt'), '1');
Insert Into vehicle_Agent Values ('8', Name_Type('Sara', 'Hesham'), 'F', 'ziad@aol.com', '+201277777777', Add_Type('October', 'Egypt'), '2');

/* AIRLINE AGENTS */
INSERT INTO airline_agent VALUES (1, name_type('maiada', 'khaled'), 'F', 'maiada@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (2, name_type('abdelrahman', 'hagrass'), 'M', 'hagrass@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (3, name_type('mahmoud', 'assem'), 'm', 'assem@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (4, name_type('hagrass', 'abdelrahman'), 'M', 'abdelrahman@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (5, name_type('mahmoud', 'medhat'), 'M', 'medhat@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (6, name_type('manar', 'hossam'), 'F', 'manar@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (7, name_type('shahd', 'khaled'), 'F', 'shahd@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));
INSERT INTO airline_agent VALUES (8, name_type('mohamed', 'khaled'), 'M', 'mohamed@gmail', '10101303', add_type('Cairo', 'Egypt'),add_type('Cairo', 'Egypt'));

/* AIRLINES */
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

/* TRIPS */
INSERT INTO trip select(trip_type('1','B', 'Cairo' ,'Alex' ,'7:00AM' , '8:34AM' , 550, ref(air)))
from airline air where air.airline_name = 'Egyptair' and air.phone_num = '01013700990';

INSERT INTO trip select(trip_type(2,'F', 'HRG' ,'LUX' ,'10:00AM' , '8:34AM' , 1120, ref(air)))
from airline air where air.airline_name = 'Alaska' and air.phone_num = '123456789';

INSERT INTO trip select(trip_type(3,'E', 'Alex' ,'Cairo' ,'3:00PM' , '4:47AM' , 1050, ref(air)))
from airline air where air.airline_name = 'American' and air.phone_num = '321654987';

INSERT INTO trip select(trip_type(4,'E', 'Cairo' ,'HRG' ,'9:00AM' , '11:14AM' , 1550, ref(air)))
from airline air where air.airline_name = 'United' and air.phone_num = '987654321';

Insert Into Trip Select(Trip_Type(5,'F', 'Cairo' ,'LUX' ,'7:00AM' , '8:34AM' , 1785, Ref(Air)))
From Airline Air Where Air.Airline_Name = 'Egyptair' And Air.Phone_Num = '01013700990';

/* AIRPORTS */
INSERT INTO airport VALUES (Add_Type('Cairo','Egypt') , 'Cairo Airport', 'EG-01');

INSERT INTO airport VALUES (Add_Type('Cairo','Egypt') , 'Almaza Airport', 'EG-02');

INSERT INTO airport VALUES (Add_Type('Hurghada','Egypt') , 'Hurghada  Airport', 'EG-03');

INSERT INTO airport VALUES (Add_Type('Luxor','Egypt') , 'Luxor  Airport', 'EG-04');

INSERT INTO airport VALUES (Add_Type('Alexandria','Egypt') , 'Borg Arab Airport', 'EG-05');

/* AIRCRAFTS */
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

/* LANDINGS */
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
Where Airc.Model_Name = 'Master' And Airp.Code = 'EG-05';

/* TRIP BOOKINGS */
INSERT INTO tripBooking select (user_trip_type(1, ref(User_ID), ref(Trip_ID)))
from User_Tbl User_ID, trip Trip_ID where User_ID.person_id = 1 and Trip_ID.Trip_Id = 1;

INSERT INTO tripBooking select (user_trip_type(2, ref(User_ID), ref(Trip_ID)))
from User_Tbl User_ID, trip Trip_ID where User_ID.person_id = 2 and Trip_ID.Trip_Id = 2;

/* HOTELS */
insert into hotel select (hotel_type(2001, 4.5 , '0122222222', 'Radisson', add_type('Cairo', 'Egypt'), ref(hotelAgent)))
from Hotel_Agent hotelAgent where hotelAgent.person_id = 5;

insert into hotel select (hotel_type(2002, 4.5 , '0122222222', 'Meridien', add_type('Hurghada', 'Egypt'), ref(hotelAgent)))
from Hotel_Agent hotelAgent where hotelAgent.person_id = 6;

Insert Into Hotel Select (Hotel_Type(2003, 4.5 , '0122222222', 'Intercontinental', Add_Type('Cairo', 'Egypt'), Ref(Hotelagent)))
from Hotel_Agent hotelAgent where hotelAgent.person_id = 7;

/* ROOMS */

INSERT INTO room select (room_type(1, 2000, 110, 'NotAvailable', ref(Hotel)))
from hotel Hotel where Hotel.hotel_id = 2001;

INSERT INTO room select (room_type(2, 1500, 120, 'NotAvailable', ref(Hotel)))
from hotel Hotel where Hotel.hotel_id = 2002;

INSERT INTO room select (room_type(3, 2200, 130, 'Available', ref(Hotel)))
from hotel Hotel where Hotel.hotel_id = 2002;


/* ROOM RESERVATIONS */

INSERT INTO roomReservation SELECT (user_room_type(ref(UserT),ref(RoomT), '22/10/2022' , '30/10/2022' , 7 , 14000))
from User_tbl UserT , room RoomT
where UserT.person_id = '1' and RoomT.room_id = '2';

INSERT INTO roomReservation SELECT (user_room_type(ref(UserT),ref(RoomT), '5/11/2022' , '7/11/2022' , 2 , 3000))
from User_tbl UserT , room RoomT
where UserT.person_id = '2' and RoomT.room_id = '1';

/* VEHICLES */

INSERT INTO vehicle select (vehicle_type('ARG126' , 'Hyundai Accent' , 'Red' , 2015 , 3000, ref(VehicleAgent)))
from vehicle_agent VehicleAgent where VehicleAgent.person_id= 7;

INSERT INTO vehicle select (vehicle_type('NSB827' , 'Mitsubishi Lancer' , 'Black' , 2018 , 4000, ref(VehicleAgent)))
from vehicle_agent VehicleAgent where VehicleAgent.person_id= 8;

/* VEHICLE RENTALS */

INSERT INTO vehicleRental SELECT (user_vehicle_type(ref(UserV),ref(VehicleV), 145326 , 3 , 9000))
from User_tbl UserV , vehicle VehicleV
where UserV.person_id = '1' and VehicleV.plate_num = 'ARG126';

INSERT INTO vehicleRental SELECT (user_vehicle_type(ref(UserV),ref(VehicleV), 126987 , 5 , 20000))
from User_tbl UserV , vehicle VehicleV
where UserV.person_id = '2' and VehicleV.plate_num = 'NSB827';


/**** PROCEDURES ****/
/* MAIADA */
Create Or Replace Procedure Viewtripsavail Is 
Cursor trips Is
Select * From Trip;
Curr_Trip Trips%Rowtype;
Airlinecompany Airline_Type;

BEGIN
Open Trips;
  Loop Fetch Trips Into Curr_Trip;
  Exit When Trips%Notfound;
  
  Select deref(offered_by) Into Airlinecompany
  From Trip 
  WHERE trip.trip_id = curr_trip.trip_id;
  
  Dbms_Output.Put_Line('Trip #'|| curr_trip.trip_id || ' offered by: ' || Airlinecompany.Airline_Name);
  Dbms_Output.Put_Line('Departures from: ' || Curr_Trip.Departure_Loc || ' ariport ' || Chr(9) || 'at: ' || Curr_Trip.Departure_Time);
  Dbms_Output.Put_Line('Arrives at: ' || Curr_Trip.Destination_Loc || ' airport ' || Chr(9) || 'at: ' || Curr_Trip.Arrival_Time);
  Dbms_Output.Put_Line('Ticket costs: ' || Curr_Trip.Trip_Fare || ' for: ' || Curr_Trip.Class_Type || ' class');
  Dbms_Output.New_Line;

  END LOOP;
Close Trips;
End;

/* MAHMOUD */

/* ABDELRAHMAN */
create or replace NONEDITIONABLE procedure Add_Hotel (hotel_id int, rating FLOAT, phone_num VARCHAR, hotel_name VARCHAR, city VARCHAR, country VARCHAR, managed_by number)is
begin
    if hotel_id > 0
        then if rating is not null 
            then if phone_num is not null
                then if hotel_name is not null
                    then if city is not null
                        then if country is not null
                            then if managed_by is not null
                                then 
                                    /*insert*/
                                    insert into hotel select (hotel_type(hotel_id, rating, phone_num, hotel_name, add_type(city, country), ref(hotelAgent)))
                                    from Hotel_Agent hotelAgent where hotelAgent.person_id = managed_by;
                                    /*end*/
                            else dbms_output.put_line('managed by must not be empty');
                            end if;
                        else dbms_output.put_line('country must not be empty');
                        end if;
                    else dbms_output.put_line('city must not be empty');
                    end if;
                else dbms_output.put_line('horel name must not be empty');
                end if;
            else dbms_output.put_line('phone_num must not be empty');
            end if;
        else dbms_output.put_line('rating must not be empty');
        end if;
    else dbms_output.put_line('Id must greater than zero');
    end if;
    exception 
    when DUP_VAL_ON_INDEX  then dbms_output.put_line('error');

end;
/* MOHAMED */

/* Add_Aircraft Procedure*/
create or replace procedure Add_Aircraft (craft_num int, model_name varchar, model_year int, manifacturer varchar, capacity int, belong_to varchar)is
begin

if craft_num > 0

then if capacity > 0

then

INSERT INTO aircraft select (aircraft_type(craft_num, model_name, model_year, manifacturer, capacity,ref(air)))
from airline air where air.airline_name = belong_to and air.phone_num = phone_num;

else
dbms_output.put_line('Craft number must be greater than 0');
end if;

else
dbms_output.put_line('Capacity must be greater than 0');
end if;

exception 
when dup_val_on_index
then dbms_output.put_line('The value of the primary key already exists in the database');
end;

/* Add_Airport Procedure*/

create or replace procedure Add_Airport (city varchar, country varchar, name varchar, code varchar)is
begin

if code > 0

then if country is not null

then

INSERT INTO airport values (add_type(city, country) , name, code);

else
dbms_output.put_line('Code number must be greater than 0');
end if;

else
dbms_output.put_line('Country field must not be empty');
end if;

exception 
when dup_val_on_index
then dbms_output.put_line('The value of the primary key already exists in the database');


end;

/**** FUNCTIONS ****/
/* MAIADA */
Create Or Replace Function Bookflightticket(Userr User_Type, Tripnum Int) Return Int Is
Tid Int;
Ctype Char; 
Deploc Varchar(5);
Desloc Varchar(5);
Deptime Varchar(8);
ArrTime Varchar(8);
fare FLOAT;
Airline Airline_Type;
Chosentrip Trip_Type;
user_exists NUMBER(1);
Latestseat Int;
Seat Int;
fully_booked EXCEPTION;

Begin
  /* check if trip exists first,  if not NO_DATA_FOUND will be raised */
  /*                              if yes get its details              */
  Select Trip_Id, 
          Class_Type, 
          Departure_Loc, 
          Destination_Loc, 
          Departure_Time, 
          Arrival_Time, 
          Trip_Fare, 
          Deref(Offered_By) 
          Into tID,Ctype, depLoc, desLoc, depTime, ArrTime, fare , airline
  From Trip
  Where Trip.Trip_Id = Tripnum;
  
  /* Retreive the last seat reserved in this trip */ 
  Select Max(B.Seat_Num)Into Latestseat
  From Tripbooking B, Trip T 
  Where T.Trip_Id = Tripnum;
  
  /* Assign him the next seat number, but make sure there is a seat available */
  /* a seat is avail if seat number didn't exceed the class_type's capacity*/ 
  If (Ctype = 'F' AND Latestseat < 12) /* capacity for the first class is 12 seats on any plane */
    Then 
      Seat := Latestseat + 1;
    Else 
      if (Ctype = 'B' AND Latestseat < 28) /* capacity of the business class is 28 seats on any plane */
        Then 
          Seat := Latestseat + 1;
        Else 
          if (Ctype = 'E' AND latestSeat < 100) /* capacity of economy class should be the remaining number of plane's capacity, but for now it'll be considered as, say 100 seats*/ 
          Then 
            Seat := Latestseat + 1;
          Else
            RAISE fully_booked;
          End If;
        END IF;
    End If;
    
    /* check if user already exists first, if not register him */
    Select Case When Exists (Select 1  
                              From User_Tbl 
                              Where User_Tbl.Person_Id = userr.person_id)
                Then 1
                Else 0
           End  Into User_Exists
    From Dual;
    
    If (user_exists <> 1)
      Then 
        Insert Into User_Tbl Values(Userr.Person_Id, Name_Type(Userr.Person_Name.Fname, Userr.Person_Name.Lname), Userr.Gender, Userr.Email, Userr.Phone_Num, Add_Type(Userr.Address.City, Userr.Address.Country), userr.credit_card_num);
    End If;
    
    /* Add this new booking to the database */
    Insert Into Tripbooking 
    Select User_Trip_Type(Seat, Ref(U), Ref(T))
    From Trip t, user_tbl u
    Where T.Trip_Id = Tripnum
    And U.Person_Id = Userr.Person_Id;
    
    Dbms_Output.Put_Line('Your chosen trip was booked successfully.');
    Dbms_Output.Put_Line('Ticket costs: $' || Fare || '.');
    Return Seat;
  
    Exception 
      When Fully_Booked
        Then 
          Dbms_Output.Put_Line('Sorry this trip is fully booked');
      When No_Data_Found 
        THEN 
          dbms_output.put_line('No such trip!'); 
      When Others 
        Then 
          dbms_output.put_line('Error in BookFlightTicket Function!'); 
End;

/* MAHMOUD */

/* ABDELRAHMAN */

create or replace function Room_Booking(userid number, hotelid int, enterdate varchar, leavedate varchar, days number, totalPrice float) return user_room_type
is
    cursor rooms is select * from room;
    curr_rec rooms%rowtype;
    hotel hotel_type;
    reservation roomReservation%rowtype;
begin
    open rooms;
        loop fetch rooms into curr_rec;
        exit when rooms%notfound;
        select deref(found_in) into hotel from room where room_id = curr_rec.room_id;
          if hotel.hotel_id = hotelid
            then if curr_rec.status = 'Available'
                then INSERT INTO roomReservation SELECT (user_room_type(ref(userid2),ref(room_ID), enterdate , leavedate, days , totalPrice))
                    from User_tbl userid2 , room room_ID where userid2.person_id = userid and room_ID.room_id = curr_rec.room_id;
                    update room set status = 'NotAvailable' where room_id = curr_rec.room_id;
                    
                    return reservation;
                end if;
          end if;
        end loop;
    close rooms;
    return 'this hotel not exits';
end;
/**** CALLIING BLOCK ****/

declare
sss varchar(1000);
begin
sss := Room_Booking(1,2002, '2/12/2023', '12/2/2024', 15, 5000);
dbms_output.put_line(sss);
end;

select * from roomReservation

select * from room


/* 1. MAIADA :: add_airline Procedure */
Declare 

Begin

END;

/* 2. FAHMY :: manage_airline function */
Declare 

Begin

END;

/* 3. FAHMY :: add_airport procedure */
Declare 

Begin

End;

/* 4. FAHMY:: add_aircraft procedure */
Declare 

Begin

End;

/* 5. MAIADA :: viewTripsAvail procedure*/
Begin 
  Viewtripsavail();
End;
/* Query for testing purposes */
Select t.trip_id, t.class_Type, t.departure_loc, t.destination_loc, t.departure_time, t.arrival_time, t.trip_fare, a.airline_name
From Trip T, Airline A 
Where A.Airline_Name = T.Offered_By.Airline_Name 
AND a.Phone_Num = t.offered_by.phone_num ;


/* 6. MAIADA :: Bookflightticket function*/
Declare 
Userr User_Type;
tripNum INT;
flightSeat Int;

Begin
  Userr:= user_type('12', Name_Type('Maiada', 'Khaled'), 'F', 'maiada@aol.com', '+201010101010', Add_Type('newCairo', 'Egypt'), '1111 1111');

  flightSeat:= Bookflightticket(Userr, &tripNum);
  Dbms_Output.Put_Line('Your flight seat number is: ' || Flightseat || '.');
End;
/* Query for testing purposes */
Select U.Person_Id, P.Trip_Id, B.Seat_Num 
From Tripbooking B, User_Tbl U, Trip P
WHERE u.person_id = b.user_ref.person_id AND p.trip_id = b.trip_ref.trip_id;

/* 7. HAGRASS :: Add_hotel procedure */
Declare 

Begin

End;

/* 8. HAGRASS :: Manage_hotel function */
Declare 

Begin

End;

/* 9. HAGRASS :: room_booking function */
Declare 

Begin

End;

/* 10. MAHMOUD :: Add_vehicle procedure */
Declare 

Begin

End;

/* 11. MAHMOUD :: vehicle_booking function */ 
Declare 

Begin

End;

/* 12. MAIADA:: Generate_reports function */
Declare 

Begin

End;



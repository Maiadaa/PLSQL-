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
    person_id NUMBER, 
    person_name name_type,
    gender CHAR,
    email VARCHAR(20),
    phone_num VARCHAR(13),
    address add_type
)NOT FINAL;

CREATE OR REPLACE TYPE vehicle_agent_type UNDER person_type (
    agency_id NUMBER
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
    hotel_id NUMBER, 
    rating FLOAT,
    phone_num VARCHAR(13),
    hotel_name VARCHAR(20),
    hotel_address add_type, 
    managed_by REF hotel_agent_type
);

CREATE OR REPLACE TYPE room_type IS OBJECT (
    room_id NUMBER, 
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
	airline agents 
   	airline 
   	trip
   	airport
   Hagrass: 
	aircraft 
   	landing 
   	tripBooking
   	hotel 
   Fahmy:
	room
   	roomReservation
  	vehicle 
   	vehicleRental 
/*
/*INSERT INTO user VALUES ('1', name_type('maiada', 'khaled'), 'F', 'maiada', '+201010', add_type('newCairo', 'Egypt'), '5555');*/

CREATE DOMAIN porcentage as int2
constraint ck_porcentage check (VALUE BETWEEN 0 and 100);

CREATE DOMAIN smallintPos as int
constraint ck_smallintPos check (VALUE BETWEEN 0 and 65535);

CREATE DOMAIN intPos as bigint
constraint ck_intPos check (VALUE BETWEEN 0 and 4294967294);

CREATE DOMAIN bigintPos as bigint
constraint ck_bigintPos check (VALUE BETWEEN 0 and 9223372036854775807);

CREATE DOMAIN Tprice as numeric(9, 2)
constraint ck_Tpunctuation check (VALUE BETWEEN 0.00 and 4294967295.99);

CREATE DOMAIN Tpuntuation as int2
constraint ck_Tpuntuation check (VALUE BETWEEN 0 and 5);

CREATE DOMAIN mail as varchar
constraint ck_mail check (VALUE ~* '([a-zA-Z]|_)[a-zA-Z0-9_.]+@[a-zA-Z]+[.][a-zA-Z]{2,4}([.][a-zA-Z]{2,4})*');

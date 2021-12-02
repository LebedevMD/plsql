--Пациент
create or replace type LEBEDEV_MA.t_patient as object(
    surname varchar2(100),
    name varchar2(100),
    patronymic varchar2(100),
    date_of_birth date,
    gender varchar2(25),
    phone_number varchar2(11),
    area varchar2(10),
    id_account number
);
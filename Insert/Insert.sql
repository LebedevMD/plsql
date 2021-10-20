declare
    v_id number;
begin
--regions
insert into LEBEDEV_MA.REGIONS (NAME) values ('Кемеровская область');
insert into LEBEDEV_MA.REGIONS (NAME) values ('Республика Татарстан');
insert into LEBEDEV_MA.REGIONS (NAME) values ('Ленинградская область');

--cities
select r.ID_Region into v_id from LEBEDEV_MA.REGIONS r where r.NAME = 'Кемеровская область';
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Кемерово');
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Белово');
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Новокузнецк');

select r.ID_Region into v_id from LEBEDEV_MA.REGIONS r where r.NAME = 'Ленинградская область';
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Санкт-Петербург');
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Выборг');
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Петергоф');

select r.ID_Region into v_id from LEBEDEV_MA.REGIONS r where r.NAME = 'Республика Татарстан';
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Казань');
insert into LEBEDEV_MA.CITIES (ID_REGION, NAME) values (v_id, 'Менделеевск');

--med_organisations
select c.ID_CITY into v_id from LEBEDEV_MA.CITIES c where c.NAME = 'Кемерово';
insert into LEBEDEV_MA.MED_ORGANISATIONS (ID_CITY, NAME) VALUES (v_id, 'Кемеровская областная клиническая больница');
insert into LEBEDEV_MA.MED_ORGANISATIONS (ID_CITY, NAME) VALUES (v_id, 'Кузбасская Клиническая Больница Скорой Медицинской Помощи им. М.А. Подгорбунского');
select c.ID_CITY into v_id from LEBEDEV_MA.CITIES c where c.NAME = 'Санкт-Петербург';
insert into LEBEDEV_MA.MED_ORGANISATIONS (ID_CITY, NAME) VALUES (v_id, 'Клиническая инфекционная больница им. С.П. Боткина');

--type
insert into LEBEDEV_MA.TYPE (NAME) values ('Государственная');
insert into LEBEDEV_MA.TYPE (NAME) values ('Частная');

--hospitals
select mo.ID_MED_ORGANISATION into v_id from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.NAME = 'Кемеровская областная клиническая больница';
insert into LEBEDEV_MA.HOSPITALS (ID_MEDORGAN, ISAVAILABLE, ID_TYPE) VALUES (v_id, 0, (select ID_TYPE from LEBEDEV_MA.TYPE where NAME = 'Государственная'));

--genders
insert into LEBEDEV_MA.GENDER (NAME) values ('Мужской');
insert into LEBEDEV_MA.GENDER (NAME) values ('Женский');
insert into LEBEDEV_MA.GENDER (NAME) values ('Интерсекс');

--qualifications
insert into LEBEDEV_MA.QUALIFICATION (QUALIFICATION) values ('Высшая');
insert into LEBEDEV_MA.QUALIFICATION (QUALIFICATION) values ('Первая');
insert into LEBEDEV_MA.QUALIFICATION (QUALIFICATION) values ('Вторая');

--age_required
insert into LEBEDEV_MA.REQUIRED_AGE (START_INTERVAL) VALUES (18);

--speciality
select ra.ID_REQUIRED_AGE into v_id from LEBEDEV_MA.REQUIRED_AGE ra where ra.START_INTERVAL = 18;
insert into LEBEDEV_MA.SPECIALITY (NAME, ID_AGE_REQUIRED) values ('Хирург', v_id);
insert into LEBEDEV_MA.SPECIALITY (NAME, ID_AGE_REQUIRED) values ('Терапевт', v_id);

--doctors
select h.ID_HOSPITAL into v_id from LEBEDEV_MA.HOSPITALS h where h.ID_MEDORGAN =
   (select mo.ID_MED_ORGANISATION from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.NAME = 'Кемеровская областная клиническая больница');
insert into LEBEDEV_MA.DOCTORS (ID_HOSPITAL, SURNAME, NAME, PATRONYMIC, ID_GENDER, ID_SPECIALITY, ID_QUALIFICATION, SALARY, RATING, AREA) values
(v_id, 'Иванов', 'Иван', 'Иванович', (select g.ID_GENDER from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'),
 (select s.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY s where s.NAME = 'Хирург'), (select q.ID_QUALIFICATION from LEBEDEV_MA.QUALIFICATION q where q.QUALIFICATION = 'Высшая'),
 40000, 4, '2');
insert into LEBEDEV_MA.DOCTORS (ID_HOSPITAL, SURNAME, NAME, PATRONYMIC, ID_GENDER, ID_SPECIALITY, ID_QUALIFICATION, SALARY, RATING, AREA) values
(v_id, 'Петров', 'Пётр', 'Петрович', (select g.ID_GENDER from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'),
 (select s.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY s where s.NAME = 'Хирург'), (select q.ID_QUALIFICATION from LEBEDEV_MA.QUALIFICATION q where q.QUALIFICATION = 'Вторая'),
 30000, 4, '2');

--talons
select d.ID_DOCTOR into v_id from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Иванов';
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('21.10.2021 15:00', 'dd.mm.yyyy hh24:mi'), to_date('21.10.2021 15:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('21.10.2021 15:30', 'dd.mm.yyyy hh24:mi'), to_date('21.10.2021 16:00', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('12.10.2021 15:00', 'dd.mm.yyyy hh24:mi'), to_date('12.10.2021 15:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('13.10.2021 16:00', 'dd.mm.yyyy hh24:mi'), to_date('13.10.2021 16:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('14.10.2021 16:00', 'dd.mm.yyyy hh24:mi'), to_date('14.10.2021 16:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('20.10.2021 12:00', 'dd.mm.yyyy hh24:mi'), to_date('20.10.2021 12:30', 'dd.mm.yyyy hh24:mi'));

--schedule
select h.ID_HOSPITAL into v_id from LEBEDEV_MA.HOSPITALS h where h.ID_MEDORGAN =
    (select mo.ID_MED_ORGANISATION from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.NAME = 'Кемеровская областная клиническая больница');
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Понедельник', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Вторник', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Среда', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Четверг', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Пятница', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));

--hospital_speciality
insert into LEBEDEV_MA.HOSPITAL_SPECIALITY (ID_SPECIALITY, ID_HOSPITAL) VALUES
((select sp.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY sp where sp.NAME = 'Хирург'), 1);
end;
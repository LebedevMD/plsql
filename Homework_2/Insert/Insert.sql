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
update LEBEDEV_MA.HOSPITALS h set h.ADDRESS = 'Октябрьский проспект, 22' where ROWNUM = 1;

--genders
insert into LEBEDEV_MA.GENDER (NAME) values ('Мужской');
insert into LEBEDEV_MA.GENDER (NAME) values ('Женский');
insert into LEBEDEV_MA.GENDER (NAME) values ('Интерсекс');

--qualifications
insert into LEBEDEV_MA.QUALIFICATION (QUALIFICATION) values ('Высшая');
insert into LEBEDEV_MA.QUALIFICATION (QUALIFICATION) values ('Первая');
insert into LEBEDEV_MA.QUALIFICATION (QUALIFICATION) values ('Вторая');

--age_required
insert into LEBEDEV_MA.REQUIRED_AGE (START_INTERVAL, END_INTERVAL) VALUES (18, 100);

--speciality
select ra.ID_REQUIRED_AGE into v_id from LEBEDEV_MA.REQUIRED_AGE ra where ra.START_INTERVAL = 18;
insert into LEBEDEV_MA.SPECIALITY (NAME, ID_AGE_REQUIRED) values ('Хирург', v_id);
insert into LEBEDEV_MA.SPECIALITY (NAME, ID_AGE_REQUIRED) values ('Терапевт', v_id);

--doctors
select h.ID_HOSPITAL into v_id from LEBEDEV_MA.HOSPITALS h where h.ID_MEDORGAN =
   (select mo.ID_MED_ORGANISATION from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.NAME = 'Кемеровская областная клиническая больница');
insert into LEBEDEV_MA.DOCTORS (ID_HOSPITAL, SURNAME, NAME, PATRONYMIC, ID_GENDER, ID_SPECIALITY, ID_QUALIFICATION, SALARY, AREA) VALUES
(v_id, 'Лебедев', 'Максим', 'Дмитриевич', (select g.ID_GENDER from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'),
 (select s.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY s where s.NAME = 'Терапевт'), (select q.ID_QUALIFICATION from LEBEDEV_MA.QUALIFICATION q where q.QUALIFICATION = 'Высшая'),
 50000, '3');
insert into LEBEDEV_MA.DOCTORS (ID_HOSPITAL, SURNAME, NAME, PATRONYMIC, ID_GENDER, ID_SPECIALITY, ID_QUALIFICATION, SALARY, AREA) values
(v_id, 'Иванов', 'Иван', 'Иванович', (select g.ID_GENDER from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'),
 (select s.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY s where s.NAME = 'Хирург'), (select q.ID_QUALIFICATION from LEBEDEV_MA.QUALIFICATION q where q.QUALIFICATION = 'Высшая'),
 40000, '2');
insert into LEBEDEV_MA.DOCTORS (ID_HOSPITAL, SURNAME, NAME, PATRONYMIC, ID_GENDER, ID_SPECIALITY, ID_QUALIFICATION, SALARY, AREA) values
(v_id, 'Петров', 'Пётр', 'Петрович', (select g.ID_GENDER from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'),
 (select s.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY s where s.NAME = 'Хирург'), (select q.ID_QUALIFICATION from LEBEDEV_MA.QUALIFICATION q where q.QUALIFICATION = 'Вторая'),
 30000, '2');

--talons
select d.ID_DOCTOR into v_id from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Иванов';
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('21.10.2021 15:00', 'dd.mm.yyyy hh24:mi'), to_date('21.10.2021 15:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('21.10.2021 15:30', 'dd.mm.yyyy hh24:mi'), to_date('21.10.2021 16:00', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('12.10.2021 15:00', 'dd.mm.yyyy hh24:mi'), to_date('12.10.2021 15:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('13.10.2021 16:00', 'dd.mm.yyyy hh24:mi'), to_date('13.10.2021 16:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('14.10.2021 16:00', 'dd.mm.yyyy hh24:mi'), to_date('14.10.2021 16:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('20.10.2021 12:00', 'dd.mm.yyyy hh24:mi'), to_date('20.10.2021 12:30', 'dd.mm.yyyy hh24:mi'));
select d.ID_DOCTOR into v_id from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Лебедев';
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('01.11.2021 12:00', 'dd.mm.yyyy hh24:mi'), to_date('01.11.2021 12:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('01.11.2021 12:30', 'dd.mm.yyyy hh24:mi'), to_date('01.11.2021 13:00', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('02.11.2021 12:00', 'dd.mm.yyyy hh24:mi'), to_date('02.11.2021 12:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('02.11.2021 12:30', 'dd.mm.yyyy hh24:mi'), to_date('02.11.2021 13:00', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('26.10.2021 12:00', 'dd.mm.yyyy hh24:mi'), to_date('26.10.2021 12:30', 'dd.mm.yyyy hh24:mi'));
insert into LEBEDEV_MA.TALON (ID_DOCTOR, ISOPEN, STARTDATE, ENDDATE) VALUES (v_id, 1, to_date('25.10.2021 12:00', 'dd.mm.yyyy hh24:mi'), to_date('25.10.2021 12:30', 'dd.mm.yyyy hh24:mi'));

--schedule
select h.ID_HOSPITAL into v_id from LEBEDEV_MA.HOSPITALS h where h.ID_MEDORGAN =
    (select mo.ID_MED_ORGANISATION from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.NAME = 'Кемеровская областная клиническая больница') and ROWNUM = 1;
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Понедельник', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Вторник', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Среда', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Четверг', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));
insert into LEBEDEV_MA.SCHEDULE (ID_HOSPITAL, DAYOFWEEK, START_WORK, END_WORK) VALUES (v_id, 'Пятница', to_date('09:00', 'hh24:mi'), to_date('20:00', 'hh24:mi'));

--hospital_speciality
insert into LEBEDEV_MA.HOSPITAL_SPECIALITY (ID_SPECIALITY, ID_HOSPITAL) VALUES
((select sp.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY sp where sp.NAME = 'Хирург'), 1);
insert into LEBEDEV_MA.HOSPITAL_SPECIALITY(ID_SPECIALITY, ID_HOSPITAL) VALUES
((select sp.ID_SPECIALITY from LEBEDEV_MA.SPECIALITY sp where sp.NAME = 'Терапевт'), 1);

--account
insert into LEBEDEV_MA.ACCOUNT (LOGIN, PASSWORD) values ('KonstTepl', '2378@moq');
insert into LEBEDEV_MA.ACCOUNT (LOGIN, PASSWORD) values ('Kirill', 'Shianov_03');
insert into LEBEDEV_MA.ACCOUNT (LOGIN, PASSWORD) values ('LMoagxvenk', 'S3rg@Max');
insert into LEBEDEV_MA.ACCOUNT (LOGIN, PASSWORD) values ('AlyPONN', 'Pon_ALL0508');
insert into LEBEDEV_MA.ACCOUNT (LOGIN, PASSWORD) values ('MASHAostatnina', '15072001_mash');

--patients
insert into LEBEDEV_MA.PATIENTS p (NAME, SURNAME, PATRONYMIC, DATEOFBIRTH, ID_GENDER, PHONENUMBER, AREA, ID_ACCOUNT) values ('Константин', 'Теплов', 'Евгеньевич', to_date('27.11.2001'),
    (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'), '89996786549', '2', (select acc.ID_Account from LEBEDEV_MA.ACCOUNT acc where acc.LOGIN = 'KonstTepl'));
insert into LEBEDEV_MA.PATIENTS p (NAME, SURNAME, PATRONYMIC, DATEOFBIRTH, ID_GENDER, PHONENUMBER, AREA, ID_ACCOUNT) values ('Кирилл', 'Шиянов', 'Алексеевич', to_date('20.01.2003'),
    (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'), '88005553535', '2', (select acc.ID_Account from LEBEDEV_MA.ACCOUNT acc where acc.LOGIN = 'Kirill'));
insert into LEBEDEV_MA.PATIENTS p (SURNAME, NAME, PATRONYMIC, DATEOFBIRTH, ID_GENDER, PHONENUMBER, AREA, ID_ACCOUNT) values ('Логвенков', 'Максим', 'Сергеевич', to_date('20.10.2000'),
    (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'), '89785784967', '3', (select acc.ID_Account from LEBEDEV_MA.ACCOUNT acc where acc.LOGIN = 'LMoagxvenk'));
insert into LEBEDEV_MA.PATIENTS p (SURNAME, NAME, PATRONYMIC, DATEOFBIRTH, ID_GENDER, PHONENUMBER, AREA, ID_ACCOUNT) values ('Пономарёва', 'Алёна', 'Алексеевна', to_date('08.05.2001'),
    (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Женский'), '89234876490', '3', (select acc.ID_Account from LEBEDEV_MA.ACCOUNT acc where acc.LOGIN = 'AlyPONN'));
insert into LEBEDEV_MA.PATIENTS p (SURNAME, NAME, PATRONYMIC, DATEOFBIRTH, ID_GENDER, PHONENUMBER, AREA, ID_ACCOUNT) values ('Останина', 'Мария', 'Константиновна', to_date('15.07.2002'),
    (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Женский'), '89834769731', '3', (select acc.ID_Account from LEBEDEV_MA.ACCOUNT acc where acc.LOGIN = 'MASHAostatnina'));

--documents
insert into LEBEDEV_MA.DOCUMENT (NAME) values ('Паспорт');
insert into LEBEDEV_MA.DOCUMENT (NAME) values ('СНИЛС');
insert into LEBEDEV_MA.DOCUMENT (NAME) values ('ОМС');

--doc_numbers
select doc.ID_DOCUMENT into v_id from LEBEDEV_MA.DOCUMENT doc where doc.NAME = 'Паспорт';
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Теплов'),
    v_id, '3221578259');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Шиянов'),
    v_id, '3217726064');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Логвенков'),
    v_id, '3220129876');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Пономарёва'),
    v_id, '3221678865');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Останина'),
    v_id, '3218456987');
select doc.ID_DOCUMENT into v_id from LEBEDEV_MA.DOCUMENT doc where doc.NAME = 'СНИЛС';
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Теплов'),
    v_id, '10987637610');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Шиянов'),
    v_id, '98746109476');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Логвенков'),
    v_id, '18609357123');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Пономарёва'),
    v_id, '98567296710');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Останина'),
    v_id, '15957396728');
select doc.ID_DOCUMENT into v_id from LEBEDEV_MA.DOCUMENT doc where doc.NAME = 'ОМС';
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Теплов'),
    v_id, '2859276913457186');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Шиянов'),
    v_id, '1986750285734576');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Логвенков'),
    v_id, '6739671957638652');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Пономарёва'),
    v_id, '2967386456728549');
insert into LEBEDEV_MA.DOCUMENTS_NUMBERS docNum (ID_PATIENT, ID_DOCUMENT, VALUE) values ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Останина'),
    v_id, '2067386899847688');

--status
insert into LEBEDEV_MA.STATUS (STATUS_NAME) values ('Подтверждено');
insert into LEBEDEV_MA.STATUS (STATUS_NAME) values ('Отменено');

--journal
select st.ID_Status into v_id from LEBEDEV_MA.STATUS st where st.STATUS_NAME = 'Подтверждено';
insert into LEBEDEV_MA.JOURNAL (ID_PATIENT, ID_TALON, ID_STATUS) VALUES
    ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Логвенков'), 6, v_id);
insert into LEBEDEV_MA.JOURNAL (ID_PATIENT, ID_TALON, ID_STATUS) VALUES
    ((select p.ID_Patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Логвенков'), 8, v_id);

--required_gender
select sp.ID_SPECIALITY into v_id from LEBEDEV_MA.SPECIALITY sp where sp.NAME = 'Хирург';
insert into LEBEDEV_MA.REQUIRED_GENDER (ID_SPECIALITY, ID_GENDER) VALUES
    (v_id, (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Мужской'));
select sp.ID_SPECIALITY into v_id from LEBEDEV_MA.SPECIALITY sp where sp.NAME = 'Терапевт';
insert into LEBEDEV_MA.REQUIRED_GENDER (ID_SPECIALITY, ID_GENDER) VALUES
    (v_id, (select g.ID_Gender from LEBEDEV_MA.GENDER g where g.NAME = 'Женский'));
end;
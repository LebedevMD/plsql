--**Создать метод записи с проверками пациента
-- на соответствие всем пунктам для записи

--Функция
--Пациент ещё не записан на этот талон
create or replace function LEBEDEV_MA.check_appointment(
    p_id_patient number,
    p_id_talon number
)
return boolean
as
    v_count int;
begin
    select count(*)
    into v_count
    from LEBEDEV_MA.JOURNAL jr
    where jr.ID_PATIENT = p_id_patient
      and jr.ID_TALON = p_id_talon
      and jr.ID_STATUS = LEBEDEV_MA.PKG_JOURNAL.C_JOURNAL_CONFIRMED;
    if (v_count != 0) then
        return true;
    else
        return false;
    end if;
end;

--Совпадение пола пациента с полом специальности
create or replace function LEBEDEV_MA.check_gender_compatibility(
    p_id_patient number,
    p_id_talon number
)
return boolean
as
    v_count int;
begin
    select count(*)
        into v_count
        from
            LEBEDEV_MA.PATIENTS p
            join LEBEDEV_MA.GENDER gend on p.ID_GENDER = gend.ID_GENDER
            join LEBEDEV_MA.REQUIRED_GENDER reqGen on gend.ID_GENDER = reqGen.ID_GENDER
            join LEBEDEV_MA.SPECIALITY spec on reqGen.ID_SPECIALITY = spec.ID_SPECIALITY
            join LEBEDEV_MA.DOCTORS doc on spec.ID_SPECIALITY = doc.ID_SPECIALITY
            join LEBEDEV_MA.TALON tal on doc.ID_DOCTOR = tal.ID_DOCTOR
        where
              tal.ID_TALON = p_id_talon and p.ID_PATIENT = p_id_patient and
              (p.ID_GENDER = reqGen.ID_GENDER);
    if (v_count != 0) then
        return true;
    else
        return false;
    end if;
end;

--Попадание по возрасту пациента в возрастной диапазон специальности
create or replace function LEBEDEV_MA.check_age_compatibility(
    p_id_patient number,
    p_id_talon number
)
return boolean
as
    v_count int;
begin
    select count(*)
    into v_count
    from
         LEBEDEV_MA.PATIENTS p
         join LEBEDEV_MA.GENDER gend on p.ID_GENDER = gend.ID_GENDER
         join LEBEDEV_MA.REQUIRED_GENDER reqGen on gend.ID_GENDER = reqGen.ID_GENDER
         join LEBEDEV_MA.SPECIALITY spec on reqGen.ID_SPECIALITY = spec.ID_SPECIALITY
         join LEBEDEV_MA.REQUIRED_AGE reqAge on spec.ID_AGE_REQUIRED = reqAge.ID_REQUIRED_AGE
         join LEBEDEV_MA.DOCTORS doc on spec.ID_SPECIALITY = doc.ID_SPECIALITY
         join LEBEDEV_MA.TALON tal on doc.ID_DOCTOR = tal.ID_DOCTOR
    where
          tal.ID_TALON = p_id_talon and p.ID_PATIENT = p_id_patient and
          (sysdate - p.DATEOFBIRTH) > reqAge.START_INTERVAL and
          (sysdate - p.DATEOFBIRTH) < reqAge.END_INTERVAL;
    if (v_count != 0) then
        return true;
    else
        return false;
    end if;
end;

--Талон на который записываются должен быть открыт
create or replace function LEBEDEV_MA.check_talon_is_opened(
    p_id_talon number
)
return boolean
as
    v_count int;
begin
    select count(*)
    into v_count
    from LEBEDEV_MA.TALON tal
    where tal.ID_TALON = p_id_talon and tal.ISOPEN = 0;
    if (v_count != 0) then
        return true;
    else
        return false;
    end if;
end;

--Время начала талона на который записываются не должен быть больше текущего времени
create or replace function LEBEDEV_MA.check_talon_time(
    p_id_talon number
)
return boolean
as
    v_count int;
begin
    select count(*)
    into v_count
    from LEBEDEV_MA.TALON tal
    where
          tal.ID_TALON = p_id_talon and
          tal.STARTDATE <= sysdate;
    if (v_count != 0) then
        return true;
    else
        return false;
    end if;
end;

--Получение id доктора
create or replace function LEBEDEV_MA.get_doctor_id(
    p_id_talon number
)
return boolean
as
    v_id int default -1;
begin
    select doc.ID_DOCTOR
    into v_id
    from
         LEBEDEV_MA.TALON tal
         join LEBEDEV_MA.DOCTORS doc on tal.ID_DOCTOR = doc.ID_DOCTOR
    where
          tal.ID_TALON = p_id_talon and
          doc.DELETED is null;
    if (v_id = -1) then
        return true;
    else
        return false;
    end if;
end;

--Наличие у пациента ОМС
create or replace function LEBEDEV_MA.check_OMS(
    p_id_patient number
)
return boolean
as
    v_count int;
begin
    select count(*)
    into v_count
    from
         LEBEDEV_MA.PATIENTS pat
         join LEBEDEV_MA.DOCUMENTS_NUMBERS docNum on pat.ID_PATIENT = docNum.ID_PATIENT
         join LEBEDEV_MA.DOCUMENT doc on docNum.ID_DOCUMENT = doc.ID_DOCUMENT
    where
          pat.ID_PATIENT = p_id_patient and
          doc.NAME = 'ОМС';
    if (v_count = 0) then
        return true;
    else
        return false;
    end if;
end;

--Проверка условий
create or replace procedure LEBEDEV_MA.sign_up_for_a_talon(
    p_id_talon number,
    p_id_patient number
)
as
    v_signUp_status number;
    v_error_status number := LEBEDEV_MA.PKG_CODES.C_OK;
begin
    --Пациент ещё не записан на этот талон
    if (LEBEDEV_MA.check_appointment(p_id_patient => p_id_patient, p_id_talon => p_id_talon)) then
        v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
        v_signUp_status := LEBEDEV_MA.PKG_CODES.C_ALREADY_RECORDED;
    end if;

    --Талон на который записываются должен быть открыт
     if (v_error_status != LEBEDEV_MA.PKG_CODES.C_ERROR and
        LEBEDEV_MA.check_talon_is_opened(p_id_talon => p_id_talon)) then
            v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
            v_signUp_status := LEBEDEV_MA.PKG_CODES.C_TALON_CLOSED;
    end if;

    --Совпадение пола пациента с полом специальности
    if (v_error_status != LEBEDEV_MA.PKG_CODES.C_ERROR and
        LEBEDEV_MA.check_gender_compatibility(p_id_patient => p_id_patient, p_id_talon => p_id_talon)) then
            v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
            v_signUp_status := LEBEDEV_MA.PKG_CODES.C_GENDER_INCOMPATIBILITY;
    end if;

    --Попадание по возрасту пациента в возрастной диапазон специальности
     if (v_error_status != LEBEDEV_MA.PKG_CODES.C_ERROR and
        LEBEDEV_MA.check_age_compatibility(p_id_patient => p_id_patient, p_id_talon => p_id_talon)) then
            v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
            v_signUp_status := LEBEDEV_MA.PKG_CODES.C_AGE_INCOMPATIBILITY;
    end if;

    --Время начала талона на который записываются не должен быть больше текущего времени
     if (v_error_status != LEBEDEV_MA.PKG_CODES.C_ERROR and
        LEBEDEV_MA.check_talon_time(p_id_talon => p_id_talon)) then
            v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
            v_signUp_status := LEBEDEV_MA.PKG_CODES.C_TIME_STARTED;
    end if;

    --Получение id доктора
     if (v_error_status != LEBEDEV_MA.PKG_CODES.C_ERROR and
        LEBEDEV_MA.get_doctor_id(p_id_talon => p_id_talon)) then
            v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
            v_signUp_status := LEBEDEV_MA.PKG_CODES.C_DOC_UNAVAILABLE;
    end if;

    --Наличие у пациента ОМС
     if (v_error_status != LEBEDEV_MA.PKG_CODES.C_ERROR and
        LEBEDEV_MA.check_OMS(p_id_patient => p_id_patient)) then
        v_error_status := LEBEDEV_MA.PKG_CODES.C_ERROR;
        v_signUp_status := LEBEDEV_MA.PKG_CODES.C_NO_OMS;
    end if;

    --Запись если ошибок нет
    if (v_error_status = LEBEDEV_MA.PKG_CODES.C_OK) then
        LEBEDEV_MA.PKG_TALON.REGISTRATION_FOR_THE_TALON(p_id_patient => p_id_patient, p_id_talon => p_id_talon);
            v_signUp_status := LEBEDEV_MA.PKG_CODES.C_SUCCESSFUL_REGISTRATION;
    end if;

    DBMS_OUTPUT.PUT_LINE(LEBEDEV_MA.PKG_CODES.GET_MESSAGE(p_code => v_signUp_status));
end;

--Основная часть
declare
    v_id_talon number;
    v_id_patient number;
begin
    select p.ID_Patient into v_id_patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Теплов';
    v_id_talon := 22;
    LEBEDEV_MA.sign_up_for_a_talon(p_id_talon => v_id_talon, p_id_patient => v_id_patient);
end;
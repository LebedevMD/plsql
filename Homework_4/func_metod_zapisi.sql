--**Создать метод записи с проверками пациента
-- на соответствие всем пунктам для записи

--Функция
create or replace function LEBEDEV_MA.sign_up_for_a_talon(
    p_id_talon number,
    p_id_patient number
)
return varchar2
as
    v_signUp_status varchar2(200);
    v_count number;
begin
    --Пациент ещё не записан на этот талон
    select count(*) into v_count from LEBEDEV_MA.JOURNAL jr where jr.ID_PATIENT = p_id_patient and jr.ID_TALON = p_id_talon;
    if (v_count != 0) then
        v_signUp_status := 'Пациент уже записан на этот талон';
    else
        --Совпадение пола пациента с полом специальности
        select
               count(*)
        into
            v_count
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
            v_signUp_status := 'Пол пациента не совпадает с полом специальности';
        else
            --Попадание по возрасту пациента в возрастной диапазон специальности
            select
                   count(*)
            into
                v_count
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
                v_signUp_status := 'Возраст пациента не попадает в возрастной диапазон специальности';
            else
                --Талон на который записываются должен быть открыт
                select
                       count(*)
                into
                    v_count
                from
                     LEBEDEV_MA.TALON tal
                where
                      tal.ID_TALON = p_id_talon and tal.ISOPEN = '0';
                if (v_count != 0) then
                    v_signUp_status := 'Талон закрыт для записи';
                else
                    --Время начала талона на который записываются не должен быть больше текущего времени
                    select
                           count(*)
                    into
                        v_count
                    from
                         LEBEDEV_MA.TALON tal
                    where
                          tal.ID_TALON = p_id_talon and
                          tal.STARTDATE <= sysdate;
                    if (v_count != 0) then
                        v_signUp_status := 'Время талона уже начато, запись на него невозможна';
                    else
                        --Доктор к которому записываются на прием не должен быть "удаленным"
                        select
                               count(*)
                        into
                            v_count
                        from
                             LEBEDEV_MA.TALON tal
                             join LEBEDEV_MA.DOCTORS doc on tal.ID_DOCTOR = doc.ID_DOCTOR
                        where
                              tal.ID_TALON = p_id_talon and
                              doc.DELETED is not null;
                        if (v_count != 0) then
                            v_signUp_status := 'Запись к данному доктору невозможна';
                        else
                            --специальность этого доктора не должна быть "удаленная"
                            select
                                   count(*)
                            into
                                v_count
                            from
                                 LEBEDEV_MA.TALON tal
                                 join LEBEDEV_MA.DOCTORS doc on tal.ID_DOCTOR = doc.ID_DOCTOR
                                 join LEBEDEV_MA.SPECIALITY spec on doc.ID_SPECIALITY = spec.ID_SPECIALITY
                            where
                                  tal.ID_TALON = p_id_talon and
                                  spec.DELETED is not null;
                            if (v_count != 0) then
                                v_signUp_status := 'Запись на данную специальность невозможна';
                            else
                                --Больница этого доктора не должна быть "удаленная"
                                select
                                   count(*)
                                into
                                    v_count
                                from
                                     LEBEDEV_MA.TALON tal
                                     join LEBEDEV_MA.DOCTORS doc on tal.ID_DOCTOR = doc.ID_DOCTOR
                                     join LEBEDEV_MA.HOSPITALS hosp on doc.ID_HOSPITAL = hosp.ID_HOSPITAL
                                where
                                      tal.ID_TALON = p_id_talon and
                                      hosp.DELETED is not null;
                                if (v_count != 0) then
                                    v_signUp_status := 'Запись в данную больницу невозможна';
                                else
                                    --Наличие у пациента ОМС
                                    select
                                           count(*)
                                    into
                                        v_count
                                    from
                                         LEBEDEV_MA.PATIENTS pat
                                         join LEBEDEV_MA.DOCUMENTS_NUMBERS docNum on pat.ID_PATIENT = docNum.ID_PATIENT
                                         join LEBEDEV_MA.DOCUMENT doc on docNum.ID_DOCUMENT = doc.ID_DOCUMENT
                                    where
                                          pat.ID_PATIENT = p_id_patient and
                                          doc.NAME = 'ОМС';
                                    if (v_count = 0) then
                                        v_signUp_status := 'Нет полиса ОМС';
                                    else
                                        update LEBEDEV_MA.TALON tal set tal.ISOPEN = 0 where tal.ID_TALON = p_id_talon;
                                        insert into LEBEDEV_MA.JOURNAL jor (ID_PATIENT, ID_TALON, ID_STATUS) values
                                            (p_id_patient, p_id_talon, (select st.ID_Status from LEBEDEV_MA.STATUS st where st.STATUS_NAME = 'Подтверждено'));
                                        v_signUp_status := 'Запись произведена успешно';
                                    end if;
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end if;
    return v_signUp_status;
end;

--Основная часть
declare
    v_id_talon number;
    v_id_patient number;
    v_signUp_status varchar2(200);
begin
    DBMS_OUTPUT.ENABLE();
    select p.ID_Patient into v_id_patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Логвенков';
    v_id_talon := 13;
    v_signUp_status := LEBEDEV_MA.sign_up_for_a_talon(p_id_talon => v_id_talon, p_id_patient => v_id_patient);
    DBMS_OUTPUT.PUT_LINE(v_signUp_status);
end;
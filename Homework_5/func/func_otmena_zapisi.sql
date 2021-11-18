--Функция отмены записи

--Отменять запись можно только если прием еще не начинался
create or replace function LEBEDEV_MA.check_appointment_not_started(
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

--Талон можно отменять только если эта клиника работает сегодня еще минимум два часа
create or replace function LEBEDEV_MA.check_work_time_not_out(
    p_id_talon number
)
return boolean
as
    v_count int;
    v_day_of_week varchar2(50);
begin
    v_day_of_week := to_char(sysdate, 'day');
    select count(*)
    into v_count
    from
         LEBEDEV_MA.TALON tal
         join LEBEDEV_MA.DOCTORS doc on tal.ID_DOCTOR = doc.ID_DOCTOR
         join LEBEDEV_MA.HOSPITALS hosp on doc.ID_HOSPITAL = hosp.ID_HOSPITAL
         join LEBEDEV_MA.SCHEDULE sch on hosp.ID_HOSPITAL = sch.ID_HOSPITAL
    where
          tal.ID_TALON = p_id_talon and
          sch.DAYOFWEEK = v_day_of_week and
          (sch.END_WORK - sysdate) * 24 >= 2;
    if (v_count = 0) then
        return true;
    else
        return false;
    end if;
end;

--Процедура проверки условий
create or replace procedure LEBEDEV_MA.cancel_sign_up_for_a_talon(
    p_id_talon number
)
as
    v_cancel_status varchar2(200);
    v_error_status boolean := false;
begin
    --Отменять запись можно только если прием еще не начинался
    if (LEBEDEV_MA.check_appointment_not_started(p_id_talon => p_id_talon)) then
        v_error_status := true;
        v_cancel_status := v_cancel_status || chr(10)
            || 'Отмена записи невозможна, так как приём уже начался';
    end if;

    --Талон можно отменять только если эта клиника работает сегодня еще минимум два часа
    if (LEBEDEV_MA.check_work_time_not_out(p_id_talon => p_id_talon)) then
        v_error_status := true;
        v_cancel_status := v_cancel_status || chr(10)
          || 'Отмена записи невозможна, повторите попытку завтра';
    end if;

    --Отмена если все условие пройдены
    if (not v_error_status) then
        LEBEDEV_MA.PKG_TALON.cancel_sign_up(p_id_talon => p_id_talon);
        v_cancel_status := 'Запись отменена';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_cancel_status);
end;

--Основная часть
declare
    v_id_talon number;
begin
    DBMS_OUTPUT.ENABLE();
    v_id_talon := 20;
    LEBEDEV_MA.cancel_sign_up_for_a_talon(p_id_talon => v_id_talon);
end;
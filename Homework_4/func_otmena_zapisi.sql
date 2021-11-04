--Функция отмены записи

--Функция
create or replace function LEBEDEV_MA.cancel_sign_up_for_a_talon(
    p_id_talon number
)
return varchar2
as
    v_cancel_status varchar2(200);
    v_count number;
    v_day_of_week varchar2(50);
begin
    --Отменять запись можно только если прием еще не начинался
    select
           count(*)
    into
        v_count
    from
         LEBEDEV_MA.TALON tal
    where
          tal.ID_TALON = p_id_talon and
          tal.STARTDATE <= sysdate;
    if (v_count !=0) then
        v_cancel_status := 'Отмена записи невозможна, так как приём уже начался';
    else
        --Талон можно отменять только если эта клиника работает сегодня еще минимум два часа
        v_day_of_week := to_char(sysdate, 'day');
        select
               count(*)
        into
            v_count
        from
             LEBEDEV_MA.TALON tal
             join LEBEDEV_MA.DOCTORS doc on tal.ID_DOCTOR = doc.ID_DOCTOR
             join LEBEDEV_MA.HOSPITALS hosp on doc.ID_HOSPITAL = hosp.ID_HOSPITAL
             join LEBEDEV_MA.SCHEDULE sch on hosp.ID_HOSPITAL = sch.ID_HOSPITAL
        where
              tal.ID_TALON = p_id_talon and
              sch.DAYOFWEEK = v_day_of_week and
              (to_char(sch.END_WORK, 'hh24') - to_char(sysdate, 'hh24') >= 2);
        if (v_count != 0) then
            update LEBEDEV_MA.JOURNAL jr set jr.ID_STATUS = (select st.ID_Status from LEBEDEV_MA.STATUS st where st.STATUS_NAME = 'Отменено') where jr.ID_TALON = p_id_talon;
            update LEBEDEV_MA.TALON tal set tal.ISOPEN = 1 where tal.ID_TALON = p_id_talon;
            v_cancel_status := 'Запись успешно отменена';
        else
            v_cancel_status := 'Отмена записи невозможна, повторите попытку завтра';
        end if;
    end if;
    return v_cancel_status;
end;

--Основная часть
declare
    v_id_talon number;
    v_cancel_status varchar2(200);
begin
    DBMS_OUTPUT.ENABLE();
    v_id_talon := 13;
    v_cancel_status := LEBEDEV_MA.cancel_sign_up_for_a_talon(p_id_talon => v_id_talon);
    DBMS_OUTPUT.PUT_LINE(v_cancel_status);
end;
--Выдать расписание больниц

--Функция
create or replace function LEBEDEV_MA.get_Schedule
    return sys_refcursor
    as
        v_cursor_schedule sys_refcursor;
    begin
        open v_cursor_schedule for
            select
               mo.Name as Назв_МедОрг,
               h.ID_Hospital as Айди_больницы,
               sch.DayOfWeek as День_недели,
               sch.START_WORK as Начало_работы,
               sch.END_WORK as Конец_работы
            from
                 LEBEDEV_MA.SCHEDULE sch
                 join LEBEDEV_MA.HOSPITALS h on sch.ID_HOSPITAL = h.ID_HOSPITAL
                 join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION;
        return v_cursor_schedule;
    end;

--Основная часть
declare
    v_cursor_schedule sys_refcursor;
    type t_record_schedule is
        record (
            mo_Name varchar2(999),
            h_ID_Hospital number,
            DayOfWeek varchar2(11),
            START_WORK date,
            END_WORK date);
    v_schedule t_record_schedule;
begin
    v_cursor_schedule := LEBEDEV_MA.get_Schedule();
    fetch v_cursor_schedule into v_schedule;
    if (v_cursor_schedule%found) then
        loop
            DBMS_OUTPUT.put_line(v_schedule.mo_Name || ' (' || v_schedule.h_ID_Hospital || '); ' || v_schedule.DayOfWeek || ': '
                || to_char(v_schedule.START_WORK, 'hh24:mi') || ' - ' || to_char(v_schedule.END_WORK, 'hh24:mi'));
            fetch v_cursor_schedule into v_schedule;
            exit when v_cursor_schedule%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Расписания не найдено');
    end if;
    close v_cursor_schedule;
end;
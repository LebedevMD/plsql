--Выдать расписание больниц

--Основная часть
declare
    type t_record_schedule is
        record (
            mo_Name varchar2(999),
            h_ID_Hospital number,
            DayOfWeek varchar2(11),
            START_WORK date,
            END_WORK date);
    v_schedule t_record_schedule;
begin
    open LEBEDEV_MA.pkg_hospitals.v_cursor_hospitals_schedule;
    fetch LEBEDEV_MA.pkg_hospitals.v_cursor_hospitals_schedule into v_schedule;
    if (LEBEDEV_MA.pkg_hospitals.v_cursor_hospitals_schedule%found) then
        loop
            DBMS_OUTPUT.put_line(v_schedule.mo_Name || ' (' || v_schedule.h_ID_Hospital || '); ' || v_schedule.DayOfWeek || ': '
                || to_char(v_schedule.START_WORK, 'hh24:mi') || ' - ' || to_char(v_schedule.END_WORK, 'hh24:mi'));
            fetch LEBEDEV_MA.pkg_hospitals.v_cursor_hospitals_schedule into v_schedule;
            exit when LEBEDEV_MA.pkg_hospitals.v_cursor_hospitals_schedule%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Расписания не найдено');
    end if;
    close LEBEDEV_MA.pkg_hospitals.v_cursor_hospitals_schedule;
end;
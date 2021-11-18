--*Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности, кол-ве врачей;
--отсортировать по типу: частные выше, по кол-ву докторов: где больше выше

--Процедура
create or replace procedure LEBEDEV_MA.show_all_hospitals(
    p_spec_name varchar2,
    out_cursor out sys_refcursor
)
as
begin
    open out_cursor for
        select
           h.ID_HOSPITAL as Айди_филиала,
           h.ISAVAILABLE as Доступность,
           tp.Name as Тип_больницы,
           count(d.Name) as Колво_врачей,
           mo.Name as Мед_Организация,
           sp.Name as Специальность
        from
             LEBEDEV_MA.HOSPITALS h
             join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION
             join LEBEDEV_MA.HOSPITAL_SPECIALITY hossp on h.ID_HOSPITAL = hossp.ID_HOSPITAL
             join LEBEDEV_MA.SPECIALITY sp on hossp.ID_SPECIALITY = sp.ID_SPECIALITY
             join LEBEDEV_MA.DOCTORS d on sp.ID_SPECIALITY = d.ID_SPECIALITY
             join LEBEDEV_MA.TYPE tp on h.ID_TYPE = tp.ID_TYPE
        where
              ((p_spec_name is not null and sp.NAME = p_spec_name)
                or (sp.NAME is not null and p_spec_name is null))
        group by
                 h.ID_HOSPITAL,
                 h.ISAVAILABLE,
                 sp.Name,
                 mo.NAME,
                 h.ID_TYPE,
                 tp.Name
        order by
                 case when tp.NAME = 'Частная' then 1 else 0 end,
                 Колво_врачей;
end;

--Основная часть
declare
    v_cursor_hosp sys_refcursor;
    type t_record_hospital is
        record(
            ID_Hospital number,
            ISAvailable number,
            typeHosp varchar2(20),
            countDoctors number,
            nameMedOrgan varchar2(500),
            specName varchar2(100));
    v_hospitals t_record_hospital;
    v_spec_name varchar2(50);
begin
    v_spec_name := 'Хирург';
    LEBEDEV_MA.show_all_hospitals(p_spec_name => v_spec_name, out_cursor => v_cursor_hosp);
    fetch v_cursor_hosp into v_hospitals;
    if v_cursor_hosp%found then
        DBMS_OUTPUT.PUT_LINE('Специальность: ' || v_hospitals.specName);
        loop
            DBMS_OUTPUT.PUT_LINE('ID_Больницы: ' || v_hospitals.ID_Hospital);
            DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_hospitals.ISAvailable);
            DBMS_OUTPUT.PUT_LINE('Кол-во докторов: ' || v_hospitals.countDoctors);
            DBMS_OUTPUT.PUT_LINE('Название мед. организации: ' || v_hospitals.nameMedOrgan);
            fetch v_cursor_hosp into v_hospitals;
            exit when v_cursor_hosp%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Больниц по данной специальности не найдено');
    end if;
    close v_cursor_hosp;
end;
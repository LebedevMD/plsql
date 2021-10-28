--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)
begin
    for i in (select sp.NAME as Специальность from LEBEDEV_MA.HOSPITALS h join LEBEDEV_MA.DOCTORS d on d.ID_HOSPITAL = h.ID_HOSPITAL
        join LEBEDEV_MA.SPECIALITY sp on d.ID_SPECIALITY = sp.ID_SPECIALITY where d.DELETED is null and sp.DELETED is null and h.DELETED is null group by sp.NAME)
    loop
        DBMS_OUTPUT.PUT_LINE(i.Специальность);
    end loop;
end;
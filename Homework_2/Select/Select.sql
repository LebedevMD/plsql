--Выдать все города по регионам
select c.Name as Город, r.Name as Регион from LEBEDEV_MA.REGIONS r join LEBEDEV_MA.CITIES c on r.ID_REGION = C.ID_REGION order by c.ID_REGION;

--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)
select sp.NAME as Специальность from LEBEDEV_MA.HOSPITALS h join LEBEDEV_MA.DOCTORS d on d.ID_HOSPITAL = h.ID_HOSPITAL
    join LEBEDEV_MA.SPECIALITY sp on d.ID_SPECIALITY = sp.ID_SPECIALITY where d.DELETED is null and sp.DELETED is null and h.DELETED is null group by sp.NAME;

--*Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности, кол-ве врачей;
--отсортировать по типу: частные выше, по кол-ву докторов: где больше выше, по времени работы: которые еще работают выше
select h.ID_HOSPITAL as Айди_филиала, h.ISAVAILABLE as Доступность, count(d.Name) as Колво_врачей,
       mo.Name as Мед_Организация, sp.Name as Специальность
    from LEBEDEV_MA.HOSPITALS h join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION join LEBEDEV_MA.HOSPITAL_SPECIALITY hossp on h.ID_HOSPITAL = hossp.ID_HOSPITAL
join LEBEDEV_MA.SPECIALITY sp on hossp.ID_SPECIALITY = sp.ID_SPECIALITY join LEBEDEV_MA.DOCTORS d on sp.ID_SPECIALITY = d.ID_SPECIALITY
where sp.NAME = 'Хирург' group by h.ID_HOSPITAL, h.ISAVAILABLE, sp.Name, mo.NAME, h.ID_TYPE order by case when h.ID_HOSPITAL = 1 then 1 else 0 end;

--Выдать всех врачей (неудаленных) конкретной больницы, отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше
select d.SURNAME as Фамилия, d.Name as Имя, g.Name as Гендер, s.NAME as Специальность, q.QUALIFICATION as Квалификация, d.SALARY as ЗП, d.RATING as Рейтинг, d.AREA as Участок
    from LEBEDEV_MA.DOCTORS d join LEBEDEV_MA.SPECIALITY s on d.ID_SPECIALITY = s.ID_SPECIALITY join LEBEDEV_MA.GENDER g on d.ID_GENDER = g.ID_GENDER
        join LEBEDEV_MA.QUALIFICATION q on d.ID_QUALIFICATION = q.ID_QUALIFICATION
where d.ID_HOSPITAL = 1 order by q.ID_QUALIFICATION, case when d.AREA = '2' then 0 else 1 end;

--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени
select d.Name as Доктор, t.STARTDATE as Начало, t.ENDDATE as Конец from LEBEDEV_MA.DOCTORS d join LEBEDEV_MA.TALON t on d.ID_DOCTOR = t.ID_DOCTOR where t.STARTDATE >= sysdate;

--**Создать метод записи с проверками пациента на соответствие всем пунктам для записи


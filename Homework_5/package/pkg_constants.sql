--Константы
create or replace package LEBEDEV_MA.pkg_constants
as
    --ID статуса "Подтверждено" для журнала
    c_journal_confirmed_constant constant number := 1;

    --ID статуса "Отменено" для журнала
    c_journal_canceled_constant constant number := 2;

    --ID типа "Частная" для больниц
    c_hospital_private_constant constant number := 2;
end;
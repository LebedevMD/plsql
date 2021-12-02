--Журнальный талон
create or replace type LEBEDEV_MA.t_journal_talon as object(
    id_patient number,
    id_talon number,
    status varchar2(12)
);

alter type LEBEDEV_MA.t_journal_talon
add constructor function t_journal_talon(
    id_patient number,
    id_talon number,
    status varchar2
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_journal_talon
as
constructor function t_journal_talon(
    id_patient number,
    id_talon number,
    status varchar2
) return self as result
    as
    begin
        self.id_patient := id_patient;
        self.id_talon := id_talon;
        self.status := status;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_journal_talon as table of LEBEDEV_MA.t_journal_talon;
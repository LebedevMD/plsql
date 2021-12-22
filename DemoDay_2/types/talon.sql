--Талон
create or replace type LEBEDEV_MA.t_talon as object(
    id_doctor number,
    isOpen number,
    startDate date,
    endDate date
);

alter type LEBEDEV_MA.t_talon
add constructor function t_talon(
    id_doctor number,
    isOpen number,
    startDate date,
    endDate date
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_talon
as
constructor function t_talon(
    id_doctor number,
    isOpen number,
    startDate date,
    endDate date
) return self as result
    as
    begin
        self.id_doctor := id_doctor;
        self.isOpen := isOpen;
        self.startDate := startDate;
        self.endDate := endDate;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_talons as table of LEBEDEV_MA.T_TALON;
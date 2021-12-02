--Расишренная больница
create or replace type LEBEDEV_MA.t_extended_hospital as object (
    hospital LEBEDEV_MA.T_HOSPITAL,
    schedule LEBEDEV_MA.T_HOSPITAL_SCHEDULE
);
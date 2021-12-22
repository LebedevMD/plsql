--Расширенный доктор
create or replace type LEBEDEV_MA.t_extended_doctor as object(
    doctor LEBEDEV_MA.T_DOCTOR,
    education LEBEDEV_MA.T_DOCTOR_EDUCATION
);
--Расширенный пациент
create or replace type LEBEDEV_MA.t_extended_patient as object(
    patient LEBEDEV_MA.T_PATIENT,
    documents LEBEDEV_MA.T_DOCUMENTS
);
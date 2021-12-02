--Документы пациента
create or replace type LEBEDEV_MA.t_documents as object(
    name varchar2(25),
    value varchar2(50)
);

alter type LEBEDEV_MA.t_documents
add constructor function t_documents(
    name varchar2,
    value varchar2
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_documents
as
constructor function t_documents(
    name varchar2,
    value varchar2
) return self as result
    as
    begin
        self.name := name;
        self.value := value;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_documents as table of LEBEDEV_MA.t_documents;
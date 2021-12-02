--Тип, возвращаемый из метода записи и отмены сообщение
create or replace type LEBEDEV_MA.t_message as object(
    signUp_status varchar2(5000)
);

alter type LEBEDEV_MA.t_message
add constructor function t_message(
    signUp_status varchar2
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_message
as
constructor function t_message(
    signUp_status varchar2
) return self as result
    as
    begin
        self.signUp_status := signUp_status;
        return;
    end;
end;

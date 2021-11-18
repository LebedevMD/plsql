create or replace package LEBEDEV_MA.first
is
    c_a constant number := 5;

    c_from_second number;

    procedure get_from_second;
end;

create or replace package LEBEDEV_MA.second
is
    c_b constant number := 7;

    c_from_first number;

    procedure get_from_first;
end;

create or replace package body LEBEDEV_MA.FIRST
is
    procedure get_from_second
    is
    begin
        c_from_second := LEBEDEV_MA.SECOND.c_b;
    end;
end;

create or replace package body LEBEDEV_MA.SECOND
is
    procedure get_from_first
    is
    begin
        c_from_first := LEBEDEV_MA.FIRST.c_A;
    end;
end;
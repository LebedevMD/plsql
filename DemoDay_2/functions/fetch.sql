--Фетчер
create or replace function LEBEDEV_MA.http_fetcher_get
(
    p_url varchar2, --Url запроса
    p_timeout number default 60, --Время ожидания соединения (секунды)
    p_executor varchar2 default 'Anonymous Block', --Информация о вызывающей программе
    p_debug boolean default false, --Нуже ли режим отладки
    out_success out boolean, --Флаг успеха запроса
    out_code out number --Конкретный код ответа на запрос
)
return clob --Возврат ответа в clob (текст)
as
    --Служебные строки для вывода инфо в режиме дебаг
    c_debug_delimiter varchar2(30) := '==============================';
    c_debug_subdelimiter varchar2(30) := '------------------------------';
    http_req utl_http.req; --Объект запроса
    http_resp utl_http.resp; --Объект ответа
    buffer_resp varchar2(32767); --Буфер под тело ответа
    eob boolean := false;
    temp_clob clob;
    response_clob clob; --Итоговое тело ответа
    p_method varchar2(3) := 'GET';
begin
    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --Установка ожидания соединения
    if (p_debug) then dbms_output.put_line('Timeout: '||p_timeout); end if;
    utl_http.set_transfer_timeout(p_timeout);

    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --Выполнение запроса
    --Формирование объекта запроса
    if (p_debug) then dbms_output.put_line('Begin request: '|| p_method || ' ' ||p_url); end if;
    http_req := utl_http.begin_request(
        url => p_url,
        method => p_method,
        http_version => utl_http.http_version_1_1
    );

    --Получение объекта ответа
    http_resp := utl_http.get_response(http_req);

    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --Проверка успеха запроса (успех - код 200)
    if (p_debug) then dbms_output.put_line('Response code: '||http_resp.status_code); end if;
    out_code := http_resp.status_code;
    out_success := http_resp.status_code in (200);

    if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;

    --Распаковка тела ответа
    dbms_lob.createtemporary(temp_clob, false); --Работа с формированием clob
    if (p_debug) then dbms_output.put_line('Response body:'); end if;
    declare
        v_chunk_number number := 1;
    begin
        while not (eob)
        loop
        begin
            --Потоковое чтение
            utl_http.read_text(http_resp, buffer_resp, 32767);

            if (p_debug) then dbms_output.put_line('-- '||v_chunk_number||' chunk '||c_debug_subdelimiter); end if;
            if (p_debug) then dbms_output.put_line(buffer_resp); end if;

            if (
                buffer_resp is not null
                and length(buffer_resp) > 0
            ) then
                --Наполняем результирующий clob
                dbms_lob.writeappend(
                    temp_clob,
                    length(buffer_resp),
                    buffer_resp
                );
            end if;

            v_chunk_number := v_chunk_number+1;
        exception
            --Обработка исключения, сбрасываемого при достижении конца потокового чтения
            when utl_http.end_of_body then
                eob := true;
        end;
        end loop;

        if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;

        --Распаковка заголовки ответа, только в дебаг режиме
        if (p_debug) then dbms_output.put_line('Response headers:'); end if;
        declare
            name  varchar2(256);
            value varchar2(1024);
        begin
            for i in 1..utl_http.get_header_count(http_resp) loop
                utl_http.get_header(http_resp, i, name, value);
                if (p_debug) then dbms_output.put_line('"'||name||'" : "'||value||'"'); end if;
            end loop;
        end;

        utl_http.end_response(http_resp);
    exception
        when others then
            utl_http.end_request(http_req);
    end;

    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --Логирование в случае ошибки
    if (out_success) then
        response_clob := temp_clob;
    else
        response_clob := temp_clob;
        LEBEDEV_MA.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit,
            '{"error":"' || http_resp.status_code
            || '","executor":"' || p_executor
            || '","url":"' || p_url
            || '","response":"' || substr(temp_clob,1,2000)
            || '"}');
    end if;

    --Освобождение памяти в запросе и в ответе
    utl_http.end_response(http_resp);
    --Освобождение памяти буфера clob
    dbms_lob.freetemporary(lob_loc => temp_clob);

    return response_clob;
exception
    when others then
        --Для отладки ошибок
        if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;
        if (p_debug) then dbms_output.put_line('Error: '||sqlerrm); end if;
        if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;
        if (p_debug) then dbms_output.put_line('Stack: '||dbms_utility.format_error_stack()); end if;
        if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;
        if (p_debug) then dbms_output.put_line('Trace: '||dbms_utility.format_error_backtrace()); end if;
        if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

        --Логирование ошибки
        LEBEDEV_MA.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit,
            '{"error":"' || sqlerrm
            || '","executor":"' || p_executor
            || '","url":"' || p_url
            || '","code":"' || http_resp.status_code
            || '","response":"' || substr(temp_clob,1,1000)
            || '","stack":"' || dbms_utility.format_error_stack()
            || '","backtrace":"' || dbms_utility.format_error_backtrace()
            || '"}');

        utl_http.end_response(http_resp);
        out_success := false;
        return null;
end;


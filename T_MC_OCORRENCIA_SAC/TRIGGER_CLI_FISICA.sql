CREATE OR REPLACE TRIGGER tr_t_mc_cli_fisica  
BEFORE INSERT OR UPDATE ON t_mc_cli_fisica 

FOR EACH ROW 
BEGIN 

    CASE
    WHEN INSERTING THEN
        IF  FN_VALIDA_CPF(:new.NR_CPF)='VALIDO' then dbms_output.put_line('Inserindo registro de CPF: '||:New.NR_CPF);
        ELSIF FN_VALIDA_CPF(:new.NR_CPF)= 'INVALIDO' then RAISE_APPLICATION_ERROR(-20001,'CPF INVALIDO') ;     
        ELSE RAISE_APPLICATION_ERROR(-20002,'ERRO DESCONHECIDO');
        END IF;
    WHEN UPDATING THEN
        IF  FN_VALIDA_CPF(:new.NR_CPF)='VALIDO' then dbms_output.put_line('Atualizando registro de CPF: '||:New.NR_CPF);
        ELSIF FN_VALIDA_CPF(:new.NR_CPF)= 'INVALIDO' then RAISE_APPLICATION_ERROR(-20001,'CPF INVALIDO') ;     
        ELSE RAISE_APPLICATION_ERROR(-20002,'ERRO DESCONHECIDO');
        END IF;
    END CASE;
END; 
/




SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION FN_VALIDA_CPF (V_DO_CPF VARCHAR2)
RETURN VARCHAR2 IS
 
V_CPF VARCHAR2 (11):= V_DO_CPF;
V_CPF_VALIDO VARCHAR2(11);
V_POSICAO NUMBER :=10;
V_POSICAO2 NUMBER :=10;
V_CALCULO NUMBER :=0;
V_CALCULO2 NUMBER :=0;
V_CALCULO3 NUMBER :=0;
v_digito_total NUMBER :=0;
V_DIG1 VARCHAR2 (1);
V_DIG2 VARCHAR2 (10);
BEGIN
    IF V_CPF =0 THEN
        RETURN('O número do CPF indicado é zero! Corrija e tente novamente! ');
        ELSE
        V_CPF_VALIDO := LPAD(V_CPF,11,'0');
    
    FOR X IN 1..9
    LOOP
        IF UPPER(SUBSTR(V_CPF_VALIDO,X,1)) NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN
         DBMS_OUTPUT.PUT_LINE('Digite apenas números ');
        END IF; 
    END LOOP;
    --CALCULO 1
    FOR Y IN 1..9
    LOOP
    V_CALCULO := V_CALCULO + (TO_NUMBER(SUBSTR(V_CPF_VALIDO,Y,1)) * V_POSICAO);
    V_POSICAO := V_POSICAO - 1;
    END LOOP;

    IF MOD(V_CALCULO,11)<2 THEN
        V_DIG1 :=0;
    ELSE
        V_DIG1 := 11-MOD(V_CALCULO,11);
    END IF;    
           
         --CALCULO 2
          FOR Z IN 2..9
    LOOP
    V_CALCULO2 := V_CALCULO2 + (TO_NUMBER(SUBSTR(V_CPF_VALIDO,Z,1)) * V_POSICAO2);
    V_POSICAO2 := V_POSICAO2 - 1;
    V_CALCULO3:=V_CALCULO2+(V_DIG1*2);
    END LOOP;

    IF MOD(V_CALCULO3,11)<2 THEN
        V_DIG2 :=0;
		v_digito_total:=V_DIG1||V_DIG2;
    ELSE
        V_DIG2 := 11-MOD(V_CALCULO3,11);
        v_digito_total:=V_DIG1||V_DIG2;
    END IF;  
    
    IF TO_NUMBER(SUBSTR(V_CPF_VALIDO,10,2))=v_digito_total THEN
    RETURN('VALIDO');
    ELSE
    RETURN('INVALIDO');
    END IF;
END IF;
END FN_VALIDA_CPF;
/



-- USAR FUNCAO FN_VALIDA_CPF

SELECT FN_VALIDA_CPF(56867127002)
FROM DUAL;

SELECT FN_VALIDA_CPF(N.NR_CPF)
FROM T_MC_CLI_FISICA N;


SET SERVEROUTPUT ON
BEGIN
            dbms_output.put_line(FN_VALIDA_CPF('0') );    
END;
/



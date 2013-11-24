--------------------------------------------------------
-- Archivo creado  - lunes-noviembre-11-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PR_CREAR_PLANPAGOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "FACIS"."PR_CREAR_PLANPAGOS" 
(
  P_K_ID_CREDITO IN CREDITO.K_ID_CREDITO%TYPE 
) AS 


  -- ESTE PROCEDIMIENTO CREA LOS REGISTROS
  -- CORRESPONDIENTES AL PLAN DE PAGOS
  -- SE LLAMA DESPUES DE APROBAR EL CREDITO
  
  
  L_F_APROBACION CREDITO.F_APROBACION%TYPE;
  L_V_CREDITO CREDITO.V_CREDITO%TYPE;
  L_Q_CUOTAS  CREDITO.Q_CUOTAS%TYPE;
  
  L_V_XINTERES PLANPAGOS.V_XINTERES%TYPE; 
  L_V_XCAPITAL PLANPAGOS.V_XCAPITAL%TYPE;
  
  L_K_ID_DESCRIPCION DESCRIPCION_TIPO_CREDITO.K_ID_DESCRIPCION%TYPE;  
  L_V_TASA_INTERES DESCRIPCION_TIPO_CREDITO.V_TASA_INTERES%TYPE;  
  
BEGIN


  
  SELECT V_CREDITO, Q_CUOTAS,F_APROBACION, K_ID_DESCRIPCION
  INTO   L_V_CREDITO, L_Q_CUOTAS, L_F_APROBACION, L_K_ID_DESCRIPCION
  FROM CREDITO
  WHERE K_ID_CREDITO = P_K_ID_CREDITO;

  SELECT  V_TASA_INTERES
  INTO    L_V_TASA_INTERES
FROM DESCRIPCION_TIPO_CREDITO 
WHERE K_ID_DESCRIPCION = L_K_ID_DESCRIPCION;

  
  L_V_XCAPITAL := L_V_CREDITO / L_Q_CUOTAS;
  L_V_XINTERES := L_V_XCAPITAL * L_V_TASA_INTERES;
    
  FOR l_numcuota IN 1 .. L_Q_CUOTAS LOOP
  
    INSERT INTO PLANPAGOS(
      K_ID_PLAN,
      Q_CUOTA,
      V_XINTERES,
      V_XCAPITAL,
      F_ACONSIGNAR,
      K_ID_CREDITO
    )
    VALUES
    (
      sequence_planpagos.nextval,
      l_numcuota,
      L_V_XINTERES,
      L_V_XCAPITAL,
      ADD_MONTHS(L_F_APROBACION,L_NUMCUOTA),
      P_K_ID_CREDITO
    );
    
    
  END LOOP;

  COMMIT;

END PR_CREAR_PLANPAGOS;

/
# Ejercicio 8

## **Punto 1. Tablas, columnas y restricciones nuevas o modificadas**

-   **Tabla Nueva (`dim_tarifa_agua`):**
    
    -   **Columnas:**
        
        -   `id_tarifa` (INTEGER, Primary Key, Autoincremental / `SERIAL`)
            
        -   `rango_m3_min` (NUMERIC(8,2), NOT NULL)
            
        -   `rango_m3_max` (NUMERIC(8,2), NOT NULL)
            
        -   `costo_m3_base` (NUMERIC(8,2), NOT NULL)
            
        -   `porcentaje_subsidio` (NUMERIC(5,2), NOT NULL)
            
        -   `anio_vigencia` (INTEGER, NOT NULL)
            
    -   **Restricciones:**
        
        -   `PRIMARY KEY (id_tarifa)`
            
        -   `CHECK (rango_m3_min >= 0)`
            
        -   `CHECK (rango_m3_max > rango_m3_min)`
            
        -   `CHECK (porcentaje_subsidio BETWEEN 0 AND 100)`
            
-   **Tabla Modificada (`fact_consumo_agua`):**
    
    -   **Columnas Agregadas:**
        
        -   `id_tarifa` (INTEGER, NULL)
            
        -   `monto_facturado_estimado` (NUMERIC(12,2), NULL)
            
        -   `monto_subsidio_pesos` (NUMERIC(12,2), NULL)
            
    -   **Restricción Agregada:**
        
        -   `CONSTRAINT fk_fact_tarifa FOREIGN KEY (id_tarifa) REFERENCES dim_tarifa_agua(id_tarifa)`



## Punto 4 Nota de media cuartilla

**Nota Explicativa sobre la Transformación de Esquema**

**Regla de transformación aplicada:**

Se aplicó la regla de normalización dimensional y extensión de modelo en estrella/copo de nieve. Se creó una nueva dimensión independiente (`dim_tarifa_agua`) dotada de clave primaria autoincremental y restricciones de dominio (`CHECK`), junto con la adición de una clave foránea (`id_tarifa`) y métricas derivadas (`monto_facturado_estimado`, `monto_subsidio_pesos`) en la tabla de hechos `fact_consumo_agua`.

**Justificación de la estrategia elegida:**

En el esquema original del Data Warehouse, los registros se limitaban a almacenar volúmenes físicos de consumo ($m^3$), lo que imposibilitaba realizar análisis de impacto financiero o de gasto público por concepto de subsidios. Se eligió externalizar la estructura tarifaria en una dimensión propia para desacoplar las reglas de negocio y políticas de precios del volumen operativo. De esta forma, el modelo permite evaluar la sostenibilidad financiera del suministro de agua y simular ajustes en los esquemas de subsidio sin alterar la integridad ni redundar datos en la tabla de hechos.

**Comportamiento e impacto sobre los datos existentes:**

Al aplicar `ALTER TABLE`, las nuevas columnas se agregaron aceptando valores nulos (`NULL`) para evitar inconsistencias inmediatas con los registros previamente cargados. Posteriormente, se realizó un proceso de ETL/actualización en lote (`UPDATE`) que clasificó retrospectivamente cada registro histórico evaluando su métrica de `consumo_total` frente a los rangos tarifarios definidos. Esto permitió asociar correctamente la clave foránea e imputar los montos de facturación y subsidio correspondientes sin generar huérfanos ni violar las restricciones de integridad referencial.


## Evidencias de Ejecución 
### 1. Creación de la dimensión y modificación del esquema ![Creación de dim_tarifa_agua y modificación de fact_consumo_agua](img/1.CreacionTablas.png) ### 2. Inserción de la estructura tarifaria ![Inserción de datos en dim_tarifa_agua](img/2.InsercionRegistros.png) ### 3. Actualización de datos históricos en la tabla de hechos ![Imputación de tarifas y montos en fact_consumo_agua](img/3.ActualizacionMasiva.png) ### 4. Resultado de la consulta analítica ![Resultado de la consulta agrupada por tarifa](img/4.ConsultaAnalitica.png)

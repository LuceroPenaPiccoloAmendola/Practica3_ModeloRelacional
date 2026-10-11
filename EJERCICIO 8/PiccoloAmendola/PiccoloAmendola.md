<div align= "center">

# Ejercicio 8 
## Proyecto asignado
## Nombre: Fiorella Karina del Carmen Piccolo Amendola

</div>

---

## 1. Estructura de tablas, columnas y restricciones modificadas

Los cambios aplicados sobre el esquema base del proyecto son los siguientes:

1. **Creación de la nueva dimensión (`dim_tipo_uso`):**
   * Se creó una tabla independiente para catalogar los tipos de consumo, estructurada de la siguiente manera:
     * `id_tipo_uso` (SERIAL, Clave Primaria - PK).
     * `categoria` (VARCHAR(50), NOT NULL, UNIQUE) para almacenar los valores descriptivos (ej. *Doméstico*, *Comercial*, *Industrial*, *Mixto*).
     * `descripcion` (TEXT) para detalles complementarios de cada sector.

2. **Modificación de la tabla de hechos (`fact_consumo_agua`):**
   * Se agregó una nueva columna de enlace de tipo entero:
     * `id_tipo_uso` (INT).
   * Se estableció una restricción de integridad referencial (**Clave Foránea - FK**) que vincula la tabla de hechos con la nueva dimensión:
     * `CONSTRAINT fk_fact_consumo_tipo_uso FOREIGN KEY (id_tipo_uso) REFERENCES dim_tipo_uso(id_tipo_uso) ON UPDATE CASCADE ON DELETE RESTRICT`.

---

## 4. Nota media cuartilla

* **Regla de transformación aplicada:** 
  Para cumplir con la modificación requerida, se aplicó una regla de adición de un nuevo miembro categórico. Esto consistió en crear desde cero una nueva tabla de dimensión independiente llamada `dim_tipo_uso` (con categorías como *Doméstico*, *Comercial*, *Industrial* y *Mixto*) y, posteriormente, alterar la tabla de hechos principal (`fact_consumo_agua`) añadiéndole una nueva columna (`id_tipo_uso`) conectada mediante una restricción de clave foránea (`FOREIGN KEY`).

* **Por qué elegí esta estrategia:** 
  Elegí esta estrategia porque es la forma más limpia y estructurada de modificar un Data Warehouse sin romper el diseño original. En lugar de guardar los tipos de uso como texto plano repetido dentro de la tabla de hechos (lo cual generaría redundancia), se creó una dimensión normalizada que garantiza la integridad de los datos, facilita las consultas agrupadas y permite escalar el catálogo de usos en el futuro de forma independiente.

* **Qué ocurre con los datos que ya existen cuando el cambio se aplica:** 
  Al momento de aplicar `ALTER TABLE` para agregar la nueva columna con su llave foránea en una tabla que ya contiene registros históricos, los registros existentes quedan temporalmente con un valor nulo (`NULL`) en esa nueva columna. Esto ocurre porque la estructura anterior no contemplaba ese dato. Para evitar errores, la estrategia contempla poblar posteriormente esos registros históricos mediante un proceso de actualización con los datos originales de *staging*, asegurando que ninguna métrica de consumo previa se pierda.

  ---

  ## Evidencias

 ### 1. Código se pudo ejecutar sin problema <img width="1366" height="727" alt="foto1" src="https://github.com/user-attachments/assets/03ffdd31-04d1-4359-bc12-03ff5a74fcf0" />
### 2. Creación de la nueva tabla <img width="1366" height="730" alt="foto3" src="https://github.com/user-attachments/assets/797538a2-b96a-4cfd-983d-b5197684a21e" />
### 3. Agregación de la nueva columna <img width="1366" height="730" alt="foto4" src="https://github.com/user-attachments/assets/957ecab1-101a-4c60-8465-5623c690272c" />
### 4. Consulta después cambio <img width="1366" height="730" alt="foto5" src="https://github.com/user-attachments/assets/fd754e03-1ab6-462f-93e7-85277dc68d46" />

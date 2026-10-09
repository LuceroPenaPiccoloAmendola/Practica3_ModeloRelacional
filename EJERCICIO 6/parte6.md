# Ejercicio 6: Implementación, documentación y validación de base de datos (SupermercadoDB)

---

##  6.1 Esquema completo
A continuación se presentan todas las tablas resultantes del modelo relacional, indicando sus columnas, tipos de datos, claves primarias, foráneas, restricciones y acciones referenciales.

### 1. Entidad base y especializaciones (Herencia)
* **`Persona`**
  * `Identificador` VARCHAR(20) [PK, NOT NULL]
  * `PrimerNombre` VARCHAR(50) [NOT NULL]
  * `SegundoNombre` VARCHAR(50)
  * `ApellidoPaterno` VARCHAR(50) [NOT NULL]
  * `ApellidoMaterno` VARCHAR(50)
  * `TipoPersona` VARCHAR(20) [NOT NULL]
* **`Cliente`**
  * `Identificador` VARCHAR(20) [PK, NOT NULL]
  * *FK:* `Identificador` -> `Persona(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`Empleado`**
  * `Identificador` VARCHAR(20) [PK, NOT NULL]
  * `Puesto` VARCHAR(50) [NOT NULL]
  * *FK:* `Identificador` -> `Persona(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`Proveedores`**
  * `Identificador` VARCHAR(20) [PK, NOT NULL]
  * `Calle` VARCHAR(100)
  * `Ciudad` VARCHAR(50)
  * `Num_Calle` VARCHAR(10)
  * *FK:* `Identificador` -> `Persona(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]

### 2. Tablas multivaluadas
* **`PersonaTeléfono`**
  * `Identificador` VARCHAR(20)
  * `Teléfono` VARCHAR(15)
  * *PK:* (`Identificador`, `Teléfono`)
  * *FK:* `Identificador` -> `Persona(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`ClienteCorreo`**
  * `Identificador` VARCHAR(20)
  * `Correo` VARCHAR(100)
  * *PK:* (`Identificador`, `Correo`)
  * *FK:* `Identificador` -> `Cliente(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`ProveedorCorreo`**
  * `Identificador` VARCHAR(20)
  * `Correo` VARCHAR(100)
  * *PK:* (`Identificador`, `Correo`)
  * *FK:* `Identificador` -> `Proveedores(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]

### 3. Productos y operaciones
* **`Productos`**
  * `Cod_Barra` VARCHAR(50) [PK, NOT NULL]
  * `Nombre` VARCHAR(100) [NOT NULL]
  * `Marca` VARCHAR(50)
  * `Precio` DECIMAL(10,2) [NOT NULL, CHECK (Precio >= 0)]
* **`Categoria`**
  * `Cod_Barra` VARCHAR(50)
  * `Identificador` VARCHAR(50)
  * `Nombre` VARCHAR(50) [NOT NULL]
  * *PK:* (`Cod_Barra`, `Identificador`)
  * *FK:* `Cod_Barra` -> `Productos(Cod_Barra)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`Inventario`**
  * `Cod_Barra` VARCHAR(50)
  * `Fecha_Actu` DATE
  * `Cantidad` INT [NOT NULL, CHECK (Cantidad >= 0)]
  * *PK:* (`Cod_Barra`, `Fecha_Actu`)
  * *FK:* `Cod_Barra` -> `Productos(Cod_Barra)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`Surtir`**
  * `Cod_Barra` VARCHAR(50)
  * `Identificador` VARCHAR(20)
  * *PK:* (`Cod_Barra`, `Identificador`)
  * *FKs:* 
    * `Cod_Barra` -> `Productos(Cod_Barra)` [ON DELETE CASCADE, ON UPDATE CASCADE]
    * `Identificador` -> `Proveedores(Identificador)` [ON DELETE CASCADE, ON UPDATE CASCADE]
* **`Venta`**
  * `Ticket` VARCHAR(20) [PK, NOT NULL]
  * `Identificador_cliente` VARCHAR(20) [NOT NULL]
  * `Identificador_empleado` VARCHAR(20) [NOT NULL]
  * `Total` DECIMAL(10,2) [NOT NULL, CHECK (Total >= 0)]
  * `Dia` INT [NOT NULL]
  * `Mes` INT [NOT NULL]
  * `Año` INT [NOT NULL]
  * `Empleadoventas` VARCHAR(50)
  * *FKs:*
    * `Identificador_cliente` -> `Cliente(Identificador)` [ON DELETE RESTRICT, ON UPDATE CASCADE]
    * `Identificador_empleado` -> `Empleado(Identificador)` [ON DELETE RESTRICT, ON UPDATE CASCADE]
* **`Incluir`**
  * `Ticket` VARCHAR(20)
  * `Cod_Barra` VARCHAR(50)
  * *PK:* (`Ticket`, `Cod_Barra`)
  * *FKs:*
    * `Ticket` -> `Venta(Ticket)` [ON DELETE CASCADE, ON UPDATE CASCADE]
    * `Cod_Barra` -> `Productos(Cod_Barra)` [ON DELETE RESTRICT, ON UPDATE CASCADE]

---

## 6.2 Script de definición de datos y pruebas de restricciones


```sql
DROP TABLE IF EXISTS Incluir CASCADE;
DROP TABLE IF EXISTS Venta CASCADE;
DROP TABLE IF EXISTS Surtir CASCADE;
DROP TABLE IF EXISTS Inventario CASCADE;
DROP TABLE IF EXISTS Categoria CASCADE;
DROP TABLE IF EXISTS Productos CASCADE;
DROP TABLE IF EXISTS ProveedorCorreo CASCADE;
DROP TABLE IF EXISTS Proveedores CASCADE;
DROP TABLE IF EXISTS ClienteCorreo CASCADE;
DROP TABLE IF EXISTS Empleado CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;
DROP TABLE IF EXISTS PersonaTeléfono CASCADE;
DROP TABLE IF EXISTS Persona CASCADE;

CREATE TABLE Persona (
    Identificador VARCHAR(20) PRIMARY KEY,
    PrimerNombre VARCHAR(50) NOT NULL,
    SegundoNombre VARCHAR(50),
    ApellidoPaterno VARCHAR(50) NOT NULL,
    ApellidoMaterno VARCHAR(50),
    TipoPersona VARCHAR(20) NOT NULL
);

CREATE TABLE Cliente (
    Identificador VARCHAR(20) PRIMARY KEY,
    CONSTRAINT fk_cliente_persona FOREIGN KEY (Identificador) 
        REFERENCES Persona (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Empleado (
    Identificador VARCHAR(20) PRIMARY KEY,
    Puesto VARCHAR(50) NOT NULL,
    CONSTRAINT fk_empleado_persona FOREIGN KEY (Identificador) 
        REFERENCES Persona (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Proveedores (
    Identificador VARCHAR(20) PRIMARY KEY,
    Calle VARCHAR(100),
    Ciudad VARCHAR(50),
    Num_Calle VARCHAR(10),
    CONSTRAINT fk_proveedor_persona FOREIGN KEY (Identificador) 
        REFERENCES Persona (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PersonaTeléfono (
    Identificador VARCHAR(20),
    Teléfono VARCHAR(15),
    CONSTRAINT pk_persona_telefono PRIMARY KEY (Identificador, Teléfono),
    CONSTRAINT fk_persona_telefono FOREIGN KEY (Identificador) 
        REFERENCES Persona (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ClienteCorreo (
    Identificador VARCHAR(20),
    Correo VARCHAR(100),
    CONSTRAINT pk_cliente_correo PRIMARY KEY (Identificador, Correo),
    CONSTRAINT fk_cliente_correo FOREIGN KEY (Identificador) 
        REFERENCES Cliente (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ProveedorCorreo (
    Identificador VARCHAR(20),
    Correo VARCHAR(100),
    CONSTRAINT pk_proveedor_correo PRIMARY KEY (Identificador, Correo),
    CONSTRAINT fk_proveedor_correo FOREIGN KEY (Identificador) 
        REFERENCES Proveedores (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Productos (
    Cod_Barra VARCHAR(50) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Marca VARCHAR(50),
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio >= 0)
);

CREATE TABLE Categoria (
    Cod_Barra VARCHAR(50),
    Identificador VARCHAR(50),
    Nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (Cod_Barra, Identificador),
    CONSTRAINT fk_categoria_producto FOREIGN KEY (Cod_Barra) 
        REFERENCES Productos (Cod_Barra) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Inventario (
    Cod_Barra VARCHAR(50),
    Fecha_Actu DATE,
    Cantidad INT NOT NULL CHECK (Cantidad >= 0),
    CONSTRAINT pk_inventario PRIMARY KEY (Cod_Barra, Fecha_Actu),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (Cod_Barra) 
        REFERENCES Productos (Cod_Barra) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Surtir (
    Cod_Barra VARCHAR(50),
    Identificador VARCHAR(20),
    CONSTRAINT pk_surtir PRIMARY KEY (Cod_Barra, Identificador),
    CONSTRAINT fk_surtir_producto FOREIGN KEY (Cod_Barra) 
        REFERENCES Productos (Cod_Barra) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_surtir_proveedor FOREIGN KEY (Identificador) 
        REFERENCES Proveedores (Identificador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Venta (
    Ticket VARCHAR(20) PRIMARY KEY,
    Identificador_cliente VARCHAR(20) NOT NULL,
    Identificador_empleado VARCHAR(20) NOT NULL,
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    Dia INT NOT NULL,
    Mes INT NOT NULL,
    Año INT NOT NULL,
    Empleadoventas VARCHAR(50),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (Identificador_cliente) 
        REFERENCES Cliente (Identificador) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_venta_empleado FOREIGN KEY (Identificador_empleado) 
        REFERENCES Empleado (Identificador) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Incluir (
    Ticket VARCHAR(20),
    Cod_Barra VARCHAR(50),
    CONSTRAINT pk_incluir PRIMARY KEY (Ticket, Cod_Barra),
    CONSTRAINT fk_incluir_venta FOREIGN KEY (Ticket) 
        REFERENCES Venta (Ticket) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_incluir_producto FOREIGN KEY (Cod_Barra) 
        REFERENCES Productos (Cod_Barra) ON DELETE RESTRICT ON UPDATE CASCADE
);
```

---

<img width="1366" height="729" alt="evidencia1" src="https://github.com/user-attachments/assets/61d573dc-c39e-4357-bd1b-ceb11441ed5e" />
<img width="1274" height="656" alt="evidencia2" src="https://github.com/user-attachments/assets/f00e9acf-7e2f-452e-b56b-1ebe5dc53f00" />

### Tres instrucciones de insert

<img width="1044" height="496" alt="insert1" src="https://github.com/user-attachments/assets/fb561aa7-c276-40a9-96ed-791225d4e43f" />
<img width="774" height="470" alt="insert3" src="https://github.com/user-attachments/assets/2c94803c-6cca-4092-ac90-598740df4b62" />
<img width="777" height="394" alt="insert2" src="https://github.com/user-attachments/assets/c3b04af3-e390-43ad-9e39-b341e1c2b7e3" />


---


## 6.3 Diagrama relacional

<img width="380" height="505" alt="image" src="https://github.com/user-attachments/assets/aeb29fb5-6b40-45a2-9044-d1dd8a56e11e" />

---

## 6.4 Diccionario de datos

| Tabla | Columna | Tipo | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| **Persona** | Identificador | VARCHAR(20) | PK, NOT NULL | Clave única de identificación universal. |
| **Persona** | PrimerNombre | VARCHAR(50) | NOT NULL | Primer nombre de la persona. |
| **Persona** | SegundoNombre | VARCHAR(50) | NULL | Segundo nombre opcional de la persona. |
| **Persona** | ApellidoPaterno | VARCHAR(50) | NOT NULL | Apellido paterno registrado. |
| **Persona** | ApellidoMaterno | VARCHAR(50) | NULL | Apellido materno registrado. |
| **Persona** | TipoPersona | VARCHAR(20) | NOT NULL | Clasificación del rol (Cliente, Empleado, Proveedor). |
| **Cliente** | Identificador | VARCHAR(20) | PK, FK (Persona) | Identificador heredado de Persona para clientes. |
| **Empleado** | Identificador | VARCHAR(20) | PK, FK (Persona) | Identificador heredado de Persona para empleados. |
| **Empleado** | Puesto | VARCHAR(50) | NOT NULL | Cargo o puesto laboral que desempeña el trabajador. |
| **Proveedores** | Identificador | VARCHAR(20) | PK, FK (Persona) | Identificador heredado de Persona para proveedores. |
| **Proveedores** | Calle | VARCHAR(100) | NULL | Nombre de la calle del domicilio del proveedor. |
| **Proveedores** | Ciudad | VARCHAR(50) | NULL | Ciudad de ubicación del proveedor. |
| **Proveedores** | Num_Calle | VARCHAR(10) | NULL | Número exterior o interior del domicilio. |
| **PersonaTeléfono** | Identificador | VARCHAR(20) | PK parcial, FK | Relación con la persona propietaria del teléfono. |
| **PersonaTeléfono** | Teléfono | VARCHAR(15) | PK parcial | Número telefónico de contacto. |
| **ClienteCorreo** | Identificador | VARCHAR(20) | PK parcial, FK | Relación con el cliente propietario del correo. |
| **ClienteCorreo** | Correo | VARCHAR(100) | PK parcial | Dirección de correo electrónico del cliente. |
| **ProveedorCorreo** | Identificador | VARCHAR(20) | PK parcial, FK | Relación con el proveedor propietario del correo. |
| **ProveedorCorreo** | Correo | VARCHAR(100) | PK parcial | Dirección de correo electrónico del proveedor. |
| **Productos** | Cod_Barra | VARCHAR(50) | PK, NOT NULL | Código de barras único identificador del producto. |
| **Productos** | Nombre | VARCHAR(100) | NOT NULL | Nombre comercial del producto. |
| **Productos** | Marca | VARCHAR(50) | NULL | Marca fabricante del producto. |
| **Productos** | Precio | DECIMAL(10,2) | NOT NULL, CHECK (>=0) | Precio unitario de venta al público (no negativo). |
| **Categoria** | Cod_Barra | VARCHAR(50) | PK parcial, FK | Producto asociado a la categoría. |
| **Categoria** | Identificador | VARCHAR(50) | PK parcial | Código o ID de la categoría. |
| **Categoria** | Nombre | VARCHAR(50) | NOT NULL | Nombre descriptivo de la categoría. |
| **Inventario** | Cod_Barra | VARCHAR(50) | PK parcial, FK | Producto registrado en el inventario. |
| **Inventario** | Fecha_Actu | DATE | PK parcial | Fecha de actualización del stock. |
| **Inventario** | Cantidad | INT | NOT NULL, CHECK (>=0) | Unidades disponibles en existencia. |
| **Surtir** | Cod_Barra | VARCHAR(50) | PK parcial, FK | Producto surtido. |
| **Surtir** | Identificador | VARCHAR(20) | PK parcial, FK | Proveedor encargado de surtir el producto. |
| **Venta** | Ticket | VARCHAR(20) | PK, NOT NULL | Folio único del comprobante de venta. |
| **Venta** | Identificador_cliente | VARCHAR(20) | NOT NULL, FK | Cliente que realiza la compra. |
| **Venta** | Identificador_empleado | VARCHAR(20) | NOT NULL, FK | Empleado que atiende y procesa la venta. |
| **Venta** | Total | DECIMAL(10,2) | NOT NULL, CHECK (>=0) | Monto total acumulado de la transacción. |
| **Venta** | Dia | INT | NOT NULL | Día en que se efectuó la venta. |
| **Venta** | Mes | INT | NOT NULL | Mes en que se efectuó la venta. |
| **Venta** | Año | INT | NOT NULL | Año en que se efectuó la venta. |
| **Venta** | Empleadoventas | VARCHAR(50) | NULL | Nombre descriptivo del empleado de ventas. |
| **Incluir** | Ticket | VARCHAR(50) | PK parcial, FK | Ticket de la venta relacionada. |
| **Incluir** | Cod_Barra | VARCHAR(50) | PK parcial, FK | Producto incluido en el detalle de la venta. |

---

## 6.5 Preservación del significado

Para comprobar que el diseño actual respeta exactamente lo que se planeó en el inventario del ejercicio 2, se verificó lo siguiente:

* **No se perdió ninguna entidad ni relación:** Todas las tablas principales (Persona, Productos, Venta,), las tablas secundarias (Inventario, Categoría) las relaciones (Surtir, Incluir) y los datos múltiples (PersonaTeléfono, correos) pasaron completos al modelo relacional sin omitir nada.
* **Las cardinalidades se reflejan en las restricciones:** 
  * Las relaciones de **uno a muchos (1:N)** se aplicaron usando llaves foráneas (FOREIGN KEY) en la tabla que depende de otra.
  * Las relaciones de **muchos a muchos (N:M)** se resolvieron creando tablas intermedias con llaves primarias compuestas.
* **Las reglas del modelo EER funcionan correctamente:** La división o herencia de la entidad Persona (en Cliente, Empleado y Proveedores) se conectó usando el mismo identificador como clave primaria y foránea. Además, se configuraron las reglas de borrado y actualización (ON DELETE CASCADE o RESTRICT).

BEGIN;


-- 1. Crear la tabla de dimensión para los tipos de uso
CREATE TABLE dim_tipo_uso (
    id_tipo_uso SERIAL PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);


INSERT INTO dim_tipo_uso (categoria, descripcion) VALUES 
('Doméstico', 'Consumo de agua en viviendas y hogares'),
('Comercial', 'Consumo en establecimientos de comercio y servicios'),
('Industrial', 'Consumo en plantas de producción y fábricas'),
('Mixto', 'Zonas con uso habitacional y comercial combinados');

-- 2. Modificar la tabla de hechos existente para agregar la relación
ALTER TABLE fact_consumo_agua 
ADD COLUMN id_tipo_uso INT;


ALTER TABLE fact_consumo_agua 
ADD CONSTRAINT fk_fact_consumo_tipo_uso 
FOREIGN KEY (id_tipo_uso) 
REFERENCES dim_tipo_uso(id_tipo_uso) 
ON UPDATE CASCADE 
ON DELETE RESTRICT;



-- 1. Insertar datos en las dimensiones para cumplir con las llaves foráneas
INSERT INTO dim_tiempo (id_tiempo, fecha, anio, mes, dia, bimestre) 
VALUES (1, '2026-01-01', 2026, 1, 1, 1)
ON CONFLICT (id_tiempo) DO NOTHING;

INSERT INTO dim_ubicacion (id_ubicacion, alcaldia, colonia) 
VALUES (1, 'Cuauhtémoc', 'Roma Norte')
ON CONFLICT DO NOTHING;

INSERT INTO dim_indice_des (id_indice_des, indice_des) 
VALUES (1, 'Medio')
ON CONFLICT DO NOTHING;

-- 2. Insertar un registro de prueba en la tabla de hechos usando la nueva dimensión
INSERT INTO fact_consumo_agua (
    id_tiempo, 
    id_ubicacion, 
    id_indice_des, 
    consumo_total, 
    id_tipo_uso
) VALUES (
    1, 
    1, 
    1, 
    150.50, 
    1
);

COMMIT;

-- 3. Ejecutar la consulta para validar los resultados
SELECT 
    t.categoria AS tipo_uso,
    COUNT(f.id_fact) AS total_registros,
    SUM(f.consumo_total) AS consumo_global
FROM 
    fact_consumo_agua f
JOIN 
    dim_tipo_uso t ON f.id_tipo_uso = t.id_tipo_uso
GROUP BY 
    t.categoria
ORDER BY 
    consumo_global DESC;

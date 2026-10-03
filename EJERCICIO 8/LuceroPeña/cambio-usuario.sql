
--1. CREACIÓN DE LA NUEVA DIMENSIÓN DE TARIFAS
CREATE TABLE IF NOT EXISTS dim_tarifa_agua (
    id_tarifa SERIAL PRIMARY KEY,
    rango_m3_min NUMERIC(8,2) NOT NULL CHECK (rango_m3_min >= 0),
    rango_m3_max NUMERIC(8,2) NOT NULL CHECK (rango_m3_max > rango_m3_min),
    costo_m3_base NUMERIC(8,2) NOT NULL,
    porcentaje_subsidio NUMERIC(5,2) NOT NULL CHECK (porcentaje_subsidio BETWEEN 0 AND 100),
    anio_vigencia INTEGER NOT NULL
);

-- 2. MODIFICACIÓN DE LA TABLA DE HECHOS
ALTER TABLE fact_consumo_agua 
ADD COLUMN IF NOT EXISTS id_tarifa INT,
ADD COLUMN IF NOT EXISTS monto_facturado_estimado NUMERIC(12,2),
ADD COLUMN IF NOT EXISTS monto_subsidio_pesos NUMERIC(12,2);

-- 3. VINCULACIÓN DE INTEGRIDAD REFERENCIAL
DO $$ 
BEGIN 
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_fact_tarifa'
    ) THEN
        ALTER TABLE fact_consumo_agua 
        ADD CONSTRAINT fk_fact_tarifa 
        FOREIGN KEY (id_tarifa) REFERENCES dim_tarifa_agua(id_tarifa);
    END IF;
END $$;

-- 4. POBLACIÓN DE LA DIMENSIÓN CON VALORES DE PRUEBA
INSERT INTO dim_tarifa_agua (rango_m3_min, rango_m3_max, costo_m3_base, porcentaje_subsidio, anio_vigencia) 
VALUES 
(0.00, 20.00, 15.50, 75.00, 2026),
(20.01, 50.00, 28.00, 40.00, 2026),
(50.01, 9999.00, 45.00, 0.00, 2026);

-- 5. ACTUALIZACIÓN RETROSPECTIVA DE LOS DATOS HISTÓRICOS
-- Nota: Se asignan los id_tarifa correspondientes a los registros insertados
UPDATE fact_consumo_agua 
SET id_tarifa = (SELECT id_tarifa FROM dim_tarifa_agua WHERE rango_m3_min = 0.00 LIMIT 1),
    monto_facturado_estimado = consumo_total * 15.50 * (1 - 0.75),
    monto_subsidio_pesos = consumo_total * 15.50 * 0.75
WHERE consumo_total <= 20.00 AND id_tarifa IS NULL;

UPDATE fact_consumo_agua 
SET id_tarifa = (SELECT id_tarifa FROM dim_tarifa_agua WHERE rango_m3_min = 20.01 LIMIT 1),
    monto_facturado_estimado = consumo_total * 28.00 * (1 - 0.40),
    monto_subsidio_pesos = consumo_total * 28.00 * 0.40
WHERE consumo_total > 20.00 AND id_tarifa IS NULL;
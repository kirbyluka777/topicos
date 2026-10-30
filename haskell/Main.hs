module Main where

import System.IO
import Tipos

arreglarLinea :: String -> String
arreglarLinea [] = []
arreglarLinea (x:xs)
    | x == '/' || x == '-' = '|'
    | otherwise = x : arreglarLinea xs

parsearVuelo :: String -> Vuelo
parsearVuelo linea =
    let partes = separarPorPipe (arreglarLinea linea)
    in case partes of
        (orig:dest:sal:lle:prec:cod:diasOp:_) -> 
            Vuelo {
                origen = limpiar espacios orig,
                destino = limpiar espacios dest,
                salida = horaToMins (limpiar espacios sal),
                llegada = horaToMins (limpiar espacios lle),
                precio = read (limpiar espacios prec) :: Float,
                codigo = limpiar espacios cod,
                dias = limpiar espacios diasOp
            }
        _ -> error "Error leyendo una línea del archivo"
  where
    espacios = id
    limpiar _ = unwords . words

separarPorPipe :: String -> [String]
separarPorPipe s = case break (== '|') s of
    (h, '|':t) -> h : separarPorPipe t
    (h, "")    -> [h]
    _          -> []

cargarVuelos :: IO [Vuelo]
cargarVuelos = do
    contenido <- readFile "../vuelos.txt"
    return (map parsearVuelo (filter (not . null) (lines contenido)))

vuelosSalida :: Ciudad -> [Vuelo] -> [Vuelo]
vuelosSalida c = filter (\v -> origen v == c)

vuelosLlegada :: Ciudad -> [Vuelo] -> [Vuelo]
vuelosLlegada c = filter (\v -> destino v == c)

menu :: [Vuelo] -> IO ()
menu vuelos = do
    putStrLn "\n--- LOGIEXPRESS - MENU PRINCIPAL ---"
    putStrLn "1. Ver todos los vuelos"
    putStrLn "2. Consultar salidas por ciudad"
    putStrLn "3. Consultar llegadas por ciudad"
    putStrLn "4. Configurar TMC"
    putStrLn "5. Salir"
    putStr "Elige una opcion: "
    hFlush stdout
    op <- getLine
    
    case op of
        "1" -> do
            mapM_ print vuelos
            menu vuelos
        "2" -> do
            putStr "Ciudad de origen: "
            hFlush stdout
            c <- getLine
            mapM_ print (vuelosSalida c vuelos)
            menu vuelos
        "3" -> do
            putStr "Ciudad de llegada: "
            hFlush stdout
            c <- getLine
            mapM_ print (vuelosLlegada c vuelos)
            menu vuelos
        "4" -> do
            putStr "Minutos de TMC: "
            hFlush stdout
            tmc <- getLine
            putStrLn $ "TMC fijado en " ++ tmc ++ " minutos."
            menu vuelos
        "5" -> putStrLn "Saliendo..."
        _   -> do
            putStrLn "Opcion invalida, prueba otra vez."
            menu vuelos

main :: IO ()
main = do
    putStrLn "Cargando vuelos..."
    vuelos <- cargarVuelos
    putStrLn $ "Cargados " ++ show (length vuelos) ++ " vuelos correctamente."
    menu vuelos
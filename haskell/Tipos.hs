module Tipos where

type Ciudad = String
type Minutos = Int
type Precio = Float
type CodigoVuelo = String
type DiasOperacion = String

data Vuelo = Vuelo {
    origen      :: Ciudad,
    destino     :: Ciudad,
    salida      :: Minutos,
    llegada     :: Minutos,
    precio      :: Precio,
    codigo      :: CodigoVuelo,
    dias        :: DiasOperacion
} deriving (Eq)

instance Show Vuelo where
    show v = codigo v ++ ": " ++ origen v ++ " -> " ++ destino v ++ 
             " | Salida: " ++ minsAHora (salida v) ++ 
             " | Llegada: " ++ minsAHora (llegada v) ++ 
             " | Precio: $" ++ show (precio v) ++ 
             " | Dias: " ++ dias v

horaToMins :: String -> Minutos
horaToMins s = 
    case break (== ':') s of
        (h, ':':m) -> read h * 60 + read m
        _          -> 0

minsAHora :: Minutos -> String
minsAHora m = 
    let h = m `div` 60
        minutos = m `mod` 60
        f x = if length x == 1 then "0" ++ x else x
    in f (show h) ++ ":" ++ f (show minutos)
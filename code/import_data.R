require(tidyverse)
require(here)

comprimentos = read_csv(here("data/vias_cg_qgis.csv")) %>% select(logradouro, tamanho, objectid)
vias_raw = read_csv(here("data/vias_cg.csv")) %>% 
    left_join(comprimentos) %>% 
    select(-objectid)
    

vias = vias_raw %>%
    group_by(nomelograd, logradouro) %>%
    mutate(trechos = 1) %>%
    summarise_at(
        vars(
            arvore,
            bancos,
            pontoonibu,
            pontotaxi,
            pontomotot,
            semaforo,
            trechos,
            faixapedes, 
            tamanho
        ),
        sum
    ) 

medianas = vias_raw %>%
    mutate(tamanho = if_else(tamanho == 0.0, 1, tamanho / 1)) %>% 
    group_by(nomelograd, logradouro) %>%
    mutate(
        arvores_100m = arvore / tamanho * 100,
        bancos_100m = bancos / tamanho * 100, 
        semaforos_100m = semaforo / tamanho * 100, 
        onibus_100m = pontoonibu / tamanho * 100,
    ) %>% 
    summarise_at(
        vars(
            arvores_100m, 
            bancos_100m, 
            semaforos_100m, 
            onibus_100m,
        ),
        funs(median, mean)
    ) 


vias %>%
    rename(comprimento = tamanho) %>% 
    left_join(medianas) %>% 
    write_csv(here("data/vias-tidy.csv"))

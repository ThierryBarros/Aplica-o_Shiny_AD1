PROFISSOES = frame_data(
    ~profissao, ~tipo_profissao,
    "Professor", "liberal",
    "Professora", "liberal",
    "Engenheiro", "liberal",
    "Jornalista", "liberal",
    "Doutor", "liberal",
    "Coronel", "militar",
    "Capitão", "militar",
    "Almirante", "militar",
    "Major", "militar",
    "Marechal", "militar",
    "General", "militar",
    "Santa", "religioso",
    "São", "religioso",
    "Santo", "religioso",
    "Papa", "religioso",
    "Frei", "religioso",
    "Pastor", "religioso",
    "Prefeito", "político",
    "Vereador", "político",
    "Senador", "político",
    "Deputado", "político",
    "Governador", "político",
    "Presidente", "político",
    "Maestro", "artista",
    "Barão", "nobre",
    "Conde", "nobre",
    "Dom", "nobre",
    "Cantor", "artista",
    "Compositor", "artista",
    "Juiz", "judiciário", 
    "Desembargador", "judiciário"
)

read_wrangle_data <- function(){
    require(tidyverse)
    require(here)
    require(stringr)
    
    read_csv(here("data/vias-tidy.csv"), 
                    col_types = cols(
                        nomelograd = col_character(),
                        logradouro = col_character(),
                        arvores_100m_median = col_double(),
                        bancos_100m_median = col_double(),
                        semaforos_100m_median = col_double(),
                        onibus_100m_median = col_double(),
                        arvores_100m_mean = col_double(),
                        bancos_100m_mean = col_double(),
                        semaforos_100m_mean = col_double(),
                        onibus_100m_mean = col_double(),
                        .default = col_integer()
                    )) %>% 
        filter(
            !is.na(nomelograd),
            !nomelograd %in% c("ACESSO")
        ) %>% 
        mutate(
            nomelograd = str_to_title(nomelograd) %>% str_replace_all('\n', ' '),
            profissao = word(nomelograd, 2), # infere do nome da rua
        ) %>% 
        left_join(PROFISSOES, by = "profissao") %>% 
        mutate(
            primeiro_nome = case_when(
                profissao %in% c("Das", "Da", "Do", "Dos", "Identificado", "Projetada", "Proj", "Sem") ~ NA_character_, 
                profissao %in% c("Barão", "Oeste") ~ word(nomelograd, 4), 
                is.na(tipo_profissao) ~ profissao, # não achou a profissão, deve ser nome
                TRUE ~ word(nomelograd, 3) 
            )
        ) %>%  
        mutate(
            sobrenome = if_else(is.na(primeiro_nome), NA_character_, word(nomelograd, -1)),
            profissao = if_else(is.na(tipo_profissao) | word(nomelograd, 1, 2) == "Não Identificado", NA_character_, profissao), 
            profissao = case_when(
                profissao %in% c("Professor", "Professora") ~ "Professor(a)", 
                profissao %in% c("São", "Santo", "Santa") ~ "Santo(a)",
                TRUE ~ profissao)
        ) 
}



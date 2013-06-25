
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_injetar_agua_para_recuperacao_secundariade_petroleo_em_Albacora",    
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Como injetar água para recuperação secundária de petróleo em Albacora?",
        "dr::ehRespondidaPor": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional","http://www.tecweb.inf.puc-rio.br/ontologies/dr#Raw_Water_Injection"]               
        },
        
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_usar_esta_tecnica2",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Como usar esta técnica?",
        "dr::ehRespondidaPor": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        }
    ],
    
    "ideas":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Sistema Convencional"
            
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Raw_Water_Injection",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Raw Water Injection"
			"dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_usar_esta_tecnica2"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Captar água próxima ao injetor e fazer tratamento mínimo"
            
        }
        
    ],
    "decisions":[
    	{
			"uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#decision3",
			"rdf::type": ["DR::Decisao"],
			"dr::aceita": false,
			"dr::resolve": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_injetar_agua_para_recuperacao_secundariade_petroleo_em_Albacora"],
			"dr::usa": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional"]
		},
		{
			"uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#decision4",
			"rdf::type": ["DR::Decisao"],
			"dr::aceita": true,
			"dr::resolve": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_medir_a_pressao_no_fundo_do_poco"],
			"dr::usa": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Raw_Water_Injection"]
		}
	],
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Depende_de_instalacao_de_varios_equipamentos",
            "swwiki::wikiLabel": "Depende de instalação de vários equipamentos",
			"rdf::type": ["DR::Argumento"],
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Pouca_area_disponivel_na_plataforma",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Pouca área disponível na plataforma",
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional"]
            
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Limitacao_no_swivel_da_FPSO",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Limitação no swivel da FPSO",
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Limitacao_de_cargas",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Limitação de cargas",
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Risco_de_incompatibilidade_de_aguas",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Risco de incompatibilidade de águas",
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Baixa_confiabilidade_nos_equipamentos_submarinos",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Baixa confiabilidade nos equipamentos submarinos",
			"dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Acrescimo_nas_reservas_do_campos",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Acréscimo nas reservas do campos",
			"dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        },
		{
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Incrustacoes_salinas_nos_produtores",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Incrustações salinas nos produtores",
			"dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        },       
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Geracao_de_H2S",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Geração de H2S",
			"dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        },
		{
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Perda_de_injetividade_nos_injetores",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Perda de injetividade nos injetores",
			"dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo"]
        }
    ]
}   

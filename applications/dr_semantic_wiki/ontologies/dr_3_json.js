
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_avaliar_a_variacao_de_injetividade",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Como avaliar a variação de injetividade?",
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sensores_de_pressao_de_fundo",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Historico_de_testes_de_pressoes",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Indicador_do_Indice_de_Injetividade"
		]               
        },
        
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_usar_esta_tecnica3",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Como usar esta técnica?",
        "dr::ehRespondidaPor": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao"]        
        }
    ],
    
    "ideas":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sensores_de_pressao_de_fundo",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Sensores de pressão de fundo"            
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Historico_de_testes_de_pressoes",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Histórico de testes de pressões"
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Indicador_do_Indice_de_Injetividade",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Indicador do Índice de Injetividade",
            "dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_usar_esta_tecnica3"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Usar dados de pressão na cabeça e vazão de injeção"
            
        }
        
    ],    
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Ha_carencia_de_sensores_operando",
            "swwiki::wikiLabel": "Há carência de sensores operando",
			"rdf::type": ["DR::Argumento"],
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sensores_de_pressao_de_fundo"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Ha_carencia_de_realizacao_de_testes",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Há carência de realização de testes",
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Historico_de_testes_de_pressoes"]
            
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Pode_introduzir_erros_nas_analises",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Pode introduzir erros nas análises",
            "dr::contra":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Nao_necessita_de_testes_de_formacao",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Não necessita de testes de formação",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao"]
        },
		{
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Nao_necessita_de_dados_de_sensores_de_fundo",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Não necessita de dados de sensores de fundo",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao"]
        }
    ]
}   

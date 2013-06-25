
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Quebra de Compressor",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Quebra de Compressor?",
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vazamento_de_gas_no_1_e_2_estagio",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vazamento_de_gas_no_3_estágio"
		]               
        },
        
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_vazamento",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causas de vazamento?",
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Trinca_no_interior_do_trocador"
		]
        },
		{
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_trincas",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causas de trincas?",
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Fadiga_termica"
		]
        }
    ],	
    
    "ideas":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Desprendimento_do_fundo_da_tela_do_filtro_cesto",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Desprendimento do fundo da tela do filtro cesto"			
        }        
        
    ],    
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Presenca_de_material_solido",
            "swwiki::wikiLabel": "Presença de material sólido",
			"rdf::type": ["DR::Argumento"],
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Desprendimento_do_fundo_da_tela_do_filtro_cesto"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Boroscopia_negativa",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Boroscopia negativa",
            "dr::contra":[
			"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Desprendimento_do_fundo_da_tela_do_filtro_cesto"			
			]
        }
    ]
}   

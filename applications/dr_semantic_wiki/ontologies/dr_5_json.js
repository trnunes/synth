
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causa_de_indisponibilidade_de_TC",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causa de indisponibilidade de TC?",
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
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vazamento_de_gas_no_1_e_2_estagio",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Vazamento de gás no 1º e 2º estágio",
			"dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_vazamento"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Furos_nas_placas_trincas_em_soldas_danos_as_gaxetas",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Furos nas placas, trincas em soldas, danos às gaxetas"
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vazamento_de_gas_no_3_estágio",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Vazamento de gás no 3º estágio",
            "dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_vazamento"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Trinca_no_interior_do_trocador",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Trinca no interior do trocador",
            "dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_vazamento"]
        },		
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Fadiga_termica",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Fadiga térmica"            
        }
        
    ],    
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Espessura_inadequada",
            "swwiki::wikiLabel": "Espessura inadequada",
			"rdf::type": ["DR::Argumento"],
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Furos_nas_placas_trincas_em_soldas_danos_as_gaxetas"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Esforcos_cíclicos_devido_a_pulsacao_de_gas",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Esforços cíclicos devido à pulsação de gás",
            "dr::aFavor":[
			"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Furos_nas_placas_trincas_em_soldas_danos_as_gaxetas",
			"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Fadiga_termica"
			]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Parada_de_bombas_durante_paradas_dos_TC",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Parada de bombas durante paradas dos TC",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Fadiga_termica"]
        }
    ]
}   

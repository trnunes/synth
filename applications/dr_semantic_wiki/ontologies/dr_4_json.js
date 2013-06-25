
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causa_de_indisponibilidade_de_TC",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causa de indisponibilidade de TC?",
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Danos_no_selo_de_gas_primario_do_compr_e_baixa",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Indicador_do_Indice_de_Injetividade"
		]               
        },
        
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_Vibracao",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causas de Vibração?",
        "dr::ehRespondidaPor": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Usar_dados_de_pressao_na_cabeca_e_vazao_de_injecao"]        
        }
    ],
    
    "ideas":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Danos_no_selo_de_gas_primario_do_compr_e_baixa",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Danos no selo de gás primário do compr. de baixa"
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Falta de selos sobressalentes"
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vibracao_excessiva_do_compressor",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Vibração excessiva do compressor",
            "dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_Vibracao"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Presenca_de_produtos_de_corrosao_e_incrustacao_nos_impelidores",
            "rdf::type": ["DR::Ideia"],
            "swwiki::wikiLabel": "Presença de produtos de corrosão e incrustação nos impelidores"
            
        }
        
    ],    
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Entrada_de_líquido_atraves_dos_vents_atmosfericos_dos_selos_interligados_com_os_vents_de_outros_sistemas_da_plataf",
            "swwiki::wikiLabel": "Entrada de líquido através dos vents atmosféricos dos selos interligados com os vents de outros sistemas da plataf.",
			"rdf::type": ["DR::Argumento"],
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Danos_no_selo_de_gas_primario_do_compr_e_baixa"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Economia",
			"rdf::type": ["DR::Argumento"],
            "swwiki::wikiLabel": "Economia",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes"]
            
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Ma_execucao",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Má execução",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Mau_planejamento",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Mau planejamento",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes"]
        },
		{
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Ma_execucao_do_comissionamento",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Má execução do comissionamento",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Presenca_de_produtos_de_corrosao_e_incrustacao_nos_impelidores"]
        },
		{
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Bom_acompanhamento",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Bom acompanhamento",
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Presenca_de_produtos_de_corrosao_e_incrustacao_nos_impelidores"]
        }
    ]
}   

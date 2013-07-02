
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causa_de_indisponibilidade_de_TC",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causa de indisponibilidade de TC?",
    	"swwiki::content":[
			"==Indisponibilidade do TC-A:==\n",
			"A principal causa de insisponibilidade do TC-A está relacionada aos [[danos no selo de gás primário do compressor de baixa|ehRespondidaPor->Danos no selo de gás primário do compr. de baixa]].",
			"<br/><br/>Como agravante não havia [[selo sobressalente|ehRespondidaPor->Falta de selos sobressalentes]] para substituição imediata.",
			
			"\n==Indisponibilidade do TC-B:==\n",
			"O TC-B apresentou [[ehRespondidaPor->Vibração excessiva do compressor]] LP, causado pela presença de produtos de corrosão e incrustração nos impelidores.",
			"Adicionalmente, houve vazamento de gás nos trocadores do tipo quote placa quote do 2º estágio de compressão.\n",
			
			"==Indisponibilidade do TC-C:==\n",
			"Assim como o TC-B, o TC-C apresentou os mesmos problemas de vibração excessiva do compressor LP e [[vazamento nos trocadores|ehRespondidaPor->Vazamento de gás no 1º e 2º estágio]]", 
			" da placa, no 1º e 2º estágios.",
			"<br/>Também ocorreram [[vazamentos de gás|ehRespondidaPor->Vazamento de gás no 3º estágio]] no trocador de calor do tipo circuito impresso (Heatric) que fica instalado no 3º estágio de compressão."
		],		
        "dr::ehRespondidaPor": [
			"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vazamento_de_gas_no_1_e_2_estagio",
			"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vazamento_de_gas_no_3_estágio"
		]               
        },
        
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_vazamento",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causas de vazamento?",
		"swwiki::content": [
			"Foram evidenciados [[ehRespondidaPor->Furos nas placas, trincas em soldas, danos às gaxetas]] dos trocadores.",
			"<br/>Os vazamentos possivelmente foram causados por [[trincas no interior do trocador|ehRespondidaPor->Trinca no interior do trocador]] de calor."
			
		],
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Furos_nas_placas_trincas_em_soldas_danos_as_gaxetas",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Trinca_no_interior_do_trocador"
		]
        },
		{
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_trincas",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causas de trincas?",
		"swwiki::content": [
			"A causa básica pode ter sido [[fadiga térmica|ehRespondidaPor->Fadiga térmica]] por oscilações de temperatura por falta de controle de vazão de água de resfriamento."
		],
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
            "swwiki::wikiLabel": "Furos nas placas, trincas em soldas, danos às gaxetas",
			"swwiki::content": [
			"As causas podem ser atribuidas à:\n",
			"* [[favorecidaPor->Espessura inadequada]] das placas;\n",
			"* [[esforços cíclicos|favorecidaPor->Esforços cíclicos devido à pulsação de gás]] impostos às placas pela pulsação do gás durante determinadas situações operacionais (paradas, partidas, recirculação)"
		]
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
			"swwiki::content": "[[Trinca|sugere->Causas de trincas?]] no interior do trocador de calor.",
            "dr::sugere": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_trincas"]
        },		
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Fadiga_termica",
            "rdf::type": ["DR::Ideia"],
			"swwiki::content": [
				"Os novos projetos, o Fabricante - Heatric - recomenda a instalação de uma válvula controladora de vazão para garantir uma vazão mínima",
				" de água, sem oscilações reduzindo os riscos de fadiga por conta de efeitos dinâmicos do escoamento de água."
			],
            "swwiki::wikiLabel": "Fadiga térmica"            
        }
        
    ],    
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Espessura_inadequada",
            "swwiki::wikiLabel": "Espessura inadequada",
			"swwiki::content": [
				"Espessura inadequada das placas."
			],
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

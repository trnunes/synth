
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causa_de_indisponibilidade_de_TC",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causa de indisponibilidade de TC?",    	
        "dr::ehRespondidaPor": [
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Danos_no_selo_de_gas_primario_do_compr_e_baixa",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes",
		"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Vibracao_excessiva_do_compressor"
		]               
        },
        
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Causas_de_Vibracao",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Causas de Vibração?",
        "dr::ehRespondidaPor": ["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Presenca_de_produtos_de_corrosao_e_incrustacao_nos_impelidores"]        
        }
    ],
    
    "ideas":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Danos_no_selo_de_gas_primario_do_compr_e_baixa",
            "rdf::type": ["DR::Ideia"],
			"swwiki::content":[
				"Os danos foram causados por [[entrada de líquido (óleo) através dos vents atmosféricos|favorecidaPor->Entrada de líquido através dos vents atmosféricos dos selos interligados com os vents de outros sistemas da plataf.]]",
				" dos selos interligados com os vents de outros sistemas da plataforma."				
			],
            "swwiki::wikiLabel": "Danos no selo de gás primário do compr. de baixa"
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes",
            "rdf::type": ["DR::Ideia"],
			"swwiki::content": [
				"Conforme relatado pela OP e registrado no relatório do GT, a contratada encontrava na ocasião diversos problemas de gestão"
			],
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
			"swwiki::content": [
				"O relatório de análise Solids Lab Report.pdf mostra alto teor de ferro. O relatório Relatório Técnico Piranema_Zedane - Locação Definitiva.pdf,",
				"no item 7.2 atesta que Observou-se que algumas linnhas da planta se encontravam sujas (abertura de alguns dos filtros temporários, por exemplo), ",
				"com alto grau de corrosão ou simplesmente abertas para a atmosfera com acúmulo de água e sal. As linhas mais importantes, e que são as mais atingidas, ",
				"são as linhas de sucção e descarga dos compressores e estas se encontram desmontadas. Dessa formaé forte a hipótese que o produto de corrosão tenha se ",
				"formado na fase de comissionamento da unidade, o que deve ser comprovado com análises periódicas, definidas na ação corretiva."
			],
            "swwiki::wikiLabel": "Presença de produtos de corrosão e incrustação nos impelidores"
            
        }
        
    ],    
    "arguments":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Entrada_de_líquido_atraves_dos_vents_atmosfericos_dos_selos_interligados_com_os_vents_de_outros_sistemas_da_plataf",
            "swwiki::wikiLabel": "Entrada de líquido através dos vents atmosféricos dos selos interligados com os vents de outros sistemas da plataf.",
			"swwiki::content": [
				"Isso se caracteriza como uma falha do projeto, apesar do fabricante da máquina (TC) recomendar que não haja interligação entre os vents.",
				"Essa falha é reincidente, conforme registrada no RTA UO-SEAL/ATP-SM/OP-AP 2010/0002A"
			],
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
			"swwiki::content":[
				"* O processo de suprimento da CONTRATADA não está implementado, causando impactos no desempenho operacional e garantia da integridade das instalações do FPSO PIRANEMA\n"				
			],
            "dr::aFavor":["http://www.tecweb.inf.puc-rio.br/ontologies/dr#Falta_de_selos_sobressalentes"]
        },
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Mau_planejamento",
            "rdf::type": ["DR::Argumento"],
			"swwiki::wikiLabel": "Mau planejamento",
			"swwiki::content":[
				"* A matriz de decisões técnicas e gerenciais centralizadas no exterior demanda tempo excessivo para solução dos problemas",
				"* A estrutura organizacional da CONTRATADA, na base em terra, não atende às demandas de gerenciamento da Unidade",
				"* O processo de suprimento da CONTRATADA não atende as demandas operacionais (tempo excessivo para quisição), sendo impactado também pela falta de uma política de sobressalentes para os equipamentos"
			],
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

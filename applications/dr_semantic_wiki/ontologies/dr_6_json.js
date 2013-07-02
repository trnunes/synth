
{
    "questions": [
        {
        "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Quebra_de_Compressor",
        "rdf::type": ["DR::Questao"],
        "swwiki::wikiLabel": "Quebra de Compressor?",
		"swwiki::content": [
			"Em maio/2010 houve quebra do compressor do MC-B do FPSO Cidade de Niterói por sucção de material sólido oriundo do [[desprendimento do fundo da tela do filtro cesto|ehRespondidaPor->Desprendimento do fundo da tela do filtro cesto]].",
			"<br/><br/>Em setembro/2010 foi observado que o fundo do filtro, dedicado ao MC-A havia se desprendido exatamente da mesma forma que ocorrera com o filtro do MC-B."		 
		],		 
        "dr::ehRespondidaPor": [
			"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Desprendimento_do_fundo_da_tela_do_filtro_cesto"
		]               
        }     
        
    ],	
    
    "ideas":[
        {
            "uri":"http://www.tecweb.inf.puc-rio.br/ontologies/dr#Desprendimento_do_fundo_da_tela_do_filtro_cesto",
            "rdf::type": ["DR::Ideia"],
			"swwiki::content": [
				"A RTA UN-RIO/ATP-MLL/OP/-P53 2010/0049A tratou do assunto e na ocasião fora recomendada a troca dos filtros porém",
				" não houve tempo para a troca de todos os filtros que foram mal especificados para a aplicação.",
				
				"<br/><br/>A vibração do MC-A quando da repartida sugeriu à OP-FPSO-NIT que, possivelmente, fragmentos da tela do filtro rompido tivessem migrado para o interior do compressor.",
				" Essa hipótese foi descartada primeiro com a [[boroscopia|contrariadaPor->Boroscopia negativa]], que não indicou a",
				" [[presença de material|favorecidaPor->Presença de material sólido]] no interior do compressor",
				" e a posterior partida do MC-A sem anormalidades que até hoje se encontra em operação.",
				"\n==O que fazer?==\n",
				"Garantir a correta especificação dos filtros do sistema de compressão de gás. Os filtros chapéu de bruxa são os mais adequados para essa aplicação.",
				"\n==Por que fazer?==\n",
				"A especificação inadequada dos filtros cesto que fazem a filtração de partículas pode causar falha mecânica com desprendimento de material sólido",
				" danificando as partes rotativas do sistema de compressão. Os filtros cesto, caso não tenham a estrutura mecânica adequada pode sofrer ruptura."				
			],
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

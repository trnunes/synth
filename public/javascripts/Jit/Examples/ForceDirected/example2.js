var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
  elem: false,
  // write: function(text){
    // if (!this.elem) 
      // this.elem = document.getElementById('log');
    // this.elem.innerHTML = text;
    // this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  // }
};


function init(){
  // init data
  var json = [
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Depende_de_instalacao_de_varios_equipamentos",
        "name": "Depende de instalação de vários equipamentos",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Depende_de_instalacao_de_varios_equipamentos&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Sistema_Convencional",
            "$color": "#FF7A04",
			"$border": "#0000FF",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Pouca_area_disponivel_na_plataforma",
        "name": "Pouca área disponível na plataforma",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Pouca_area_disponivel_na_plataforma&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Sistema_Convencional",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Limitacao_no_swivel_da_FPSO",
        "name": "Limitação no swivel da FPSO",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Limitacao_no_swivel_da_FPSO&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Sistema_Convencional",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Limitacao_de_cargas",
        "name": "Limitação de cargas",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Limitacao_de_cargas&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Sistema_Convencional",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional",
        "name": "Sistema Convencional",
        "data": {
            "type": "Idéia",
            "context": "/execute/context/http%3A%2F%2Fbase%23e09373b0-da55-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Sistema_Convencional&questao%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Como_injetar_agua_para_recuperacao_secundariade_petroleo_em_Albacora",
            "$color": "#F7E808",
            "$type": "star"
        },
        "adjacencies": [
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Depende_de_instalacao_de_varios_equipamentos",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Pouca_area_disponivel_na_plataforma",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Limitacao_no_swivel_da_FPSO",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Limitacao_de_cargas",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            }
        ]
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Acrescimo_nas_reservas_do_campos",
        "name": "Acréscimo nas reservas do campos",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%237aea21a0-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Acrescimo_nas_reservas_do_campos&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Risco_de_incompatibilidade_de_aguas",
        "name": "Risco de incompatibilidade de águas",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Risco_de_incompatibilidade_de_aguas&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Baixa_confiabilidade_nos_equipamentos_submarinos",
        "name": "Baixa confiabilidade nos equipamentos submarinos",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Baixa_confiabilidade_nos_equipamentos_submarinos&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Incrustacoes_salinas_nos_produtores",
        "name": "Incrustações salinas nos produtores",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Incrustacoes_salinas_nos_produtores&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Geracao_de_H2S",
        "name": "Geração de H2S",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Geracao_de_H2S&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Perda_de_injetividade_nos_injetores",
        "name": "Perda de injetividade nos injetores",
        "data": {
            "type": "Argumento",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Perda_de_injetividade_nos_injetores&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
            "$color": "#FF7A04",
            "$type": "circle"
        },
        "adjacencies": []
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
        "name": "Captar água próxima ao injetor e fazer tratamento mínimo",
        "data": {
            "type": "Idéia",
            "context": "/execute/context/http%3A%2F%2Fbase%23e09373b0-da55-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo&questao%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Como_usar_esta_tecnica2",
            "$color": "#F7E808",
            "$type": "star"
        },
        "adjacencies": [
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Acrescimo_nas_reservas_do_campos",
                "data": {
                    "link_type": "argumentos a favor",
                    "$color": "#0B9E0B"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Risco_de_incompatibilidade_de_aguas",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Baixa_confiabilidade_nos_equipamentos_submarinos",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Incrustacoes_salinas_nos_produtores",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Geracao_de_H2S",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Perda_de_injetividade_nos_injetores",
                "data": {
                    "link_type": "argumentos contra",
                    "$color": "#E50E0E"
                }
            }
        ]
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_usar_esta_tecnica2",
        "name": "Como usar esta técnica?",
        "data": {
            "type": "Questão",
            "context": "/execute/context/http%3A%2F%2Fbase%23de996350-da53-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Como_usar_esta_tecnica2&ideia%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Raw_Water_Injection",
            "$color": "#2409D4",
            "$type": "rectangle"
        },
        "adjacencies": [
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Captar_agua_proxima_ao_injetor_e_fazer_tratamento_minimo",
                "data": {
                    "link_type": "responde a",
                    "$color": "#F7E808"
                }
            }
        ]
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Raw_Water_Injection",
        "name": "Raw Water Injection",
        "data": {
            "type": "Idéia",
            "context": "/execute/context/http%3A%2F%2Fbase%23e09373b0-da55-11e0-a628-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Raw_Water_Injection&questao%5Bresource%5D%3Dhttp%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Como_injetar_agua_para_recuperacao_secundariade_petroleo_em_Albacora",
            "$color": "#F7E808",
            "$type": "star"
        },
        "adjacencies": [
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_usar_esta_tecnica2",
                "data": {
                    "link_type": "sugere",
                    "$color": "#ccb"
                }
            }
        ]
    },
    {
        "id": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Como_injetar_agua_para_recuperacao_secundariade_petroleo_em_Albacora",
        "name": "Como injetar água para recuperação secundária de petróleo em Albacora?",
        "data": {
            "type": "Questão",
            "context": "/execute/context/http%3A%2F%2Fbase%234cba4b20-da49-11e0-a312-001d92e8bb43?node=http%3A%2F%2Fwww.tecweb.inf.puc-rio.br%2Fontologies%2Fdr%23Como_injetar_agua_para_recuperacao_secundariade_petroleo_em_Albacora&widget=forced_directed",
            "$color": "#2409D4",
            "$type": "rectangle"
        },
        "adjacencies": [
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Sistema_Convencional",
                "data": {
					"decision":	true,
                    "link_type": "responde a",
                    "$color": "#F7E808"
                }
            },
            {
                "nodeTo": "http://www.tecweb.inf.puc-rio.br/ontologies/dr#Raw_Water_Injection",
                "data": {
                    "link_type": "responde a",
                    "$color": "#F7E808"
                }
            }
        ]
    }
]
  // end
  // init ForceDirected
  $jit.ForceDirected.Plot.NodeTypes.implement({  
    'customNode': {  
        'render': function (node, canvas) {
			var pos = node.pos.getc(true),
            dim = node.getData('dim');
			
			this.nodeHelper.star.render('fill', pos, dim, canvas);
			var ctx = canvas.getCtx();
			ctx.strokeStyle = '#0000FF';
			ctx.stroke();
			ctx.restore();
			
        },
		'contains': function(node,pos){ 
                var npos = node.pos.getc(true); 
                dim = node.getData('dim'); 
                return this.nodeHelper.star.contains(npos, pos, dim);                
		}		
    }
});

  var fd = new $jit.ForceDirected({
    //id of the visualization container
    injectInto: 'infovis',
    //Enable zooming and panning
    //with scrolling and DnD
    Navigation: {
      enable: true,
      type: 'Native',
      //Enable panning events only if we're dragging the empty
      //canvas (and not a node).
      panning: 'avoid nodes',
      zooming: 10 //zoom speed. higher is more sensible
    },
    // Change node and edge styles such as
    // color and width.
    // These properties are also set per node
    // with dollar prefixed data-properties in the
    // JSON structure.
	 
		
    Node: {
      overridable: true,
      dim: 20	  
    },
    Edge: {
      overridable: true,
	  type: "line",
      lineWidth: 3
    },
    // Add node events
    Events: {
      enable: true,
      type: 'Native',
      //Change cursor style when hovering a node
      onMouseEnter: function() {
        fd.canvas.getElement().style.cursor = 'move';
      },
      onMouseLeave: function() {
        fd.canvas.getElement().style.cursor = '';
      },
      //Update node positions when dragged
      onDragMove: function(node, eventInfo, e) {
        var pos = eventInfo.getPos();
        node.pos.setc(pos.x, pos.y);
        fd.plot();
      },
      //Implement the same handler for touchscreens
      onTouchMove: function(node, eventInfo, e) {
        $jit.util.event.stop(e); //stop default touchmove event
        this.onDragMove(node, eventInfo, e);
      }
    },
    //Number of iterations for the FD algorithm
    iterations: 200,
    //Edge length
    levelDistance: 130,
	onBeforePlotLine: function(adj){
			 
		if (adj.data.decision) {
			// alert(adj.nodeTo.data.$color)				
			adj.nodeFrom.data.$type = 'customNode';
		}		
	},
    // This method is only triggered
    // on label creation and only for DOM labels (not native canvas ones).
    onCreateLabel: function(domElement, node){
      // Create a 'name' and 'close' buttons and add them
      // to the main node label	  
      var nameContainer = document.createElement('span'),
          closeButton = document.createElement('span'),
          style = nameContainer.style;
      nameContainer.className = 'name';
      nameContainer.innerHTML = node.name;
      closeButton.className = 'close';
      closeButton.innerHTML = 'x';
      domElement.appendChild(nameContainer);
      domElement.appendChild(closeButton);
      style.fontSize = "0.8em";
      style.color = "#000000";
      //Fade the node and its connections when
      //clicking the close button
      closeButton.onclick = function() {
        node.setData('alpha', 0, 'end');
        node.eachAdjacency(function(adj) {
          adj.setData('alpha', 0, 'end');
        });
        fd.fx.animate({
          modes: ['node-property:alpha',
                  'edge-property:alpha'],
          duration: 500
        });
      };
	  
	 
      //Toggle a node selection when clicking
      //its name. This is done by animating some
      //node styles like its dimension and the color
      //and lineWidth of its adjacencies.
      nameContainer.onclick = function() {
        //set final styles
        fd.graph.eachNode(function(n) {
          if(n.id != node.id) delete n.selected;
          n.setData('dim', 20, 'end');
          n.eachAdjacency(function(adj) {
            adj.setDataset('end', {
              lineWidth: 3,              
            });
          });
        });
        if(!node.selected) {
          node.selected = true;		  
		  current_node_in_graph = node.data.context
          node.setData('dim', 25, 'end');
		  
          node.eachAdjacency(function(adj) {
            adj.setDataset('end', {
              lineWidth: 5,
              
            });
          });
        } else {
          delete node.selected;
        }
        //trigger animation to final styles
        fd.fx.animate({
          modes: ['node-property:dim',
                  'edge-property:lineWidth:color'],
          duration: 500
        });
        // Build the right column relations list.
        // This is done by traversing the clicked node connections.
        var html = "<h4>" + node.data.type + ": " + node.name + "</h4>",
            connections = [];
        node.eachAdjacency(function(adj){
          if(adj.getData('alpha')){
			link_type = adj.data.link_type
			if(adj.nodeFrom.data.type == "Questão"){
				link_type = "respondida por"
			}
			if((adj.nodeFrom.data.type == "Argumento") && (adj.nodeTo.data.type == "Idéia")){
				
				if(adj.data.link_type == "argumentos a favor"){
					link_type = "a favor de"
				}
				else{
					link_type = "contra"
				}				
			}			
			if(connections[link_type] === undefined){
				connections[link_type] = []
			};
			connections[link_type].push(adj.nodeTo.name)
		  };
        });
		
		for (link_type in connections){
			html += "<b> " + link_type + ":</b><ul><li>" + connections[link_type].join("</li><li>") + "</li></ul>"
		}
        //append connections information
        $jit.id('inner-details').innerHTML = html;
      };
    },
	
    // Change node styles when DOM labels are placed
    // or moved.
    onPlaceLabel: function(domElement, node){
      var style = domElement.style;
      var left = parseInt(style.left);
      var top = parseInt(style.top);
      var w = domElement.offsetWidth;
      style.left = (left - w / 2) + 'px';
      style.top = (top + 10) + 'px';
      style.display = '';
    }
  });
  // load JSON data.
  fd.loadJSON(json_string);
  // fd.loadJSON(json);
  // compute positions incrementally and animate.
  fd.computeIncremental({
    iter: 40,
    property: 'end',
    onStep: function(perc){
      // Log.write(perc + '% loaded...');
    },
    onComplete: function(){
      // Log.write('done');
      fd.animate({
        modes: ['linear'],
        transition: $jit.Trans.Elastic.easeOut,
        duration: 2500
      });
    }
  });
  // end
}
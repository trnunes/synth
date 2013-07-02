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
  {"id": "http://sr#o_Oquedeveserfeitoquan_66b3", 
  "name": "O que deve ser feito quando o validador não está de acordo com a determinação do tipo de item de conhecimento?", 
  "data": {"type": "DR::Questao", "context": "@current_url", "$color": "#00FF00", "$type": "rectangle"},"adjacencies": [{"nodeTo": "http://sr#o_Sugeriraocadastrador_fbf0","data": {"link_type": "respondsTo"}},{"nodeTo": "http://sr#o_Fazerelemesmoumanova_9bc9","data": {"link_type": "respondsTo"}},{"nodeTo": "http://sr#o_Discutiradeterminaod_0d91","data": {"link_type": "respondsTo"}},{"nodeTo": "http://sr#o_Sugeriraocadastrador_1bde","data": {"link_type": "respondsTo"}},{"nodeTo": "http://sr#o_Reforarnostreinament_9373","data": {"link_type": "respondsTo"}}]}];
  // end
  // init ForceDirected
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
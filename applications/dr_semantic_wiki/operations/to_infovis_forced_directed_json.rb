# require 'uuidtools'
# #params: reasoning_element_uri
# @current_url = current_url
@question_by_idea = SHDM::Context.find_by.shdm::context_name("QuestoesPorIdeiaCtx").execute.first
@idea_by_question_ctx = SHDM::Context.find_by.shdm::context_name("IdeiaPorQuestao").execute.first
@idea_by_question_param = "questao[resource]="
@in_favor_by_idea_ctx = SHDM::Context.find_by.shdm::context_name("ArgumentosAFavorPorIdeiaCtx").execute.first
@argument_by_idea_param = "ideia[resource]="
@against_by_idea_ctx = SHDM::Context.find_by.shdm::context_name("ArgumentosContraPorIdeiaCtx").execute.first

@current_url = current_url

def build_adjacency(node, edge_color)
  adj_string = '{"nodeTo": "' + node.uri +  '",'
  adj_string << '"data": {"link_type": "' + yield + '", "$color": "' + edge_color +'"}'
  adj_string << '}'  
end
@nodes = []

def build_json(element, context_url)
  
  link_type = "default"
  type = "ReasoningElement"
  adjacents = []
  data = ''
  if element.classes.include?(DR::Questao)    
      if(element.classes.include?(@pivot_class))    
        adjacents = element.dr::ehRespondidaPor.to_a.map{|idea| 
          [idea, "responde a", '#F7E808', @idea_by_question_ctx, @idea_by_question_param]
        }
    end
           
    type = "Questão"
    data = ', "$color": "#2409D4","$type": "rectangle"'
    
  elsif element.classes.include?(DR::Ideia)
    if(@pivot_class != DR::Argumento)
      adjacents = element.dr::favorecidaPor.to_a.map{|in_favor_argument| 
        [in_favor_argument, "argumentos a favor", '#0B9E0B', @in_favor_by_idea_ctx, @argument_by_idea_param]
      }
      
      adjacents += element.dr::contrariadaPor.to_a.map{|against_argument| 
        [against_argument, "argumentos contra", '#E50E0E', @against_by_idea_ctx, @argument_by_idea_param]
      }
    end
    
    if(@pivot_class != DR::Questao)
      adjacents += element.dr::responde.to_a.map{|question| 
        [question, "responde", '#2409D4', @question_by_idea, @argument_by_idea_param]
      } 
    end
    
    type = "Idéia"
    data = ', "$color": "#F7E808","$type": "star"'
  elsif element.classes.include?(DR::Argumento)
    
    if(element.classes.include?(@pivot_class))
      adjacents = element.dr::contra.to_a.map{|idea| 
        [idea, "contra", '#E50E0E', @against_by_idea_ctx, @argument_by_idea_param]
      }
      adjacents += element.dr::aFavor.to_a.map{|idea| 
        [idea, "a favor", '#0B9E0B', @against_by_idea_ctx, @argument_by_idea_param]
      }
    end
    
    type = "Argumento"
    data = ', "$color": "#FF7A04","$type": "circle"'
  end
  
  json_string = "{"
  json_string << '"id": ' + '"' + element.uri + '", '
  json_string << '"name": ' + '"' + element.rdfs::label.to_s + '", '
  json_string << '"data": ' + '{"type": "' + type + '", "context": "'+ context_url + '"' + data + '},'
  json_adjacencies = ""
  if(!adjacents.empty?)
    json_adjacencies = adjacents.map{|adj_and_link_type|
      url = "/execute/context/#{CGI::escape(adj_and_link_type[3].uri)}?node=#{CGI::escape(adj_and_link_type[0].uri)}&#{CGI::escape(adj_and_link_type[4] + element.uri)}"    
      build_json(adj_and_link_type[0], url)
      build_adjacency(adj_and_link_type[0], adj_and_link_type[2]){adj_and_link_type[1]}
    }.join(",")
  end
  
  
  json_string << '"adjacencies": [' + json_adjacencies + ']}'
  
  @nodes << json_string
  
end

reasoning_element = DR::ReasoningElement.new(reasoning_element_uri)
@pivot_class =  (reasoning_element.classes & [DR::Questao, DR::Ideia, DR::Argumento]).first
build_json(reasoning_element, @current_url)
return "[#{@nodes.join(',')}]"
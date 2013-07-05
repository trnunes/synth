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

def build_adjacency(node, data)
  adj_string = '{"nodeTo": "' + node.uri +  '",'
  adj_string << '"data": {' + data + '}'
  adj_string << '}'  
end
@nodes = []

def build_json(element, context_url, relation)
  
  link_type = "default"
  type = "ReasoningElement"
  adjacents = []
  data = ''
  if element.classes.include?(DR::Questao)    
      if(element.classes.include?(@pivot_class)||(relation == DR::sugere))            
        adjacents = element.dr::ehRespondidaPor.to_a.map{|idea|
          link_data = '"link_type": "responde a", "$color": "#F7E808"'
          decision = ActiveRDF::Query.new.select(:p).where(:p, DR::resolve, element).where(:p, DR::usa, idea).execute.first
          File.open("log/decisions.txt", 'w'){|f|f.write("DECISION: #{decision.to_s}")} 
          if decision && (decision.dr::aceita.to_s == "true")
            link_data << ', "decision": true'
          end
         
          [idea, DR::ehRespondidaPor, link_data, @idea_by_question_ctx, @idea_by_question_param]
        }
      end
           
    type = "Questão"
    data = ', "$color": "#2409D4","$type": "rectangle"'
    
  elsif element.classes.include?(DR::Ideia)
    if(@pivot_class != DR::Argumento)
      
      adjacents = element.dr::favorecidaPor.to_a.map{|in_favor_argument|
         
        link_data = '"link_type": "argumentos a favor", "$color": "#0B9E0B"'
        [in_favor_argument, DR::favorecidaPor, link_data, @in_favor_by_idea_ctx, @argument_by_idea_param]        
      }
      
      adjacents += element.dr::contrariadaPor.to_a.map{|against_argument|
        link_data = '"link_type": "argumentos contra", "$color": "#E50E0E"' 
        [against_argument, DR::contrariadaPor, link_data, @against_by_idea_ctx, @argument_by_idea_param]
      }
      
      adjacents += element.dr::sugere.to_a.map{|suggested_element|
        link_data = '"link_type": "sugere", "$color": "#ccb"'
        [suggested_element, DR::sugere, link_data, @against_by_idea_ctx, @argument_by_idea_param]
      }
    end
    
    if(@pivot_class != DR::Questao)
      adjacents += element.dr::responde.to_a.map{|question|
        link_data = '"link_type": "responde", "$color": "#2409D4"'
                
        
        [question, DR::responde, link_data, @question_by_idea, @argument_by_idea_param]
      }
    end    
    type = "Idéia"
    data = ', "$color": "#F7E808","$type": "star"'
  elsif element.classes.include?(DR::Argumento)
    
    if(element.classes.include?(@pivot_class))
      adjacents = element.dr::contra.to_a.map{|idea|
        link_data = '"link_type": "contra", "$color": "#E50E0E"'  
        [idea, DR::contra, link_data, @against_by_idea_ctx, @argument_by_idea_param]
      }
      adjacents += element.dr::aFavor.to_a.map{|idea|
        link_data = '"link_type": "a favor", "$color": "#0B9E0B"'
        [idea, DR::aFavor, link_data, @against_by_idea_ctx, @argument_by_idea_param]
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
      build_json(adj_and_link_type[0], url, adj_and_link_type[1])
      build_adjacency(adj_and_link_type[0], adj_and_link_type[2])
    }.join(",")
  end
  
  
  json_string << '"adjacencies": [' + json_adjacencies + ']}'
  
  @nodes << json_string
  
end

reasoning_element = DR::ReasoningElement.new(reasoning_element_uri)
@pivot_class =  (reasoning_element.classes & [DR::Questao, DR::Ideia, DR::Argumento]).first
build_json(reasoning_element, @current_url, "no_relation")
return "[#{@nodes.join(',')}]"
require 'uuidtools'
#params: reasoning_element_uri
@current_url = current_url
@idea_by_question_ctx = SHDM::Context.find_by.shdm::context_name("IdeiaPorQuestao").execute.first
@idea_by_question_param = "questao[resource]="
@in_favor_by_idea_ctx = SHDM::Context.find_by.shdm::context_name("ArgumentosAFavorPorIdeiaCtx").execute.first
@argument_by_idea_param = "ideia[resource]="
@against_by_idea_ctx = SHDM::Context.find_by.shdm::context_name("ArgumentosContraPorIdeiaCtx").execute.first


def idea_to_infovis_json(idea)
  context_url = "/execute/context/"
  json_string = "{"
  json_string << '"id": ' + '"' + idea.uri + '", '
  json_string << '"name": ' + '"' + idea.rdfs::label.to_s + '", '
  json_string << '"data": ' + '{"type": "idea", "uri": "'+ idea.uri + '", context: "'+ @current_url +'"},'
  json_string << '"children": ['
  arguments_in_favor = idea.dr::favorecidaPor.to_a
  arguments_against = idea.dr::contrariadaPor.to_a 
  arguments_in_favor.each{|argument|
    context_url = "/execute/context/#{CGI::escape(@in_favor_by_idea_ctx.uri)}?node=#{CGI::escape(argument.uri)}&#{CGI::escape(@argument_by_idea_param + idea.uri)}"
    json_string << '{"id": ' + '"' +  UUIDTools::UUID.random_create.to_s + '", '      
    json_string << '"name": ' + '"' + argument.rdfs::label.to_s + '", '
    json_string << '"data": ' + '{"type": "inFavor", "context": "'+ context_url + '"},'
    json_string << '"children": []},'
  }
  
  json_string[json_string.size-1] = "" if !arguments_in_favor.empty? && arguments_against.empty?
  arguments_against.each{|argument| 
    context_url = "/execute/context/#{CGI::escape(@against_by_idea_ctx.uri)}?node=#{CGI::escape(argument.uri)}&#{CGI::escape(@argument_by_idea_param + idea.uri)}"
    json_string << '{"id": ' + '"' +  UUIDTools::UUID.random_create.to_s + '", '      
    json_string << '"name": ' + '"' + argument.rdfs::label.to_s + '", '
    json_string << '"data": ' + '{"type": "against", "context": "'+ context_url + '"},'
    json_string << '"children": []},'
  } 
  json_string[json_string.size-1] = "" if !arguments_against.empty?
  json_string << ']}'
end

def argument_to_infovis_json(argument)
  return ""
end

def question_to_infovis_json(root_question)
  json_string = "{" 

  ideas = root_question.dr::ehRespondidaPor.to_a
  json_string << '"id": ' + '"' + root_question.uri + '", '
  json_string << '"name": ' + '"' + root_question.rdfs::label.to_s + '", '
  json_string << '"data": ' + '{"type": "question", "context": "'+ @current_url + '"},' 
  
  json_string << '"children": ['
  
  ideas.each{|idea|
      context_url = "/execute/context/#{CGI::escape(@idea_by_question_ctx.uri)}?node=#{CGI::escape(idea.uri)}&#{CGI::escape(@idea_by_question_param + root_question.uri)}"
      json_string << '{"id": ' + '"' + idea.uri + '", '
      json_string << '"name": ' + '"' + idea.rdfs::label.to_s + '", '
      json_string << '"data": ' + '{"type": "idea", "uri": "'+ idea.uri + '", context: "'+ context_url +'"},'
      json_string << '"children": ['
      arguments_in_favor = idea.dr::favorecidaPor.to_a
      arguments_against = idea.dr::contrariadaPor.to_a
      
      json_string << '{"id": ' + '"' + UUIDTools::UUID.random_create.to_s + '", '
      json_string << '"name": "a favor",' 
      json_string << '"data": ' + '{"type": "property"},'
      json_string << '"children": ['
      
      arguments_in_favor.each{|argument|
        
        
        context_url = "/execute/context/#{CGI::escape(@in_favor_by_idea_ctx.uri)}?node=#{CGI::escape(argument.uri)}&#{CGI::escape(@argument_by_idea_param + idea.uri)}"
        json_string << '{"id": ' + '"' +  UUIDTools::UUID.random_create.to_s + '", '      
        json_string << '"name": ' + '"' + argument.rdfs::label.to_s + '", '
        json_string << '"data": ' + '{"type": "inFavor", "context": "'+ context_url + '"},'
        json_string << '"children": []},'
      }
      json_string[json_string.size-1] = "" if !arguments_in_favor.empty? && arguments_against.empty?
      json_string << ']},'
      
      json_string << '{"id": ' + '"' + UUIDTools::UUID.random_create.to_s + '", '
      json_string << '"name": "contra",' 
      json_string << '"data": ' + '{"type": "property"},'
      json_string << '"children": ['
      
      arguments_against.each{|argument| 
        context_url = "/execute/context/#{CGI::escape(@against_by_idea_ctx.uri)}?node=#{CGI::escape(argument.uri)}&#{CGI::escape(@argument_by_idea_param + idea.uri)}"
        json_string << '{"id": ' + '"' +  UUIDTools::UUID.random_create.to_s + '", '      
        json_string << '"name": ' + '"' + argument.rdfs::label.to_s + '", '
        json_string << '"data": ' + '{"type": "against", "context": "'+ context_url + '"},'
        json_string << '"children": []},'
      } 
      json_string[json_string.size-1] = "" if !arguments_against.empty?
      json_string << ']},'
      
      json_string << ']},'
  }
  json_string[json_string.size-1] = ""
  json_string << ']}'  
end

reasoning_element = DR::ReasoningElement.new(reasoning_element_uri)

if(reasoning_element.classes.include?(DR::Questao))
   return question_to_infovis_json(reasoning_element)
elsif(reasoning_element.classes.include?(DR::Ideia))
  return idea_to_infovis_json(reasoning_element)
elsif(reasoning_element.classes.include?(DR::Argumento))
  return argument_to_infovis_json(reasoning_element)
end
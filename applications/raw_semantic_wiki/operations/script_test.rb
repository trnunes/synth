text = 'Web Services Description Language

Web Services Description Language (WSDL) � uma linguagem baseada em XML que prov� um modelo para a descri��o de Web Services. A atual vers�o da especifica��o � a 2.0, mantida pelo W3C, e d� suporte � utiliza��o (binding) de todos os m�todos de requisi��o HTTP. WDSL especifica a localiza��o de um servi�o e as opera��es (ou m�todos) que o servi�o oferece.

WSDL � comumente utilizada em combina��o com SOAP e XML Schema para o provimento de web services atrav�s da Internet. Uma aplica��o cliente conectando a um web service pode ler as defini��es WSDL do mesmo para determinar que funcionalidades est�o dispon�veis no servidor. Qualquer tipo especial de dados usado s�o embutidos na descri��o WSDL na forma de XML Schema, ao passo que SOAP � utilizado para as chamadas propriamente ditas das fun��es listadas na descri��o WSDL.


*Refer�ncias*

W3C Web Services Description Working Group


"http://www.w3.org/2002/ws/desc/":http://www.w3.org/2002/ws/desc/

Transpar�ncia do prof. Casanova


"http://www.inf.puc-rio.br/":http://www.inf.puc-rio.br/~casanova/Topicos-WebBD-Notas/modulo5c-webservices-WSDL-2.PDF

Tutoriais sobre WSDL


* "http://www.w3schools.com/wsdl/default.asp":http://www.w3schools.com/wsdl/default.asp
* "http://jmvidal.cse.sc.edu/talks/wsdl/":http://jmvidal.cse.sc.edu/talks/wsdl/

Web Services Description Language (WSDL) Version 2.0: RDF Mapping


* "http://www.w3.org/TR/wsdl20":http://www.w3.org/TR/wsdl20-rdf/'

text = text.gsub(/\[([^\]]*)\]/){|internal_link|internal_link.gsub("[", "[[").gsub("]", "]]")}
external_links = text.scan(/("([^"].*)":(http?:\/\/[\S]+))/).map{|match| 
    last_chr = match[2][match[2].size - 1].chr
    if last_chr == "."
      match[2][match[2].size - 1] = ""
      match[0][match[0].size - 1] = ""
    end
    match
  }
  links_to_gsub = external_links.map{|match| [match[0], "[#{match[2]} #{match[1]}]"]}
  links_to_gsub.each{|ext_link| text = text.gsub(ext_link[0], ext_link[1])}
  text = text.gsub(/\*[^\*].*\*/){|bold| bold.gsub("*", "'''")}
  text.to_s
def self.log(msg)

  File.open('./log/migrate_pages.log', 'a'){|f| f.write(msg << "\n")}
  
end
log(text.to_s)
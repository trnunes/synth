## context_title
## klass
## property
## index_label
require 'uuidtools'
id = UUIDTools::UUID.random_create.to_s
property = property.split("::")[0].downcase + property.split("::")[1]
param = SHDM::ContextParameter.new("http://base#"+id)
param.shdm::context_parameter_name = "param"
param.save

context = SHDM::Context.new("http://base#"+UUIDTools::UUID.random_create.to_s)
context.shdm::context_query  = "#{klass}.find_by.#{property}(param).execute"
context.shdm::context_title = context_title
context.shdm::context_parameters = param
param.shdm::parameter_context = context
context.save

ctx_param = SHDM::ContextAnchorNavigationAttribute("http://base#"+UUIDTools::UUID.random_create.to_s)
ctx_param.shdm::context_anchor_navigation_attribute_label_expression  = "label = self.rdfs::label.firstlabel; ||= self.compact_uri"
ctx_param.shdm::context_anchor_navigation_attribute_target_context = context
ctx_param.shdm::context_anchor_navigation_attribute_target_node_expression = "self"
ctx_param.shdm::context_anchor_navigation_attribute_target_parameters = param
ctx_param.shdm::navigation_attribute_index_position = "1"
ctx_param.shdm::navigation_attribute_name = index_label
ctx_param.rdfs::label = index_label
ctx_param.save

index = SHDM::ContextIndex.new("http://base#"+UUIDTools::UUID.random_create.to_s)
index.shdm::context_anchor_attributes = ctx_param
index.shdm::context_index_context = context
index.shdm::index_attributes = ctx_param
index.shdm::index_title = index_label
index.shdm::label = index_label
index.save

inctxClass = SHDM::InContextClass.new("http://base#"+UUIDTools::UUID.random_create.to_s)
inctxClass.shdm::in_context_class_class = eval(klass)
inctxClass.shdm::in_context_class_context = SHDM::Context.new("http://shdm#anyContext")
inctxClass.shdm::in_context_class_index_attributes  = index
inctxClass.shdm::in_context_class_navigation_attributes = index
inctxClass.save
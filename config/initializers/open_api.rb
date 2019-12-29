require 'open_api'

OpenApi::Config.class_eval do
  # Part 1: configs of this gem
  self.file_output_path = 'public/open_api'

  # Part 2: config (DSL) for generating OpenApi info
  open_api :swagger_doc, base_doc_classes: [ApiDoc]
  info version: '1.0.0', title: 'Homepage APIs'#, description: ..
  # server 'http://localhost:3000', desc: 'Internal staging server for testing'
  bearer_auth :Authorization
  global_auth :Authorization
end
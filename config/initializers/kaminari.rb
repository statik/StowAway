Kaminari.configure do |config|
  #config.page_method_name = :per_page_kaminari
end

# workaround re: https://github.com/sferik/rails_admin/issues/1828
require "will_paginate"
require "paper_trail"

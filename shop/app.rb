# -*- encoding : utf-8 -*-
module Tekala
  class Shop < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
    Rabl.register!

  end
end